#include "../managers/showcase_internal_manager.hpp"
#include "../includes/geode.hpp"

struct SIGJBaseGameLayer : geode::Modify<SIGJBaseGameLayer, GJBaseGameLayer> {
  void processCommands(float dt) {
    GJBaseGameLayer::processCommands(dt);
    ShowcaseInternalManager::get()->onCommandProcessed(this);
  }
};
