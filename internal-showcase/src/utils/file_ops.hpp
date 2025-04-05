#include <matjson.hpp>

geode::Result<std::string> readFileAsString(const std::string& filepath);
void writeJsonFile(const std::string& filepath, const matjson::Value& json);
