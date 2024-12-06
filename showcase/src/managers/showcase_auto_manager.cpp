#include "showcase_auto_manager.hpp"
#include "../utils/get_level_by_id.hpp"
#include "Geode/binding/LevelInfoLayer.hpp"
#include "Geode/cocos/CCDirector.h"
#include "Geode/loader/Loader.hpp"
#include "showcase_manager.hpp"
#include <matjson.hpp>

bool ShowcaseAutoManager::init() {
  if (!CCNode::init())
    return false;

  if (createSocket()) {
    m_autoEnabled = true;
    m_thread = std::thread{[this]() {
      while (true) {
        char buffer[1024] = {0};
        recv(m_clientSocket.value(), buffer, sizeof(buffer), 0);
        if (strlen(buffer) == 0) {
          log::info("DISCONNECTED");
          m_clientSocket = std::nullopt;
          break;
        }

        // to string
        std::string bufferStr(buffer);
        log::info("GOT: {}", bufferStr);

        // split by space
        int spacePos = bufferStr.find(' ');
        if (spacePos == std::string::npos) {
          continue;
        }
        log::info("Space at: {}", spacePos);

        std::string name = bufferStr.substr(0, spacePos);
        std::string argStr = bufferStr.substr(spacePos + 1);
        log::info("Name: {}, Arg: \"{}\"", name, argStr);

        matjson::Value arg = matjson::parse(argStr).unwrap();

        queueInMainThread([this, name, arg]() { onCommand(name, arg); });
      }
    }};

    sendCommand("client_connected", matjson::Value(0));
  }

  return true;
}

bool ShowcaseAutoManager::sendCommand(const std::string &commandName, const matjson::Value &arg) {
  if (!m_clientSocket.has_value())
    return false;
  const std::string message = fmt::format("{} {}", commandName, arg.dump(0));
  const char *messageCStr = message.c_str();
  return send(m_clientSocket.value(), messageCStr, strlen(messageCStr), 0) != SOCKET_ERROR;
}

void ShowcaseAutoManager::onCommand(const std::string &commandName, matjson::Value arg) {
  if (commandName == "server_ping") {
    sendCommand("client_pong", 0);
  } else if (commandName == "server_goto_level") {
    int levelID = arg["levelID"].asInt().unwrap();

    GetLevelByID::create(levelID, [this, levelID](auto level) {
      if (!level.has_value()) {
        sendCommand("client_level_valid", matjson::makeObject({
                                              {"levelID", levelID},
                                              {"found", false},
                                          }));
        return;
      }

      if (!ShowcaseBotManager::shouldLevelBeReplay(level.value())) {
        sendCommand("client_level_valid", matjson::makeObject({
                                              {"levelID", levelID},
                                              {"found", true},
                                              {"valid", false},
                                          }));
        return;
      }

      sendCommand("client_level_valid", matjson::makeObject({
                                            {"levelID", levelID},
                                            {"found", true},
                                            {"valid", true},
                                        }));

      GameLevelManager::sharedState()->gotoLevelPage(level.value());
    });
  } else if (commandName == "server_play_level") {
    auto levelInfoLayer = static_cast<LevelInfoLayer *>(
        CCDirector::get()->getRunningScene()->getChildByID("LevelInfoLayer"));
    if (levelInfoLayer == nullptr) {
      return;
    }
    int levelID = levelInfoLayer->m_level->m_levelID.value();
    if (levelID != arg["levelID"].asInt().unwrap()) {
      return;
    }
    ShowcaseBotManager::get()->loadReplyFromQueueFile(levelID);
    ShowcaseBotManager::get()->m_state = ShowcaseBotState::Playing;
    levelInfoLayer->onPlay(nullptr);
  }
}

bool ShowcaseAutoManager::onLevelComplete(PlayLayer *playLayer) {
  log::info("Level complete!");
  if (!m_clientSocket.has_value())
    return false;

  sendCommand("client_replay_result", matjson::makeObject({
                                          {"levelID", playLayer->m_level->m_levelID.value()},
                                          {"finished", true},
                                      }));
  playLayer->onQuit();

  return false;
}

void ShowcaseAutoManager::onLevelRestart(PlayLayer *playLayer) {
  int currentFrame = playLayer->m_gameState.m_currentProgress;
  if (currentFrame < 2) return;

  log::info("Level restart...? {}", currentFrame);
  if (!m_clientSocket.has_value())
    return;

  sendCommand("client_replay_result", matjson::makeObject({
                                          {"levelID", playLayer->m_level->m_levelID.value()},
                                          {"finished", false},
                                      }));
  playLayer->onQuit();

  return;
}

bool ShowcaseAutoManager::createSocket() {
  SOCKET clientSocket = socket(AF_INET, SOCK_STREAM, 0);

  sockaddr_in serverAddress;
  serverAddress.sin_family = AF_INET;
  serverAddress.sin_port = htons(8081);
  serverAddress.sin_addr.s_addr = inet_addr("127.0.0.1");

  if (connect(clientSocket, (struct sockaddr *)&serverAddress, sizeof(serverAddress)) != 0) {
    return false;
  }

  m_clientSocket = clientSocket;

  return true;
}
