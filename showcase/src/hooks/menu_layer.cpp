#include "../includes/geode.hpp"
#include "../managers/showcase_manager.hpp"
#include "../main.hpp"

struct SBMenuLayer : geode::Modify<SBMenuLayer, MenuLayer> {
  bool init() {
		if (!MenuLayer::init()) {
			return false;
		}

		onMenuLayer();

    return true;
	}
};
