#pragma once
#include <gdr/gdr.hpp>

#include "../includes/geode.hpp"
#include "../models/bot.hpp"
#include "showcase_auto_manager.hpp"

#define SHOWCASE_SERVER "https://showcase.flafy.dev"
#define DASHAUTH_SERVER "https://dashend.firee.dev"
// #define SHOWCASE_SERVER "http://127.0.0.1:8080"
// #define DASHAUTH_SERVER "http://127.0.0.1:3002"

enum class ShowcaseBotState {
  Idle,
  Recording,
  Playing,
};

struct ShowcaseBotReplay : public gdr::Replay<ShowcaseBotReplay, gdr::Input> {
  ShowcaseBotReplay() : Replay("ShowcaseBot", "1.0") {}
};

class ShowcaseBotManager : public CCNode {
protected:
  friend class ShowcaseAutoManager;

  inline static ShowcaseBotManager *m_instance = nullptr;
  ShowcaseBotReplay m_replay;
  std::filesystem::path m_queueDir;
  EventListener<web::WebTask> m_needSubsReqListener;
  EventListener<web::WebTask> m_uploadSubsReqListener;
  EventListener<web::WebTask> m_verifyDashauthTokenListener;
  EventListener<web::WebTask> m_getReplayListener;

  std::optional<ShowcaseBotReplay> m_loadedReplay = std::nullopt;

  void verifyToken();
  void setDashAuthToken(std::optional<std::string> token);
  std::optional<std::string> getDashAuthToken();
  void onTokenVerified();

  void saveCurrentReplay(int32_t levelID);
  void loadReplyFromQueueFile(int32_t levelID);

public:
  ShowcaseBotState m_state = ShowcaseBotState::Idle;

  bool init() override;
  void onCommandProcessed(GJBaseGameLayer *baseGameLayer);
  bool onHandleUserButton(GJBaseGameLayer *baseGameLayer, bool down, int button, bool player1);

  bool onLevelComplete(PlayLayer *playLayer);
  void onLevelExit(PlayLayer *playLayer);
  void onLevelRestart(PlayLayer *playLayer);

  void onPlayReplayPressed(LevelInfoLayer *levelInfoLayer);
  void loadPlayReplayButton(GJGameLevel *level, LevelInfoLayer *levelInfoLayer,
                            CCMenuItemSpriteExtra *playReplayButton);

  std::vector<gdr::Input> getInputs(int frame);

  static bool shouldLevelBeReplay(GJGameLevel* level);

  void removeKeysSinceFrame(int frame);

  void sendAcceptTerms();

  bool isTermsAccepted();

  void saveReplay(int level);
  void clearReplay();

  void tryUpload();

  static ShowcaseBotManager *get(bool create = true) {
    if (!create) {
      return m_instance;
    }
    if (m_instance == nullptr) {
      m_instance = new ShowcaseBotManager;
      m_instance->init();
    }

    return m_instance;
  }
};
