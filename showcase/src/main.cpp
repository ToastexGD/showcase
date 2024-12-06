#include "managers/showcase_auto_manager.hpp"
#include "managers/showcase_manager.hpp"

void onMenuLayer() {
  ShowcaseBotManager::get();
  ShowcaseAutoManager::get();
}
