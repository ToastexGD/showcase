#include "../includes/geode.hpp"
#include "../managers/showcase_internal_manager.hpp"

struct SICCScheduler : geode::Modify<SICCScheduler, CCScheduler> {
  virtual void update(float dt) {
    if (CCDirector::get()->getRunningScene()->getChildByID("PlayLayer")) {
      if (CCDirector::sharedDirector()->getAnimationInterval() != 1.f / 1.f) {
        log::info("Setting to 1 FPS");
        CCDirector::sharedDirector()->setAnimationInterval(1.f / 1.f);
      }
      CCScheduler::update(dt * 500.0f);
    } else {
      if (CCDirector::sharedDirector()->getAnimationInterval() != 1.f / 30.f) {
        log::info("Setting to 30 FPS");
        CCDirector::sharedDirector()->setAnimationInterval(1.f / 30.f);
      }
      CCScheduler::update(dt * 1.f);
    }
  }
};
