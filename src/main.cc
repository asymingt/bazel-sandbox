#include <cstdio>
#include <fstream>
#include <iostream>

#include "rules_cc/cc/runfiles/runfiles.h"

using rules_cc::cc::runfiles::Runfiles;

int main(int argc, char* argv[]) {
  std::string argv0 = argv[0];
  std::string error;
  auto runfiles = std::unique_ptr<Runfiles>(
    Runfiles::Create(argv0, BAZEL_CURRENT_REPOSITORY, &error));
  if (!runfiles) {
    std::cerr << "ERROR: " <<  error.c_str() << std::endl;
    return 1;
  }
  std::string path = runfiles->Rlocation("experimental/data/foo.txt");
  std::cout << "Found data file path: " << path.c_str() << std::endl;
  std::ifstream myfile(path);
  std::cout << "Content: " << std::endl;
  if (myfile.is_open()) {
    std::string line;
    while (getline(myfile, line)) {
        std::cout << line << std::endl;
    }
    myfile.close();
  }
  return 0;
}