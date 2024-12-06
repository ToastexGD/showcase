#include "../includes/geode.hpp"
#include "../managers/showcase_manager.hpp"

struct SBLevelInfoLayer : geode::Modify<SBLevelInfoLayer, LevelInfoLayer> {
  bool init(GJGameLevel *level, bool challenge) {
    if (!LevelInfoLayer::init(level, challenge)) {
      return false;
    }

    NodeIDs::provideFor(this);

    auto playMenu = this->getChildByID("play-menu");

    auto sprite = CircleButtonSprite::createWithSprite("clapper.png"_spr);

    auto btn = CCMenuItemSpriteExtra::create(
      sprite,
      this,
      menu_selector(SBLevelInfoLayer::onButton)
    );
    btn->setID("play-replay-button");
    btn->setPosition({27.f, 27.f});
    sprite->setScale(0.5f);
    btn->setZOrder(-2);
    btn->setVisible(false);

    if (playMenu != nullptr) {
      playMenu->addChild(btn);
      ShowcaseBotManager::get()->loadPlayReplayButton(m_level, this, btn);
    } else {
      log::info("play menu not found!");
    }


    return true;
  }

  void onButton(CCObject* sender) {
    ShowcaseBotManager::get()->onPlayReplayPressed(this);
  }
};
