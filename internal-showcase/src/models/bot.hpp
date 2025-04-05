// #pragma once
// #include "../includes/geode.hpp"

// struct BotKeypress {
//   bool down;
//   PlayerButton button;
//   bool player1;
// };

// class Bot {
// public:
//   std::unordered_map<int, std::vector<BotKeypress>> m_keypressesMap;

//   void registerKey(int frame, BotKeypress keypress) { m_keypressesMap[frame].push_back(keypress); }

//   void registerKeys(int frame, std::vector<BotKeypress> keypress) {
//     m_keypressesMap[frame].insert(m_keypressesMap[frame].end(), keypress.begin(), keypress.end());
//   }

//   std::vector<BotKeypress> getKeys(int frame) { return m_keypressesMap[frame]; };

//   void removeKeysSinceFrame(int frame) {
//     for (auto it = m_keypressesMap.begin(); it != m_keypressesMap.end();) {
//       if (it->first >= frame) {
//         it = m_keypressesMap.erase(it);
//       } else {
//         ++it;
//       }
//     }
//   }

//   void clearAllKeys() { m_keypressesMap.clear(); }
// };
