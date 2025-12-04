#include <iostream>
#include <fstream>
#include <string>
#include <charconv>
#include <vector>
#include <valarray>
#include <stdexcept>

std::vector<std::vector<int>> read(const std::string &path);
std::valarray<int> find_max_joltage(const std::vector<std::vector<int>> &ratings);

int main() {
  std::string path = "inputs/3.sample.txt";
  auto ratings = read(path);
  auto max_joltages = find_max_joltage(ratings);
  std::cout << "Sample: " << max_joltages.sum() << std::endl;
  ratings = read("inputs/3.txt");
  max_joltages = find_max_joltage(ratings);
  std::cout << "Real: " << max_joltages.sum() << std::endl;
}

std::vector<std::vector<int>> read(const std::string &path) {
  std::vector<std::vector<int>> ratings;
  std::fstream input(path, std::ios_base::in);
  if (!input.is_open()) {
    throw std::runtime_error("Could not open input file");
  }
  ratings.emplace_back(std::vector<int>());
  std::size_t i = 0;
  char c;
  int n;
  while (input.get(c)) {
    if (c == '\n') {
      ratings.emplace_back(std::vector<int>());
      i += 1;
    }
    else {
      std::from_chars(&c, (&c)+1, n);
      ratings[i].push_back(n);
    }
  }
  return ratings;
}

std::valarray<int> find_max_joltage(const std::vector<std::vector<int>> &ratings) {
  std::valarray<int> joltage(ratings.size());
  std::size_t idx = 0;
  for (const auto &bank : ratings) {
    int first = 0;
    int first_idx = -1;
    for (std::size_t i = 0; i < bank.size() - 1; ++i) {
      if (bank[i] > first) {
        first = bank[i];
        first_idx = i;
      }
    }
    int second = 0;
    for (std::size_t i = first_idx + 1; i < bank.size(); ++i) {
      if (bank[i] > second) {
        second = bank[i];
      }
    }
    joltage[idx] = first * 10 + second;
    idx += 1;
  }
  return joltage;
}
