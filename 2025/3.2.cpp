#include <iostream>
#include <fstream>
#include <string>
#include <charconv>
#include <vector>
#include <valarray>
#include <stdexcept>
#include <cmath>

std::vector<std::vector<long>> read(const std::string &path);
std::valarray<long> find_max_joltage(const std::vector<std::vector<long>> &ratings);

int main() {
  std::string path = "inputs/3.sample.txt";
  auto ratings = read(path);
  auto max_joltages = find_max_joltage(ratings);
  std::cout << "Sample: " << max_joltages.sum() << std::endl;
  ratings = read("inputs/3.txt");
  max_joltages = find_max_joltage(ratings);
  std::cout << "Real: " << max_joltages.sum() << std::endl;
}

std::vector<std::vector<long>> read(const std::string &path) {
  std::vector<std::vector<long>> ratings;
  std::fstream input(path, std::ios_base::in);
  if (!input.is_open()) {
    throw std::runtime_error("Could not open input file");
  }
  ratings.emplace_back(std::vector<long>());
  std::size_t i = 0;
  char c;
  long n;
  while (input.get(c)) {
    if (c == '\n') {
      ratings.emplace_back(std::vector<long>());
      i += 1;
    }
    else {
      std::from_chars(&c, (&c)+1, n);
      ratings[i].push_back(n);
    }
  }
  return ratings;
}

std::valarray<long> find_max_joltage(const std::vector<std::vector<long>> &ratings) {
  std::valarray<long> joltage(ratings.size());
  const std::size_t n_digits = 12;
  for (std::size_t bank_idx = 0; bank_idx < ratings.size(); ++bank_idx) {
    const auto &bank = ratings[bank_idx];
    std::size_t left = 0;
    std::vector<long> digits(n_digits, 0);
    for (std::size_t digit = 0; digit < n_digits; ++digit) {
      for (std::size_t idx = left; idx < bank.size() - (n_digits - (1 + digit)); ++idx) {
        if (bank[idx] > digits[digit]) {
          digits[digit] = bank[idx];
          left = idx + 1;
        }
      }
    }
    long factor = std::pow(10, 11);
    for (int digit : digits) {
      joltage[bank_idx] += digit * factor;
      factor /= 10;
    }
  }
  return joltage;
}
