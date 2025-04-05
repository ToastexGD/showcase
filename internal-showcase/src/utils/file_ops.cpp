#include "file_ops.hpp"

geode::Result<std::string> readFileAsString(const std::string& filepath) {
  std::ifstream file(filepath, std::ios::binary | std::ios::ate);
  if (!file) {
    return geode::Err(fmt::format("Could not find file {} for reading", filepath));
  }

  // Get file size
  std::streamsize size = file.tellg();
  file.seekg(0, std::ios::beg);

  // Read file content into a string
  std::string fileContent(size, '\0');
  file.read(fileContent.data(), size);
  return geode::Ok(fileContent);
}

void writeJsonFile(const std::string& filepath, const matjson::Value& json) {
    std::ofstream file(filepath);
    if (!file) {
      return;
    }

    file << json.dump();
    file.close();
}
