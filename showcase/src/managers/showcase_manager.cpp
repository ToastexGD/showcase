#include "showcase_manager.hpp"
#include "../utils/file_content.hpp"
#include "../utils/string_to_int.hpp"
#include "Geode/Enums.hpp"
#include "Geode/GeneratedPredeclare.hpp"
#include "Geode/binding/FLAlertLayer.hpp"
#include "Geode/binding/GJGameLevel.hpp"
#include "Geode/binding/GameManager.hpp"
#include "Geode/binding/LevelInfoLayer.hpp"
#include "Geode/binding/VideoOptionsLayer.hpp"
#include "Geode/cocos/cocoa/CCObject.h"
#include "Geode/loader/Event.hpp"
#include "Geode/loader/Log.hpp"
#include "Geode/utils/web.hpp"
#include "base64.hpp"
#include "dashauth.hpp"
#include "showcase_auto_manager.hpp"
#include <gdr/gdr.hpp>
#include <matjson.hpp>
#include <optional>

bool ShowcaseBotManager::init() {
  if (!CCNode::init())
    return false;

  m_state = ShowcaseBotState::Idle;
  m_queueDir = Mod::get()->getSaveDir() / "queue";

  m_uploadSubsReqListener.bind([](auto e) {
    if (web::WebResponse *value = e->getValue()) {
      if (value->code() != 200) {
        log::info("Error: got {} status code for upload_submissions.", value->code());
        if (!value->string().isErr()) {
          log::info("upload_submissions failed due to: {}", value->string().unwrap());
        }
        return;
      }

      log::info("Added!");
    } else if (web::WebProgress *progress = e->getProgress()) {
    } else if (e->isCancelled()) {
    }
  });

  if (isTermsAccepted()) {
    verifyToken();
  } else {
    sendAcceptTerms();
  }

  return true;
}

void ShowcaseBotManager::sendAcceptTerms() {
  auto popup = geode::createQuickPopup(
      "Showcase - Terms",
      "The Showcase mod records your gameplay inputs on rated levels and sends them to an external "
      "server to potentially be added officially into the mod."
      "\nBy Pressing accept, you agree for this to happpen and to automatically be authenticated "
      "with DashAuth.",
      "No", "Agree",
      [this](FLAlertLayer *layer, bool btn2) {
        if (btn2) {
          Mod::get()->setSavedValue<bool>("terms-accepted", true);
          verifyToken();
        } else {
          Mod::get()->setSavedValue<bool>("terms-accepted", false);
        }
      },
      false, true);
  popup->m_scene = MenuLayer::get();
  popup->show();
}

bool ShowcaseBotManager::isTermsAccepted() {
  return Mod::get()->getSavedValue<bool>("terms-accepted", false);
}

void ShowcaseBotManager::setDashAuthToken(std::optional<std::string> token) {
  Mod::get()->setSavedValue<std::optional<std::string>>("dashauth-token", token);
}

std::optional<std::string> ShowcaseBotManager::getDashAuthToken() {
  return Mod::get()->getSavedValue<std::optional<std::string>>("dashauth-token");
}

void ShowcaseBotManager::onTokenVerified() {
  m_state = ShowcaseBotState::Recording;
  tryUpload();
}

void ShowcaseBotManager::loadReplyFromQueueFile(int32_t levelID) {
  std::filesystem::path queueFile = m_queueDir / fmt::format("{}.gdr", levelID);
  log::info("Loading queue file: {}", queueFile);
  std::vector<uint8_t> rawReplayData = binaryFileContent(queueFile);
  log::info("Bytes: {}", rawReplayData.size());

  m_replay = ShowcaseBotReplay::importData(rawReplayData);
  log::info("Loaded replay");
}

void ShowcaseBotManager::verifyToken() {
  if (!isTermsAccepted()) {
    log::info("Emptying DashAuth token. Terms not accepted.");
    setDashAuthToken(std::nullopt);
    return;
  }

  auto savedToken = getDashAuthToken();

  if (savedToken.has_value()) {
    m_verifyDashauthTokenListener.bind([this](auto e) {
      if (web::WebProgress *progress = e->getProgress())
        return;

      if (e->isCancelled()) {
        log::info("Failed to verify saved DashAuth token. Cancelled.");
        return;
      }

      if (web::WebResponse *value = e->getValue()) {
        if (value == nullptr || value->code() != 200) {
          log::info("Failed to verify saved DashAuth token. Requesting a new one...");
          setDashAuthToken(std::nullopt);
          verifyToken();
          return;
        }
        log::info("The saved DashAuth token verified successfully.");
        onTokenVerified();
      }
    });

    auto requestBody = matjson::makeObject({
        {"token", savedToken.value()},
    });

    auto task = web::WebRequest()
                    .header("Content-Type", "application/json")
                    .bodyJSON(requestBody)
                    .post(fmt::format("{}/api/v1/verify", DASHAUTH_SERVER));
    m_verifyDashauthTokenListener.setFilter(task);
  } else {
    dashauth::DashAuthRequest()
        .getToken(Mod::get(), fmt::format("{}/api/v1", DASHAUTH_SERVER))
        ->except([](const std::string &reason) {
          FLAlertLayer::create("Showcase - DashAuth Error",
                               fmt::format("Failed to get token. Reason: {}", reason), "OK")
              ->show();
        })
        ->then([this](const std::string &token) {
          log::info("got DashAuth token from server.");
          setDashAuthToken(token);
          onTokenVerified();
        });
  }
}

void ShowcaseBotManager::loadPlayReplayButton(GJGameLevel *level, LevelInfoLayer *levelInfoLayer,
                                              CCMenuItemSpriteExtra *playReplayButton) {
  auto autoManager = ShowcaseAutoManager::get();
  if (autoManager->m_autoEnabled) {
    return;
  }

  m_loadedReplay = std::nullopt;
  playReplayButton->setVisible(false);

  if (!shouldLevelBeReplay(level)) {
    return;
  }

  int32_t levelID = level->m_levelID.value();

  m_getReplayListener.bind(
      [this, levelID, levelInfoLayer, playReplayButton](web::WebTask::Event *e) {
        if (web::WebProgress *progress = e->getProgress())
          return;

        if (e->isCancelled()) {
          log::info("Failed to get replay because cancelled.");
          return;
        }

        if (web::WebResponse *value = e->getValue()) {
          if (value == nullptr || value->code() != 200) {
            log::info("Failed to get replay.");
            return;
          }
          log::info("Got replay for level.");
          // TODO make sure current scene is still level info layer
          // auto foundLevelInfoLayer =
          // CCDirector::get()->getRunningScene()->getChildByID("LevelInfoLayer"); log::info("Level
          // Info Layer: {}", foundLevelInfoLayer);
          auto rawReplayDataStr = base64::from_base64(value->string().unwrap());
          std::vector<uint8_t> rawReplayData(rawReplayDataStr.begin(), rawReplayDataStr.end());

          m_loadedReplay = ShowcaseBotReplay::importData(rawReplayData);
          playReplayButton->setVisible(true);
          return;
        }
      });

  auto requestBody = matjson::makeObject({
      {"levelID", levelID},
      {"modVersion", "1.0.0-alpha.1"},
      {"gdVersion", "2.2074"},
  });

  auto task = web::WebRequest()
                  .bodyJSON(requestBody)
                  .post(fmt::format("{}/get_submission", SHOWCASE_SERVER));
  m_getReplayListener.setFilter(task);
}

void ShowcaseBotManager::onPlayReplayPressed(LevelInfoLayer *levelInfoLayer) {
  if (!m_loadedReplay.has_value()) {
    return;
  }
  levelInfoLayer->onPlay(nullptr);
  m_state = ShowcaseBotState::Playing;
  m_replay = m_loadedReplay.value();
}

void ShowcaseBotManager::onLevelExit(PlayLayer *playLayer) {

  clearReplay();
  m_state =
      getDashAuthToken() != std::nullopt ? ShowcaseBotState::Recording : ShowcaseBotState::Idle;
}

void ShowcaseBotManager::onCommandProcessed(GJBaseGameLayer *baseGameLayer) {
  switch (m_state) {
  case ShowcaseBotState::Idle:
  case ShowcaseBotState::Recording:
    return;
  case ShowcaseBotState::Playing:
    int currentFrame = baseGameLayer->m_gameState.m_currentProgress;

    for (const gdr::Input &input : getInputs(currentFrame)) {
      baseGameLayer->handleButton(input.down, static_cast<int>(input.button), !input.player2);
    }
    return;
  }
}

bool ShowcaseBotManager::onLevelComplete(PlayLayer *playLayer) {
  auto autoManager = ShowcaseAutoManager::get();
  if (autoManager->m_autoEnabled) {
    return autoManager->onLevelComplete(playLayer);
  }

  switch (m_state) {
  case ShowcaseBotState::Idle: {
    return true;
  }
  case ShowcaseBotState::Recording: {
    if (shouldLevelBeReplay(playLayer->m_level)) {
      ShowcaseBotManager::get()->saveCurrentReplay(playLayer->m_level->m_levelID.value());
    }
    return true;
  }
  case ShowcaseBotState::Playing: {
    playLayer->resetLevelFromStart();
    return false;
  }
  }
}

bool ShowcaseBotManager::shouldLevelBeReplay(GJGameLevel *level) {
  int levelID = level->m_levelID.value();
  bool isRated = level->m_stars.value() >= 2;
  bool isClassic = !level->isPlatformer();
  return isRated && isClassic;
}

void ShowcaseBotManager::onLevelRestart(PlayLayer *playLayer) {
  auto autoManager = ShowcaseAutoManager::get();
  if (autoManager->m_autoEnabled) {
    autoManager->onLevelRestart(playLayer);
    return;
  }

  switch (m_state) {
  case ShowcaseBotState::Recording: {
    if (!shouldLevelBeReplay(playLayer->m_level)) {
      return;
    }

    int currentFrame = playLayer->m_gameState.m_currentProgress;
    // When I had a keypress in frame 1 and a checkpoint in frame 1 the
    // keypress wasn't registered. When I had a keypress in frame 68 and a
    // checkpoint in frame 68 the keypress was regsitered.
    if (currentFrame == 0 || currentFrame == 1) {
      clearReplay();
    } else {
      removeKeysSinceFrame(currentFrame + 1);
      // If holding an input while spawning (either from a checkpoint or from
      // the start) it happens on the NEXT frame. So we will prepend release
      // keypresses to the bot for the next frame. I don't think it matters if
      // we do it in current frame or next frame...
      m_replay.inputs.push_back(
          gdr::Input(currentFrame + 1, (int)PlayerButton::Jump, false, false));
      m_replay.inputs.push_back(gdr::Input(currentFrame + 1, (int)PlayerButton::Jump, true, false));
      m_replay.inputs.push_back(
          gdr::Input(currentFrame + 1, (int)PlayerButton::Left, false, false));
      m_replay.inputs.push_back(gdr::Input(currentFrame + 1, (int)PlayerButton::Left, true, false));
      m_replay.inputs.push_back(
          gdr::Input(currentFrame + 1, (int)PlayerButton::Right, false, false));
      m_replay.inputs.push_back(
          gdr::Input(currentFrame + 1, (int)PlayerButton::Right, true, false));
    }
    return;
  }
  case ShowcaseBotState::Playing: {
    return;
  }
  case ShowcaseBotState::Idle: {
    return;
  }
  }
}

bool ShowcaseBotManager::onHandleUserButton(GJBaseGameLayer *baseGameLayer, bool down, int button,
                                            bool player1) {
  switch (m_state) {
  case ShowcaseBotState::Idle: {
    return true;
  }
  case ShowcaseBotState::Playing: {
    // Don't allow user inputs. Only allow bot inputs.
    // Not perfect, but oh well.
    int currentFrame = baseGameLayer->m_gameState.m_currentProgress;
    return getInputs(currentFrame).size() > 0;
  }
  case ShowcaseBotState::Recording: {
    if (!shouldLevelBeReplay(baseGameLayer->m_level)) {
      return true;
    }
    int currentFrame = baseGameLayer->m_gameState.m_currentProgress;
    m_replay.inputs.push_back(gdr::Input(currentFrame, button, !player1, down));
    return true;
  }
  }
}

std::vector<gdr::Input> ShowcaseBotManager::getInputs(int frame) {
  std::vector<gdr::Input> result;
  std::copy_if(m_replay.inputs.begin(), m_replay.inputs.end(), std::back_inserter(result),
               [frame](const gdr::Input &input) { return input.frame == frame; });
  return result;
}

void ShowcaseBotManager::removeKeysSinceFrame(int frame) {
  for (auto it = m_replay.inputs.begin(); it != m_replay.inputs.end();) {
    if (it->frame >= frame) {
      it = m_replay.inputs.erase(it);
    } else {
      ++it;
    }
  }
}

void ShowcaseBotManager::clearReplay() { m_replay.inputs.clear(); }

void ShowcaseBotManager::saveReplay(int level) {
  log::info("Saving level {} to queue.", level);
  if (!std::filesystem::exists(m_queueDir)) {
    std::filesystem::create_directories(m_queueDir);
  }
  std::filesystem::path queueFile = m_queueDir / fmt::format("{}.gdr", level);
  if (std::filesystem::exists(queueFile)) {
    std::filesystem::remove(queueFile);
  }

  std::ofstream f(queueFile, std::ios::binary);
  auto data = m_replay.exportData(false);

  f.write(reinterpret_cast<const char *>(data.data()), data.size());
  f.close();

  log::info("Saved level {} to queue as {}.", level, queueFile.string());
  tryUpload();
}

void ShowcaseBotManager::saveCurrentReplay(int32_t levelID) {
  log::info("Saving current replay to level {} to queue.", levelID);
  if (!std::filesystem::exists(m_queueDir)) {
    std::filesystem::create_directories(m_queueDir);
  }
  std::filesystem::path queueFile = m_queueDir / fmt::format("{}.gdr", levelID);
  if (std::filesystem::exists(queueFile)) {
    std::filesystem::remove(queueFile);
  }

  auto content = m_replay.exportData(false);

  std::ofstream file(queueFile, std::ios::binary);
  file.write(reinterpret_cast<const char *>(content.data()), content.size());
  file.close();

  log::info("Saved level {} to queue as {}.", levelID, queueFile.string());

  tryUpload();
}

void ShowcaseBotManager::tryUpload() {
  log::info("Trying to upload");

  if (!getDashAuthToken().has_value()) {
    return;
  }

  matjson::Value submissionsMetadata = matjson::Value::array();

  if (!std::filesystem::exists(m_queueDir)) {
    log::info("Queue directory does not exist.");
    return;
  }

  std::vector<std::filesystem::directory_entry> file_entries(
      (std::filesystem::directory_iterator(m_queueDir)), std::filesystem::directory_iterator());

  for (size_t i = 0; i < file_entries.size(); i++) {
    auto entry = file_entries[i];
    log::info("Found file: {}", entry.path().string());

    if (!entry.is_regular_file())
      continue;

    if (entry.path().extension() != ".gdr")
      continue;

    const std::optional<int32_t> levelID = stringToInt32(entry.path().stem().string());
    if (!levelID.has_value()) {
      continue;
    }

    const uintmax_t fileSize = std::filesystem::file_size(entry.path());
    // TODO: Get max size(5MB) dynamically from the server.
    if (fileSize > 5 * 1024 * 1024) {
      log::warn("File {} is too big to upload.", entry.path().string());
      continue;
    }

    const std::string hashedContent = sha256FileContent(entry.path());

    const matjson::Value submissionMetadata = matjson::makeObject({
        {"levelID", levelID.value()},
        {"replayHash", hashedContent},
        {"modVersion", "1.0.0-alpha.1"},
        {"gdVersion", "2.2074"},
        {"_file_index", i},
    });

    submissionsMetadata.push(submissionMetadata);
  }

  auto requestBody = matjson::makeObject({
      {"dashAuthToken", getDashAuthToken().value()},
      {"submissionsMetadata", submissionsMetadata},
  });

  m_needSubsReqListener.bind([this, submissionsMetadata, file_entries](web::WebTask::Event *e) {
    if (web::WebResponse *value = e->getValue()) {
      if (value->code() != 200) {
        log::info("Error: got {} status code for needed_submissions.", value->code());
        if (!value->string().isErr()) {
          log::info("needed_submissions failed due to: {}", value->string().unwrap());
        }
        return;
      }

      auto jsonBody = value->json();
      if (jsonBody.isErr()) {
        log::info("Error while receiving needed_submissions: {}", jsonBody.unwrapErr());
        return;
      }

      matjson::Value submissions = matjson::Value::array();
      auto needed = jsonBody.unwrap().asArray().unwrap();
      for (size_t i = 0; i < submissionsMetadata.size(); ++i) {
        if (!(needed[i].asBool().unwrap())) {
          i++;
          continue;
        }

        auto &subMetadata = submissionsMetadata[i];

        auto file_entry = file_entries[subMetadata["_file_index"].asInt().unwrap()];

        const matjson::Value submission = matjson::makeObject({
            {"metadata", subMetadata},
            {"dataBase64", base64FileContent(file_entry.path())},
        });

        submissions.push(submission);
      }

      auto requestBody = matjson::makeObject({
          {"dashAuthToken", getDashAuthToken().value()},
          {"submissions", submissions},
      });

      log::info("Needed submissions: {}", submissions.size());

      if (submissions.size() == 0) {
        return;
      }

      auto task = web::WebRequest()
                      .bodyJSON(requestBody)
                      .post(fmt::format("{}/upload_submissions", SHOWCASE_SERVER));
      m_uploadSubsReqListener.setFilter(task);
    } else if (web::WebProgress *progress = e->getProgress()) {
    } else if (e->isCancelled()) {
    }
  });

  auto task = web::WebRequest()
                  .bodyJSON(requestBody)
                  .post(fmt::format("{}/needed_submissions", SHOWCASE_SERVER));
  m_needSubsReqListener.setFilter(task);
}
