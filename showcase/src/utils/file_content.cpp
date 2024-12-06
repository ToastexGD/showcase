#include <SHA256.h>
#include <base64.hpp>

std::string sha256FileContent(const std::filesystem::path& filePath) {
  std::ifstream file(filePath, std::ios::binary | std::ios::ate);
  if (!file) {
    throw std::runtime_error("Unable to open file.");
  }

  // Get file size
  std::streamsize size = file.tellg();
  file.seekg(0, std::ios::beg);

  // Read file content into a string
  std::string content(size, '\0');
  file.read(content.data(), size);

  // Compute SHA-256 hash
  SHA256 sha;
  sha.update(content);
  std::array<uint8_t, 32> digest = sha.digest();

  return SHA256::toString(digest);
}

std::string base64FileContent(const std::filesystem::path& filePath) {
  std::ifstream file(filePath, std::ios::binary | std::ios::ate);
  if (!file) {
    throw std::runtime_error("Unable to open file.");
  }

  // Get file size
  std::streamsize size = file.tellg();
  file.seekg(0, std::ios::beg);

  // Read file content into a string
  std::string content(size, '\0');
  file.read(content.data(), size);

  // Compute base64
  return base64::to_base64(content);
}

std::vector<uint8_t> binaryFileContent(const std::filesystem::path& filePath) {
  std::ifstream instream(filePath, std::ios::in | std::ios::binary);
  std::vector<uint8_t> data((std::istreambuf_iterator<char>(instream)), std::istreambuf_iterator<char>());
  return data;
}
