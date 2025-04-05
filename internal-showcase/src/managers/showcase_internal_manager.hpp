#pragma once
#include <gdr/gdr.hpp>

#include "../includes/geode.hpp"
#include "../models/bot.hpp"

struct ShowcaseBotReplay : public gdr::Replay<ShowcaseBotReplay, gdr::Input<>> {
  ShowcaseBotReplay() : Replay("ShowcaseBot", 2) {}
};

class ShowcaseInternalManager : public CCNode {
protected:
  inline static ShowcaseInternalManager *m_instance = nullptr;
  ShowcaseBotReplay m_replay;
  bool m_playedOnce = false;
  int m_restarts = 0;

  bool init() override;

public:
  void onLevelInfoLayerLoaded(LevelInfoLayer* levelInfoLayer);
  void onLevelComplete(PlayLayer* playLayer);
  bool onLevelRestart(PlayLayer* playLayer);
  void onCommandProcessed(GJBaseGameLayer *baseGameLayer);
  std::vector<gdr::Input<>> getInputs(int frame);
  [[ noreturn ]] void writeFail(std::string reason);

  static ShowcaseInternalManager *get(bool create = true) {
    if (!create) {
      return m_instance;
    }
    if (m_instance == nullptr) {
      m_instance = new ShowcaseInternalManager;
      m_instance->init();
    }

    return m_instance;
  }
};
