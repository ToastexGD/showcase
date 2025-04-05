#pragma once
#include <gdr/gdr.hpp>

#include "../includes/geode.hpp"
#include "../models/bot.hpp"

#define SHOWCASE_SERVER "https://showcase.flafy.dev"
#define DASHAUTH_SERVER "https://dashend.firee.dev"
// #define SHOWCASE_SERVER "http://127.0.0.1:8080"
// #define DASHAUTH_SERVER "http://127.0.0.1:3002"

enum class ShowcaseBotState {
  Idle,
  Recording,
  Playing,
};

struct ShowcaseBotReplay : public gdr::Replay<ShowcaseBotReplay, gdr::Input<>> {
  ShowcaseBotReplay() : Replay("ShowcaseBot", 2) {}
};

class ShowcaseBotManager : public CCNode {
protected:
  inline static ShowcaseBotManager *m_instance = nullptr;
  ShowcaseBotReplay m_replay;
  std::filesystem::path m_queueDir;
  EventListener<web::WebTask> m_neededSubsReqListener;
  EventListener<web::WebTask> m_uploadSubReqListener;
  EventListener<web::WebTask> m_verifyDashauthTokenListener;
  std::string m_gdVersion;
  std::string m_modVersion;
  bool m_isCurrentRunPractice = false;

  std::optional<ShowcaseBotReplay> m_loadedReplay = std::nullopt;

  void verifyToken();
  void setDashAuthToken(std::optional<std::string> token);
  std::optional<std::string> getDashAuthToken();
  void onTokenVerified();
  Result<matjson::Value> makeSubmissionInfo(std::filesystem::directory_entry& entry);

  void saveCurrentReplay(int32_t levelID, int32_t levelVersion);

public:
  ShowcaseBotState m_state = ShowcaseBotState::Idle;
  EventListener<web::WebTask> m_getReplayListener;

  bool init() override;
  void onCommandProcessed(GJBaseGameLayer *baseGameLayer);
  bool onHandleUserButton(GJBaseGameLayer *baseGameLayer, bool down, int button, bool player1);

  bool onLevelComplete(PlayLayer *playLayer);
  void onLevelExit(PlayLayer *playLayer);
  void onLevelRestart(PlayLayer *playLayer);

  void onPlayReplayPressed(LevelInfoLayer *levelInfoLayer);
  void loadPlayReplayButton(GJGameLevel *level, LevelInfoLayer *levelInfoLayer,
                            CCMenuItemSpriteExtra *playReplayButton);

  std::vector<gdr::Input<>> getInputs(int frame);

  bool shouldLevelBeReplay(GJGameLevel* level);

  void removeKeysSinceFrame(int frame);

  void sendAcceptTerms();

  bool isTermsAccepted();

  void clearReplay();

  void tryUploadSingle();

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
