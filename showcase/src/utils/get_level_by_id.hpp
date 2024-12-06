#include "../includes/geode.hpp"

class GetLevelByID : public CCNode, public LevelManagerDelegate {
  GetLevelByID(int levelId, std::function<void(std::optional<GJGameLevel *>)> callback)
      : m_levelId(levelId), m_callback(callback) {}

  int m_levelId;
  // m_callback that is a function that takes a GJGameLevel* as an argument
  std::function<void(std::optional<GJGameLevel *>)> m_callback;
  GJSearchObject *m_searchObject = nullptr;

  bool init() override;

  ~GetLevelByID();

  void loadLevelsFailed(char const *p0) override;

  void loadLevelsFailed(char const *p0, int p1) override;

  void loadLevelsFinished(cocos2d::CCArray *levels, char const *p1, int p2) override;
  void loadLevelsFinished(cocos2d::CCArray *levels, char const *hash) override;

public:
  static GetLevelByID *create(int levelId,
                              std::function<void(std::optional<GJGameLevel *>)> callback) {
    auto *ret = new GetLevelByID(levelId, callback);

    if (ret && ret->init()) {
      ret->retain();
    } else {
      CC_SAFE_DELETE(ret);
    }

    return ret;
  }
};
