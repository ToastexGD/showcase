#pragma once

#include "../includes/geode.hpp"
#include "Geode/GeneratedPredeclare.hpp"

class ShowcaseAutoManager : public CCNode {
protected:
  inline static ShowcaseAutoManager *m_instance = nullptr;
  std::optional<SOCKET> m_clientSocket = std::nullopt;
  std::thread m_thread;

  int m_levelRestarts = 0;

  bool init() override;
  bool createSocket();

  bool sendCommand(const std::string& commandName, const matjson::Value& arg);
  void onCommand(const std::string& commandName, matjson::Value arg);

  void setAutoSettings(float dt);
public:
  bool m_autoEnabled = false;

  bool onLevelComplete(PlayLayer *playLayer);
  void onLevelRestart(PlayLayer *playLayer);

  static ShowcaseAutoManager *get(bool create = true) {
    if (!create) {
      return m_instance;
    }
    if (m_instance == nullptr) {
      m_instance = new ShowcaseAutoManager;
      m_instance->init();
    }

    return m_instance;
  }
};
