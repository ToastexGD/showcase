#include "../includes/geode.hpp"
#include "../managers/showcase_internal_manager.hpp"

struct SICCNode : geode::Modify<SICCNode, CCNode> {
  void visit() {}
};
