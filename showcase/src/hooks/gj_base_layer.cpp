#include "../managers/showcase_manager.hpp"
#include "../includes/geode.hpp"

struct SBGJBaseGameLayer : geode::Modify<SBGJBaseGameLayer, GJBaseGameLayer> {
  void processCommands(float dt) {
    GJBaseGameLayer::processCommands(dt);
    ShowcaseBotManager::get()->onCommandProcessed(this);
  }

  void handleButton(bool down, int button, bool player1) {
    if (!ShowcaseBotManager::get()->onHandleUserButton(this, down, button, player1)) {
      return;
    }
    GJBaseGameLayer::handleButton(down, button, player1);
  }
};
