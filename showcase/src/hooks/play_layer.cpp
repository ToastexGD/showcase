#include "../includes/geode.hpp"
#include "../managers/showcase_manager.hpp"

struct SBPlayLayer : geode::Modify<SBPlayLayer, PlayLayer> {
  void levelComplete() {
    if (!ShowcaseBotManager::get()->onLevelComplete(this)) {
      return;
    }
    PlayLayer::levelComplete();
  }

  void resetLevel() {
    PlayLayer::resetLevel();
    ShowcaseBotManager::get()->onLevelRestart(this);
  }

  void onQuit() {
    ShowcaseBotManager::get()->onLevelExit(this);
    PlayLayer::onQuit();
  }
};
