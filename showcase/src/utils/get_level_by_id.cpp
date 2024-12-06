#include "get_level_by_id.hpp"

bool GetLevelByID::init() {
  if (!CCNode::init()) {
    return false;
  }
  GameLevelManager::sharedState()->m_levelManagerDelegate = this;
  m_searchObject = GJSearchObject::create(SearchType::Search, std::to_string(m_levelId));
  GameLevelManager::sharedState()->getOnlineLevels(m_searchObject);
  return true;
}

void GetLevelByID::loadLevelsFailed(char const *p0) {
  m_callback(std::nullopt);
  log::info("Failed to load levels: {}", m_levelId);
  log::info("ERROR: {}", p0);
  delete this;
}

void GetLevelByID::loadLevelsFailed(char const *p0, int p1) { loadLevelsFailed(p0); }

void GetLevelByID::loadLevelsFinished(cocos2d::CCArray *levels, char const *p1, int p2) {
  loadLevelsFinished(levels, p1);
}

void GetLevelByID::loadLevelsFinished(cocos2d::CCArray *levels, char const *hash) {
  if (levels->count() == 0) {
    return;
  }

  auto level = static_cast<GJGameLevel *>(levels->objectAtIndex(0));
  m_callback(level);
  delete this;
}

GetLevelByID::~GetLevelByID() {
  GameLevelManager::sharedState()->m_levelManagerDelegate = nullptr;
}
