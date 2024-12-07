#include "../includes/geode.hpp"
#include "../managers/showcase_auto_manager.hpp"
#include "../managers/showcase_manager.hpp"


struct SBCCScheduler : geode::Modify<SBCCScheduler, CCScheduler> {
  virtual void update(float dt) {
    if (false && ShowcaseAutoManager::get(false) != nullptr &&
        ShowcaseAutoManager::get()->m_autoEnabled &&
        ShowcaseBotManager::get()->m_state == ShowcaseBotState::Playing && PlayLayer::get()) {
      CCScheduler::update(dt * 50.0f);
    } else {
      CCScheduler::update(dt * 1.f);
    }
  }
};
