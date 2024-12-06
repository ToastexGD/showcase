#include <string>
#include <cstdlib>
#include <cerrno>

std::optional<int32_t> stringToInt32(const std::string& str) {
    char* end = nullptr;
    errno = 0;

    long result = std::strtol(str.c_str(), &end, 10);

    if (errno == ERANGE || result > INT_MAX || result < INT_MIN) {
        return std::nullopt;
    }
    if (end == str.c_str() || *end != '\0') {
        return std::nullopt;
    }

    return static_cast<int32_t>(result);
}
