# CMake Scripts

This is a collection of quite useful scripts that expand the possibilities for building software with CMake, by making some things easier and otherwise adding new build types

# How to integrate

## Using [CPM.cmake](https://github.com/TheLartians/CPM) (recommended)

Run the following from the project's root directory to add CPM to your project.

```bash
mkdir -p cmake
wget -O cmake/CPM.cmake https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake
```

Add the following lines to the project's `CMakeLists.txt` after calling `project(...)`.

```CMake
include(cmake/CPM.cmake)

CPMAddPackage(
  NAME xyz-cmake-scripts
  GIT_REPOSITORY ssh://git@bitbucket.org/xyz-robotics/xyz-cmake-scripts.git
  GIT_TAG master
  OPTIONS # set to yes skip cmake formatting
          "FORMAT_SKIP_CMAKE YES"
          # path to exclude (optional, supports regular expressions)
          "CMAKE_FORMAT_EXCLUDE cmake/CPM.cmake"
)
```

# Avaliable Scripts

## C++ Standards [`c++-standards.cmake`](c++-standards.cmake)

Using the functions `cxx_11()`, `cxx_14()`, `cxx_17()` or `cxx_20()` this adds the appropriate flags for both unix and MSVC compilers, even for those before 3.11 with improper support.

These obviously force the standard to be required, and also disables compiler-specific extensions, ie `--std=gnu++11`. This helps to prevent fragmenting the code base with items not available elsewhere, adhering to the agreed C++ standards only.

## Compiler Options [`compiler-options.cmake`](compiler-options.cmake)

Allows for easy use of some pre-made compiler options for the major compilers.

Currently, we have these functions and options:

| Function             | Option[default value] |
| :------------------- | :-------------------- |
| enable_all_warnings  | ALL_WARNINGS[ON]      |
| enable_effective_cxx | EFFECTIVE_CXX[OFF]    |
| disable_avx512       | AVX512[OFF]           |
| enable_openmp        | OPENMP[ON]            |

You can add these functions(eg. `enable_openmp()`) into your `CMakeLists.txt` this adds the appropriate openmp flags if the cmake option is ON(eg. `-DOPENMP=ON`).

## Format

clang-format and cmake-format for CMake

### Dependencies

_Format_ requires _CMake_, _clang-format_, _python 2.7_ or _python 3_, and _cmake-format_ (optional).

### About

Adds three additional targets to your CMake project.

- `format` Shows which files are affected by clang-format
- `check-format` Errors if files are affected by clang-format (for CI integration)
- `fix-format` Applies clang-format to all affected files

To run the targets, invoke CMake with `cmake --build <build directory> --target <target name>`.

To disable using _cmake_format_ to format CMake files, set the cmake option `FORMAT_SKIP_CMAKE` to a truthy value, e.g. by invoking CMake with `-DFORMAT_SKIP_CMAKE=YES`, or enabling the option when [adding the dependency](#how-to-integrate) (recommended).

### Tips

To ignore folder(like 3rdparty source files), you can specific a .clang-format inside the folder:

```shell
# To ignore clang-format under 3rdparty folder, add the following file under 3rdparty:
>> cat 3rdparty/.clang-format
---
DisableFormat: true
SortIncludes: false
```

To ignore lines, use the `clang-format on/off` comment:

```c++
// clang-format off
enum NodeType : unsigned char {
  Normal =      0b00000000,
  Root =        0b00000001,
  Leaf =        0b00000010,
  RootLeaf =    0b00000011,
  Path =        0b00000100,
  RepeaterIn =  0b00001000,
  RepeaterOut = 0b00010000,
  Repeater =    0b00011000,
  Group =       0b00100000
};
// clang-format on
```

## Static Check

### Dependencies

_Static Check_ requires _cpplint_ and _clang-tidy_

### About

We provide two tools to static check you cpp source code: cpplint & clang-tidy.

#### cpplint

To run `cpplint`, invoke CMake with `cmake --build <build directory> --target cpplint`. Errors if all files are not passed by cpplint (for CI integration)

#### clang-tidy

To save `clang-tidy`'s check time, we only run `clang-tidy` on files which are different from target branch. Usage example:

```shell
# first you need to specific the target branch
cmake -DDESTINATION_BRANCH=master  --build <build directory>
# run clang-tidy
cmake --build <build directory> --target clang-tidy
```

### Tips

To ignore folder when run cpplint, you can modify your project's CPPLINT.cfg:
```shell
exclude_files=3rdparty
exclude_fiels=test
```

To ignore line when run `clang-tidy`, you can use the `NOLINT` comment:

```c++
// namespace should be lower case, howerver we can not modify 3rdparty's namespace
namespace YAML {  // NOLINT
}
```

To ignore 3rdparty's header files, you should include them as system headers in your CMakeLists.txt:

```cmake
target_include_directories(xvl_global SYSTEM PUBLIC ${OpenCV_INCLUDE_DIRS}
                                                    ${EIGEN3_INCLUDE_DIRS}
                                                    ${PCL_INCLUDE_DIRS})

```

# Default Configuration Files

We provide some configuration files used in XYZ Robotics:

* .clang-format
* .cmake-format
* CPPLINT.cfg
* .clang-tidy

These files are under this project's root directory. You should copy these files to you own project's root directory.

# Reference
1. https://github.com/StableCoder/cmake-scripts
2. https://github.com/TheLartians/Format.cmake
