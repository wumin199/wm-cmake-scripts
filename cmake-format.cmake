
#@Status: OK

#@Study: 函数用于筛选指定正则表达式匹配的git仓库文件，使用CMake宏cmake_parse_arguments解析输入参数，并通过execute_process调用Git命令获取所有缓存文件列表
# Regex-filter a git repository's files.



## @Study: ${ARGN}包含了传递给函数或宏的所有未命名参数，这些参数通过空格分隔。
  # 在 CMake 中，${ARGN} 是一个预定义的变量，用于引用函数或宏中未命名的参数列表。具体来说，${ARGN} 包含了传递给函数或宏的所有未命名参数，这些参数通过空格分隔。

  # 以下是一个简单的示例，其中定义了一个函数 foo，它接受两个必需参数和一个可选参数，并使用 ${ARGN} 引用可选参数：

  # ```cmake
  # function(foo arg1 arg2)
  #     message("arg1: ${arg1}")
  #     message("arg2: ${arg2}")
  #     if(ARGC GREATER 2)
  #         message("extra args:")
  #         foreach(extra_arg IN LISTS ARGN)
  #             message("  ${extra_arg}")
  #         endforeach()
  #     endif()
  # endfunction()

  # foo("hello" "world" "foo" "bar")
  # ```

  # 当调用 foo() 时，输出如下：

  # ```
  # arg1: hello
  # arg2: world
  # extra args:
  #   foo
  #   bar
  # ```

  # 在此示例中，${ARGN} 包含字符串 "foo" 和 "bar"，它们都是 foo() 函数的额外参数。注意，在函数定义中可以使用 ${ARGC} 访问参数的数量，以便在没有额外参数的情况下避免不必要的迭代。


## @Study: cmake_parse_arguments()解析：cmake /path/to/source -DUSE_CLANG=ON -DENABLE_DEBUG=OFF
    # 这里的例子做好： https://cmake.org/cmake/help/latest/command/cmake_parse_arguments.html
  # cmake_parse_arguments(<prefix> <options> <one_value_keywords>
  #                       <multi_value_keywords> <args>...)

  # cmake_parse_arguments(PARSE_ARGV <N> <prefix> <options>
  #                       <one_value_keywords> <multi_value_keywords>)
  # The PARSE_ARGV signature is only for use in a function() body. In this case the arguments that are parsed come from the ARGV# variables of the calling function. The parsing starts with the <N>-th argument, where <N> is an unsigned integer. This allows for the values to have special characters like ; in them

  # @Study:案例1：cmake /path/to/source -DUSE_CLANG=ON -DENABLE_DEBUG=OFF
    # set(USE_CLANG OFF)
    # set(ENABLE_DEBUG ON)
    # # 定义参数列表
    # set(ARGUMENTS USE_CLANG ENABLE_DEBUG)

    # # 解析参数
    # cmake_parse_arguments(MY_ARGS "" "${ARGUMENTS}" "" ${ARGV})

    # # 将解析得到的值传递给变量
    # if(MY_ARGS_USE_CLANG)
    #     set(USE_CLANG ${MY_ARGS_USE_CLANG})
    # endif()

    # if(MY_ARGS_ENABLE_DEBUG)
    #     set(ENABLE_DEBUG ${MY_ARGS_ENABLE_DEBUG})
    # endif()
  # @Study:案例2：cmake /path/to/source -DUSE_CLANG=ON -DENABLE_DEBUG=OFF arg1 arg2
    # 定义要解析的参数及其默认值
    # set(USE_CLANG_DEFAULT OFF)
    # set(ENABLE_DEBUG_DEFAULT ON)
    # set(ARGS "")

    # # 解析参数并将其存储到变量中
    # cmake_parse_arguments(
    #   PARSE_ARGV 0
    #   "USE_CLANG" "ENABLE_DEBUG"
    #   "ARGS"
    #   ${ARGV}
    # )

    # # 如果未指定 USE_CLANG，则将其设置为默认值
    # if(NOT DEFINED USE_CLANG)
    #   set(USE_CLANG ${USE_CLANG_DEFAULT})
    # endif()

    # # 如果未指定 ENABLE_DEBUG，则将其设置为默认值
    # if(NOT DEFINED ENABLE_DEBUG)
    #   set(ENABLE_DEBUG ${ENABLE_DEBUG_DEFAULT})
    # endif()

    # # 打印解析得到的参数
    # message("USE_CLANG: ${USE_CLANG}")
    # message("ENABLE_DEBUG: ${ENABLE_DEBUG}")
    # message("ARGS: ${ARGS}")


## function(get_cmake_files)说明

  # 这是一个CMake函数，名为get_cmake_files。该函数通过调用cmake_parse_arguments宏并解析输入参数来接受三个输入参数：GIT_REPOSITORY_DIR、OUTPUT_LIST和REGEX。

  # 在函数中，execute_process命令将使用git程序获取指定目录（{GIT_REPOSITORY_DIR}）中所有缓存的文件，并将其存储在变量all_files中。过滤出与正则表达式（GIT 
  # R
  # ​
  #  EPOSITORY 
  # D
  # ​
  #  IR）中所有缓存的文件，并将其存储在变量all 
  # f
  # ​
  #  iles中。过滤出与正则表达式（{_REGEX}）匹配的文件，并将结果存储在filtered_files列表中。如果有设置CMAKE_FORMAT_EXCLUDE变量，则从filtered_files中排除与CMAKE_FORMAT_EXCLUDE正则表达式匹配的文件。

  # 最后，函数通过将filtered_files赋值给_OUTPUT_LIST变量来输出结果，并使用PARENT_SCOPE标志确保该变量可以被外部访问。
function(get_cmake_files)

  # 通过调用cmake_parse_arguments宏并解析输入参数，函数可以接受这些参数并使用它们来完成特定的任务。

  # 在这里，${ARGN}被传递给cmake_parse_arguments宏，用于解析函数get_cmake_files的输入参数，其中ARGN表示函数接受的所有未命名参数。因此，${ARGN}将包含所有传递给函数的输入参数，这些参数将被解析成三个具有特定含义的变量："prefix"_GIT_REPOSITORY_DIR、"prefix"_OUTPUT_LIST和"prefix"_REGEX。
  # 其中的prefix= 第一个""
  cmake_parse_arguments("" "" "GIT_REPOSITORY_DIR;OUTPUT_LIST;REGEX" "" ${ARGN})
  execute_process(
    # 在CMakeListys.txt中定义了：find_program(GIT_PROGRAM git)
    ## @Study: ls-files
      # git ls-files --cached --exclude-standard 是一个 Git 命令，它可以列出所有已经被 Git 缓存起来的文件，并排除掉默认被忽略的文件。

      # 具体来说：

      # --cached 参数表示只列出被缓存的文件（即已经被 git add 过的文件），不包括工作区中未暂存的文件。
      # --exclude-standard 参数表示按照 Git 的默认规则排除文件。这些默认规则包括 .gitignore 和 .git/info/exclude 文件中定义的忽略规则。
      # 例如，假设当前目录下有以下文件：

      # foo.txt
      # bar.txt
      # .gitignore
      # test/test.python

      # .gitignore 文件中包含一行规则：*.txt。这表示 Git 应该忽略所有的文本文件。
      # 如果运行命令 git ls-files --cached --exclude-standard，将输出：

      # .gitignore
      # test/test.python

      # 因为 foo.txt 和 bar.txt 都是文本文件，被 .gitignore 排除了，所以它们不会被列出。而 .gitignore 文件虽然也被忽略了，但由于它已经被 Git 缓存起来了，所以它会被列出。
    
    COMMAND ${GIT_PROGRAM} ls-files --cached --exclude-standard ${_GIT_REPOSITORY_DIR}
    # WORKING_DIRECTORY参数指定命令执行时的工作目录
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    # # OUTPUT_VARIABLE和ERROR_VARIABLE参数分别用于存储命令的标准输出和错误输出
    OUTPUT_VARIABLE all_files
  )

  ## @Study: 学习cmake_policy(SET CMP0007 NEW)

    #   cmake_policy(SET CMP0007 NEW) 是 CMake 的一个命令，用于设置 CMake 策略 CMP0007 的行为。

    # CMake 策略是指 CMake 在不同版本中的一些不兼容的行为，这些行为可能会对 CMake 构建过程产生影响。CMP0007 是一项 CMake 策略，用于控制是否允许在 add_definitions() 命令中添加未定义的编译器标志。

    # 在默认情况下（即 OLD 行为），如果在 add_definitions() 中添加未定义的编译器标志，CMake 将会发出警告并继续执行。但是，在某些情况下，这些未定义的编译器标志可能会导致编译错误或未定义行为。

    # 通过将 CMP0007 的行为设置为 NEW，可以禁用此警告，并且如果在 add_definitions() 中使用了未定义的编译器标志，则将导致 CMake 失败，从而帮助开发人员尽早发现问题。

    # 总之，cmake_policy(SET CMP0007 NEW) 的作用是将 CMake 策略 CMP0007 的行为设置为 NEW，以确保在 add_definitions() 中使用未定义的编译器标志时能够及时失败并发现问题。
  cmake_policy(SET CMP0007 NEW)

  ## @Study: add_definitions(-DDEBUG)，这相当于在源文件中加上了“#define DEBUG”这样的指令。
    #   add_definitions()是一个CMake函数，用于向C/C++编译器添加预处理器定义。预处理器定义通常是以“-D”开头的指令，可以用来定义一些宏，影响代码的编译。例如，在源文件中使用#ifdef可以根据定义情况选择性地编译不同的代码。

    # 下面是add_definitions()函数的语法：

    # add_definitions(-DFOO -DBAR=2)
    # 其中，“-DFOO”表示定义了一个名为“FOO”的宏；“-DBAR=2”表示定义了一个名为“BAR”的宏，并把它的值设为2。

    # 在CMakeLists.txt文件中，可以使用add_definitions()函数来添加预处理器定义。例如，以下代码将在编译时定义一个名为“DEBUG”的宏：

    # add_definitions(-DDEBUG)
    # 这相当于在源文件中加上了“#define DEBUG”这样的指令。

    # 另外，当需要传递一些定义给子目录或者子项目时，可以使用ADD_DEFINITIONS命令。例如：

    # add_definitions(-DMY_MACRO=1)
    # add_subdirectory(my_subdirectory)
    # 在my_subdirectory中就可以直接使用MY_MACRO这个宏了。
  
  
  ## @Study: string这是一个 CMake 脚本中的命令，用于将一个字符串变量 ${all_files} 中的所有换行符 \n 替换为分号 ; 并将结果存储在另一个变量 ${filtered_files} 中。

  string(REPLACE "\n" ";" filtered_files "${all_files}")
  # @Study: list 将filtered_files按照_REGEX筛选，符合的结果放回filtered_files
  list(FILTER filtered_files INCLUDE REGEX ${_REGEX})  #  ${_REGEX}是上面解析出来的

  # @Study： list 将filtered_files的结果按照 CMAKE_FORMAT_EXCLUDE的正则表达式进行排除，输出排除后的列表元素
  if(CMAKE_FORMAT_EXCLUDE)
    list(FILTER filtered_files EXCLUDE REGEX ${CMAKE_FORMAT_EXCLUDE})
  endif()

  # @Study: set 这是一个 CMake 命令，用于将变量 ${filtered_files} 的值赋给另一个变量 ${_OUTPUT_LIST} 并将其作用域扩展到当前目录的父级目录中。这样在父级目录中就可以访问 ${_OUTPUT_LIST} 变量了。
  # 通常情况下，CMake 中的变量都是在定义它们的目录中可见的。但是，有时候我们需要在子目录或者函数中定义一个变量，并将其传递回父目录或者调用者。这时候就可以使用 set(... PARENT_SCOPE) 来实现变量跨作用域传递的需求。
  set(${_OUTPUT_LIST}
      ${filtered_files}
      PARENT_SCOPE
  )
endfunction()


# @Study: CMake中的execute_process函数，用于在构建过程中执行外部命令（如git命令）。它接受一些参数，包括要执行的命令、工作目录、输入输出等，并返回命令执行的结果。

# wumin199@wumin199:~/wumin199_app/software/wm-cmake-scripts$ git rev-parse --show-toplevel
# /home/wumin199/wumin199_app/software/wm-cmake-scripts

# 该函数的主要作用是允许在CMake脚本中调用其他程序来执行需要的操作，例如获取系统信息、运行测试、构建子项目或生成代码等。由于CMake本身不提供所有必需的工具和库，因此execute_process可以用来调用外部工具来完成某些任务。

# @Study: Cmake中通过git rev-parse --show-toplevel获取git repo的绝对路径
execute_process(
  COMMAND git rev-parse --show-toplevel
  # OUTPUT_VARIABLE和ERROR_VARIABLE参数分别用于存储命令的标准输出和错误输出
  OUTPUT_VARIABLE GIT_TOPLEVEL
  # @Study: WORKING_DIRECTORY参数指定命令执行时的工作目录
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

# remove trailing whitespace from output
string(STRIP ${GIT_TOPLEVEL} GIT_TOPLEVEL)

# @Study: get_cmake_files函数，其中OUTPUT_LIST是输出参数，GIT_REPOSITORY_DIR是输入参数
get_cmake_files(
  GIT_REPOSITORY_DIR ${GIT_TOPLEVEL} 
  OUTPUT_LIST CMAKE_FILES 
  REGEX "\\.cmake$|(^|/)CMakeLists\\.txt$"
)
## @todo: 正则表达式学习 \\.cmake$|(^|/)CMakeLists\\.txt$
  # \\.cmake$：表示匹配以 .cmake 结尾的文件名。其中，"." 表示匹配任意一个字符，"\" 表示转义字符，"." 和 "$" 分别表示结尾符号。  

  # 正则表达式 (^|/)CMakeLists\\.txt$ 的含义如下：

  # ^ 表示字符串的开头。
  # | 表示或，分别连接两个子表达式。
  # () 表示分组，将表达式组合在一起。
  # ^|/ 表示字符串的开头或者 / 字符。
  # / 表示匹配一个 / 字符。
  # CMakeLists\\.txt 表示匹配 CMakeLists.txt 这个字符串。
  # $ 表示字符串的结尾。
  # 因此，(^|/)CMakeLists\\.txt$ 可以匹配以 CMakeLists.txt 结尾的文件名，要么在字符串的开头，要么在 / 字符的后面。例如，CMakeLists.txt 和 /path/to/CMakeLists.txt 都会被匹配到。 -> 不用写*.cmake$


# @Study: CMAKE_FORMAT_TARGET可以通过-DCMAKE_FORMAT_TARGET=${name}传递进来
if(CMAKE_FORMAT_TARGET STREQUAL fix-cmake-format)
  # -i 表示在原文件上进行修改，而不是输出到标准输出
  execute_process(COMMAND ${CMAKE_FORMAT_PROGRAM} -i ${CMAKE_FILES})
  # 直接从这个cmake脚本返回了
  return()
endif()

if(CMAKE_FORMAT_TARGET STREQUAL check-cmake-format)
  set(OUTPUT_QUIET_OPTION OUTPUT_QUIET)
endif()

# formatted.cmake是后面中通过${CMAKE_FORMAT_PROGRAM} -o后自动生产的formatted.cmake
set(formatted_cmake_file ${BINARY_DIR}/formatted.cmake)
foreach(cmake_file IN LISTS CMAKE_FILES)
  set(source_cmake_file ${CMAKE_SOURCE_DIR}/${cmake_file})
  # 如果将 -i 参数替换为 -o，则 execute_process() 命令的作用将变成将格式化后的内容输出到指定的文件中，而不是直接在原文件上进行修改
  execute_process(COMMAND ${CMAKE_FORMAT_PROGRAM} -o ${formatted_cmake_file} ${source_cmake_file})
  execute_process(
    ## @Study: git diff --no-index的作用：
      # --no-index 参数是用来指定 Git 命令不要使用 Git 仓库中的历史记录进行比较，而是直接比较两个文件或目录之间的差异。

      # 举个例子，假设我们有两个文本文件 file1.txt 和 file2.txt，它们并不在同一个 Git 仓库中，但我们想比较这两个文件之间的差异。这时候，我们可以使用 git diff --no-index file1.txt file2.txt 命令，指定要比较的两个文件，然后 Git 会根据文件内容的差异生成相应的差异报告。

      # --no-index 参数还可以用于比较两个目录之间的差异。例如，我们有两个目录 dir1 和 dir2，它们中包含一些不同的文件或子目录。此时，我们可以使用 git diff --no-index dir1 dir2 命令来比较这两个目录之间的差异，并查看它们之间的文件差异以及文件内容的不同之处。

      # 总之，--no-index 参数让 Git 能够直接比较两个文件或目录的差异，而无需使用 Git 仓库中的历史记录。这在比较不同代码库之间的差异时非常有用，也可以用来比较本地未提交的修改和 Git 仓库中的文件之间的差异。
    COMMAND ${GIT_PROGRAM} diff --color --no-index -- ${source_cmake_file} ${formatted_cmake_file}
    # RESULT_VARIABLE 是 execute_process() 命令的一个可选参数，用于指定执行命令后返回值的变量名。当指定了这个参数时，CMake 会在执行 execute_process() 命令后将命令返回值赋值给该变量，供后续使用。
    RESULT_VARIABLE result ${OUTPUT_QUIET_OPTION}
  )
  # 表示有诧异结果输出result
  if(OUTPUT_QUIET_OPTION AND result)
    message(FATAL_ERROR "${cmake_file} needs to be reformatted")
  endif()
endforeach()
