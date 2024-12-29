#include "../includes/geode.hpp"
#include "../managers/showcase_auto_manager.hpp"
#include "../managers/showcase_manager.hpp"


struct SBCCScheduler : geode::Modify<SBCCScheduler, CCScheduler> {
  virtual void update(float dt) {
    if (ShowcaseAutoManager::get(false) != nullptr &&
        ShowcaseAutoManager::get()->m_autoEnabled &&
        ShowcaseBotManager::get()->m_state == ShowcaseBotState::Playing && PlayLayer::get() &&
        CCDirector::get()->getRunningScene()->getChildByID("PlayLayer")) {

      if (CCDirector::sharedDirector()->getAnimationInterval() != 1.f / 1.f) {
        log::info("Setting to 1 FPS");
        CCDirector::sharedDirector()->setAnimationInterval(1.f / 1.f);
      }
      CCScheduler::update(dt * 10.0f);
    } else {
      if (CCDirector::sharedDirector()->getAnimationInterval() != 1.f / 30.f) {
        log::info("Setting to 30 FPS");
        CCDirector::sharedDirector()->setAnimationInterval(1.f / 30.f);
      }
      CCScheduler::update(dt * 1.f);
    }
  }
};
