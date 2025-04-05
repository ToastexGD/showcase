#include "../includes/geode.hpp"
#include "../managers/showcase_internal_manager.hpp"

struct SIGameManager : geode::Modify<SIGameManager, GameManager> {
  // void setGameVariable(const char *p0, bool p1) {
  //   log::info("Setting game variable {} = {}", p0, p1);
  //   GameManager::setGameVariable(p0, p1);
  // }
  bool getGameVariable(const char *p0) {
    // NOT SURE about the following
    // - 0083 disable song alert.
    // - 0168 fast menu
    // - 0016 is the game variable for accepting TOS for downloading songs
    // - 0030 is the game variable for vsync (I'm not sure if forcing it to false does anything)
    // - 0063 unverified coins popup
    if (strcmp(p0, "0168") == 0 || strcmp(p0, "0083") == 0 || strcmp(p0, "0082") == 0 ||
        strcmp(p0, "0016") == 0 || strcmp(p0, "0063") == 0) {
      return true;
    } else if (strcmp(p0, "0030") == 0) {
      return false;
    }
    return GameManager::getGameVariable(p0);
  }
};
