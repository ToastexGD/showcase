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
#include <WinBase.h>
#include <filesystem>
#include <gdr/gdr.hpp>
#include <matjson.hpp>
#include <optional>

const static int MONTH_IN_SECONDS = 30 * 24 * 60 * 60;

bool ShowcaseBotManager::init() {
  if (!CCNode::init())
    return false;

  m_gdVersion = GEODE_GD_VERSION_STRING;
  m_modVersion = Mod::get()->getVersion().toVString();
  m_modVersion.erase(0, 1); // Remove the 'v' from the version string.
  log::info("mod version: {}", m_modVersion);

  m_state = ShowcaseBotState::Idle;
  m_queueDir = Mod::get()->getSaveDir() / fmt::format("queue-{}-{}", m_gdVersion, m_modVersion);
  std::filesystem::create_directories(m_queueDir);

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
  log::info("DEBUG: State changed to recording.");
  m_state = ShowcaseBotState::Recording;
  tryUploadSingle();
}

void ShowcaseBotManager::verifyToken() {
  if (!isTermsAccepted()) {
    log::info("Emptying DashAuth token. Terms not accepted.");
    setDashAuthToken(std::nullopt);
    return;
  }

  auto savedToken = getDashAuthToken();

  // TODO: check if mod's server is running first and try to auth through server first.

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
            log::info("Failed to get replay({}): {}", value->code(), value != nullptr ? value->string().unwrapOr("No message.") : "No response.");
            return;
          }
          log::info("Got replay for level.");
          auto rawReplayDataStr = base64::from_base64(value->string().unwrap());
          std::vector<uint8_t> rawReplayData(rawReplayDataStr.begin(), rawReplayDataStr.end());

          const auto importedReplayRes = ShowcaseBotReplay::importData(rawReplayData);
          if (importedReplayRes.isErr()) {
            log::error("Failed to import replay data: {}", importedReplayRes.unwrapErr());
            return;
          }
          m_loadedReplay = importedReplayRes.unwrap();
          playReplayButton->setVisible(true);
          return;
        }
      });

  auto requestBody = matjson::makeObject({
      {"levelID", levelID},
      {"modVersion", m_modVersion},
      {"gdVersion", m_gdVersion},
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
  log::info("DEBUG: State changed to recording (2).");
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

    for (const gdr::Input<> &input : getInputs(currentFrame)) {
      baseGameLayer->handleButton(input.down, static_cast<int>(input.button), !input.player2);
    }
    return;
  }
}

bool ShowcaseBotManager::onLevelComplete(PlayLayer *playLayer) {
  switch (m_state) {
  case ShowcaseBotState::Idle: {
    return true;
  }
  case ShowcaseBotState::Recording: {
    if (shouldLevelBeReplay(playLayer->m_level)) {
      ShowcaseBotManager::get()->saveCurrentReplay(playLayer->m_level->m_levelID.value(), playLayer->m_level->m_levelVersion);
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
  bool isPractice = m_isCurrentRunPractice; // TODO: Get this from a field of a GD object
  return isRated && isClassic && levelID > 4000 && !isPractice;
}

void ShowcaseBotManager::onLevelRestart(PlayLayer *playLayer) {
  switch (m_state) {
  case ShowcaseBotState::Recording: {
    m_isCurrentRunPractice = false;

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
      m_isCurrentRunPractice = true;
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

std::vector<gdr::Input<>> ShowcaseBotManager::getInputs(int frame) {
  std::vector<gdr::Input<>> result;
  std::copy_if(m_replay.inputs.begin(), m_replay.inputs.end(), std::back_inserter(result),
               [frame](const gdr::Input<> &input) { return input.frame == frame; });
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

void ShowcaseBotManager::clearReplay() {
  m_getReplayListener.getFilter().cancel();
  m_replay.inputs.clear();
}

void ShowcaseBotManager::saveCurrentReplay(int32_t levelID, int32_t levelVersion) {
  log::info("Saving current replay to level {} to queue.", levelID);
  if (!std::filesystem::exists(m_queueDir)) {
    std::filesystem::create_directories(m_queueDir);
  }
  const std::filesystem::path queueFile = m_queueDir / fmt::format("{}-{}-{}.gdr2", levelID, levelVersion, time(nullptr));
  if (std::filesystem::exists(queueFile)) {
    std::filesystem::remove(queueFile);
  }

  const auto contentRes = m_replay.exportData();
  if (contentRes.isErr()) {
    log::error("Failed to export replay data: {}", contentRes.unwrapErr());
    return;
  }
  const auto content = contentRes.unwrap();


  std::ofstream file(queueFile, std::ios::binary);
  file.write(reinterpret_cast<const char *>(content.data()), content.size());
  file.close();

  log::info("Saved level {} to queue as {}.", levelID, queueFile.string());

  tryUploadSingle();
}

enum class ReplayFileEvaluation {
  Ignore,
  Delete,
  Ok,
};

bool getInfoFromSubmissionName(const char* submissionName, int* levelID, int* levelVersion, int* date) {
  return std::sscanf(submissionName, "%d-%d-%d.gdr2", levelID, levelVersion, date) == 3;
}

ReplayFileEvaluation evalReplayFileForUpload(std::filesystem::directory_entry& entry) {
  if (!entry.is_regular_file())
    return ReplayFileEvaluation::Ignore;

  if (entry.path().extension() != ".gdr2")
    return ReplayFileEvaluation::Ignore;

  int levelID, levelVersion, date;
  if (!getInfoFromSubmissionName(entry.path().filename().string().c_str(), &levelID, &levelVersion, &date))
    return ReplayFileEvaluation::Delete;

  if (time(nullptr) - date >= MONTH_IN_SECONDS)
    return ReplayFileEvaluation::Delete;

  const uintmax_t fileSize = std::filesystem::file_size(entry.path());
  if (fileSize > 5 * 1024 * 1024) // TODO: fetch dynamically from server
    return ReplayFileEvaluation::Delete;

  return ReplayFileEvaluation::Ok;
}

Result<matjson::Value> ShowcaseBotManager::makeSubmissionInfo(std::filesystem::directory_entry& entry) {
  int levelID, levelVersion, date;
  if (!getInfoFromSubmissionName(entry.path().filename().string().c_str(), &levelID, &levelVersion, &date)) {
    log::error("Failed uploading: Failed to get info from submission name.");
    return Err("Failed to get info from submission name.");
  }

  return Ok(matjson::makeObject({
    {"levelID", levelID},
    {"levelVersion", levelVersion},
    {"modVersion", m_modVersion},
    {"gdVersion", m_gdVersion},
  }));
}

void ShowcaseBotManager::tryUploadSingle() {
  log::info("Trying to upload.");

  if (!getDashAuthToken().has_value()) {
    log::error("Failed uploading: No DashAuth token.");
    return;
  }

  if (!std::filesystem::exists(m_queueDir)) {
    log::error("Failed uploading: Queue directory does not exist.");
    return;
  }

  std::vector<std::filesystem::directory_entry> file_entries(
      (std::filesystem::directory_iterator(m_queueDir)), std::filesystem::directory_iterator());

  // Clear unneeded files

  std::vector<std::filesystem::directory_entry> evaluatedEntries;

  for (size_t i = 0; i < file_entries.size(); i++) {
    ReplayFileEvaluation evaluation = evalReplayFileForUpload(file_entries[i]);
    log::info("Evaluation for file {}: {}", file_entries[i].path().filename().string(), static_cast<int>(evaluation));
    if (evaluation == ReplayFileEvaluation::Delete) {
      std::filesystem::remove(file_entries[i]);
    } else if (evaluation == ReplayFileEvaluation::Ok) {
      evaluatedEntries.push_back(file_entries[i]);
      break;
    }
  }

  if (evaluatedEntries.empty()) {
    log::info("No files to upload.");
    return;
  }

  auto submissionsInfo = matjson::Value::array();

  for (auto entryPtr : evaluatedEntries) {
    submissionsInfo.push(makeSubmissionInfo(entryPtr).unwrap());
  }

  const auto neededRequestBody = matjson::makeObject({
    {"dashAuthToken", getDashAuthToken().value()},
    {"submissions", submissionsInfo},
  });

  m_neededSubsReqListener.bind([this, submissionsInfo, evaluatedEntries](web::WebTask::Event *e) {
    if (web::WebResponse *value = e->getValue()) {
      if (value->code() != 200) {
        log::error("Error: got {} status code for needed_submissions.", value->code());
        if (!value->string().isErr()) {
          log::error("needed_submissions failed due to: {}", value->string().unwrap());
        }
        return;
      }

      if (value->json().isErr()) {
        log::error("Error while parsing needed_submissions's response: {}", value->json().unwrapErr());
        return;
      }

      auto jsonBody = value->json().unwrap();

      // Delete not needed files
      if (jsonBody.contains("notNeeded") && jsonBody["notNeeded"].isArray()) {
        std::vector<matjson::Value> notNeeded = jsonBody["notNeeded"].asArray().unwrap();
        for (auto notNeededIndex : notNeeded) {
          if (!notNeededIndex.isNumber()) {
            continue;
          }
          std::filesystem::remove(evaluatedEntries[notNeededIndex.asInt().unwrap()]);
        }
      }

      if (jsonBody.contains("submit") && jsonBody["submit"].isNumber()) {
        int chosenSubmissionIndex = jsonBody["submit"].asInt().unwrap();
        auto chosenEntry = evaluatedEntries[chosenSubmissionIndex];
        auto chosenSubmissionInfo = submissionsInfo[chosenSubmissionIndex];
        chosenSubmissionInfo.set("dataBase64", base64FileContent(chosenEntry));

        auto requestBody = matjson::makeObject({
            {"dashAuthToken", getDashAuthToken().value()},
            {"submission", chosenSubmissionInfo},
        });

        m_uploadSubReqListener.bind([this, chosenEntry](web::WebTask::Event *e) {
          if (web::WebResponse *value = e->getValue()) {
            if (value->code() != 200) {
              log::error("Error: got {} status code for upload_submission.", value->code());
              if (!value->string().isErr()) {
                log::error("upload_submission failed due to: {}", value->string().unwrap());
              }
              return;
            }
            if (std::filesystem::exists(chosenEntry)) {
              std::filesystem::remove(chosenEntry);
            }
            log::info("Uploaded successfully.");
          }
        });

        auto task = web::WebRequest()
                        .bodyJSON(requestBody)
                        .post(fmt::format("{}/upload_submission", SHOWCASE_SERVER));
        m_uploadSubReqListener.setFilter(task);
      }
    } else if (web::WebProgress *progress = e->getProgress()) {
    } else if (e->isCancelled()) {
    }
  });

  auto task = web::WebRequest()
                  .bodyJSON(neededRequestBody)
                  .post(fmt::format("{}/needed_submissions", SHOWCASE_SERVER));
  m_neededSubsReqListener.setFilter(task);
}
