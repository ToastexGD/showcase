#include "../includes/geode.hpp"
#include "../managers/showcase_manager.hpp"

struct SBLevelInfoLayer : geode::Modify<SBLevelInfoLayer, LevelInfoLayer> {
  bool init(GJGameLevel *level, bool challenge) {
    if (!LevelInfoLayer::init(level, challenge)) {
      return false;
    }

    NodeIDs::provideFor(this);

    auto playMenu = static_cast<CCMenu*>(this->getChildByID("play-menu"));

    if (playMenu == nullptr) {
      log::info("play menu not found!");
      return true;
    }

    auto sprite = CircleButtonSprite::createWithSprite("clapper.png"_spr);

    sprite->setScale(0.5f);

    auto btn = CCMenuItemSpriteExtra::create(
      sprite,
      this,
      menu_selector(SBLevelInfoLayer::onButton)
    );
    btn->setID("play-replay-button");
    btn->setPosition({27.f, 27.f});
    btn->setZOrder(-2);
    btn->setVisible(false);
    CCMenu *menu = CCMenu::create();
    menu->setTouchPriority(playMenu->getTouchPriority()-1);
    menu->setPosition(playMenu->getPosition());
    menu->setContentSize(playMenu->getContentSize());
    menu->setAnchorPoint(playMenu->getAnchorPoint());
    menu->setZOrder(playMenu->getZOrder()+1);
    menu->addChild(btn);
    this->addChild(menu);

    ShowcaseBotManager::get()->loadPlayReplayButton(m_level, this, btn);

    return true;
  }

  void onButton(CCObject* sender) {
    ShowcaseBotManager::get()->onPlayReplayPressed(this);
  }
};
