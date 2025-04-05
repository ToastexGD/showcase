#include "../includes/geode.hpp"
#include "../managers/showcase_internal_manager.hpp"
#include "../main.hpp"

struct SICCDirector : geode::Modify<SICCDirector, CCDirector> {
  bool replaceScene(CCScene* p0) {
    if (p0->getChildByIDRecursive("MenuLayer") != nullptr) {
      onMenuLayer();
    }
    return CCDirector::replaceScene(p0);
  }

  void drawScene() {
    calculateDeltaTime();
    if (!m_bPaused) {
        m_pScheduler->update(m_fDeltaTime);
    }
    if (m_pNextScene) {
        setNextScene();
    }
    m_uTotalFrames++;
    if (m_bDisplayStats)
    {
        calculateMPF();
    }
  }
};
