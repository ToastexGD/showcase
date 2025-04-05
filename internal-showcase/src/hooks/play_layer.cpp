#include "../includes/geode.hpp"
#include "../managers/showcase_internal_manager.hpp"

struct SIPlayLayer : geode::Modify<SIPlayLayer, PlayLayer> {
  void levelComplete() {
    ShowcaseInternalManager::get()->onLevelComplete(this);
  }

  void resetLevel() {
    if (!ShowcaseInternalManager::get()->onLevelRestart(this)) {
      return;
    }
    PlayLayer::resetLevel();
  }
};
