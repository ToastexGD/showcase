#include "showcase_internal_manager.hpp"
#include "Geode/Enums.hpp"
#include "Geode/GeneratedPredeclare.hpp"
#include "Geode/binding/FLAlertLayer.hpp"
#include "Geode/binding/GJGameLevel.hpp"
#include "Geode/binding/GameLevelManager.hpp"
#include "Geode/binding/GameManager.hpp"
#include "Geode/binding/LevelInfoLayer.hpp"
#include "Geode/binding/VideoOptionsLayer.hpp"
#include "Geode/cocos/cocoa/CCObject.h"
#include "Geode/cocos/robtop/xml/DS_Dictionary.h"
#include "Geode/loader/Event.hpp"
#include "Geode/loader/Loader.hpp"
#include "Geode/loader/Log.hpp"
#include "Geode/utils/web.hpp"
#include <WinBase.h>
#include <filesystem>
#include <gdr/gdr.hpp>
#include <matjson.hpp>
#include <optional>
#include <stdexcept>
#include "../utils/file_ops.hpp"

bool ShowcaseInternalManager::init() {
  if (!CCNode::init())
    return false;

  // Mute audio
  FMODAudioEngine::get()->setEffectsVolume(0.f);
  FMODAudioEngine::get()->setBackgroundMusicVolume(0.f);
  // Disable VSync
  if (CCApplication::sharedApplication()->getVerticalSyncEnabled()) {
    CCApplication::sharedApplication()->toggleVerticalSync(false);
  }
  // Set texture to LOW (only applies after launch and doesn't save between restarts)
  CCDirector::sharedDirector()->updateContentScale(TextureQuality::kTextureQualityLow);

  auto levelDataRes = readFileAsString("level.dat");
  if (levelDataRes.isErr()) {
    writeFail(fmt::format("Unable to read level.dat: {}", levelDataRes.unwrapErr()));
  }
  const auto levelData = levelDataRes.unwrap();
  log::info("Level data length:\n{}", levelData.size());

  const auto replayRes = ShowcaseBotReplay::importData("replay.gdr2");
  if (replayRes.isErr()) {
    writeFail(fmt::format("Unable to import replay: {}", replayRes.unwrapErr()));
  }
  m_replay = replayRes.unwrap();
  log::info("Replay:\n{}", "Loaded replay");

  std::thread worker([this, levelData]{
    std::this_thread::sleep_for(std::chrono::milliseconds(1000));
    queueInMainThread([this, levelData]{

      CCScene* s = LevelInfoLayer::scene(GJGameLevel::create(GameLevelManager::sharedState()->responseToDict(levelData, false), false), false);
      LevelInfoLayer* levelInfoLayer = static_cast<LevelInfoLayer*>(s->getChildByID("LevelInfoLayer"));
      if (!levelInfoLayer) {
        this->writeFail("LevelInfoLayer not found");
      }
      log::info("Created levelInfoLayer and scene:\n{}\n{}", levelInfoLayer, s);
      CCDirector::sharedDirector()->replaceScene(s);
      log::info("Replaced to scene");

      std::thread worker2([levelInfoLayer]{
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        queueInMainThread([levelInfoLayer]{

          log::info("will run onPlay");
          levelInfoLayer->onPlay(nullptr);
          log::info("ran onPlay");

        });
      });
      worker2.detach();
    });
  });
  worker.detach();

  return true;
}

void ShowcaseInternalManager::onLevelComplete(PlayLayer* playLayer) {
  log::info("SUCCESS!");
  writeJsonFile("response.json", matjson::makeObject({
    {"success", true},
  }));
  exit(0);
}

bool ShowcaseInternalManager::onLevelRestart(PlayLayer* playLayer) {
  m_restarts += 1;
  if (m_restarts <= 1) {
    return true;
  }
  writeFail("Bad replay");
}

void ShowcaseInternalManager::onLevelInfoLayerLoaded(LevelInfoLayer* levelInfoLayer) {
  m_restarts = 0;
  log::info("LOADED");
  if (!m_playedOnce) {
    m_playedOnce = true;
    queueInMainThread([levelInfoLayer]{
      levelInfoLayer->onPlay(nullptr);
    });
  }
}

std::vector<gdr::Input<>> ShowcaseInternalManager::getInputs(int frame) {
  std::vector<gdr::Input<>> result;
  std::copy_if(m_replay.inputs.begin(), m_replay.inputs.end(), std::back_inserter(result),
               [frame](const gdr::Input<> &input) { return input.frame == frame; });
  return result;
}

void ShowcaseInternalManager::onCommandProcessed(GJBaseGameLayer *baseGameLayer) {
  int currentFrame = baseGameLayer->m_gameState.m_currentProgress;

  for (const gdr::Input<> &input : getInputs(currentFrame)) {
    log::info("frame {}: Pressing {}. down {}.", input.frame, input.button, input.down);
    baseGameLayer->handleButton(input.down, static_cast<int>(input.button), !input.player2);
  }
}

void ShowcaseInternalManager::writeFail(std::string reason) {
  log::info("Replay failed: {}", reason);
  writeJsonFile("response.json", matjson::makeObject({
    {"success", false},
    {"reason", reason},
  }));
  exit(0);
}
