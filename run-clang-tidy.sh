#!/bin/sh
# ./run-clang-tidy.sh BUILD_DIR HEAD NCPU EXCLUDE_DIRS

# @Status: OK

# @Summary: 这是一个用于运行Clang-Tidy代码分析工具的shell脚本，主要功能是对Git代码库中进行了更改的文件（通过git diff命令确定）进行分析，如果发现代码中存在问题，返回值为1，否则返回值为0。

sum=0

echo "$1"
echo "$2"
echo "$3"

# @Study: sh中cd到repo的根目录
cd $(git rev-parse --show-toplevel)
git diff --name-only --diff-filter=d "$2" $4 | grep '\.\(h\|hpp\|c\|cpp\|cc\)$' | xargs -t -d '\n' -r -n 1 -P "$3" clang-tidy -p "$1"
sum=$?
cd -

if [ ${sum} -eq 0 ]; then
    exit 0
else
    exit 1
fi
