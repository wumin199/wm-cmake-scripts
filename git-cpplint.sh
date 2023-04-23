#!/bin/sh


# @Status: OK

# @Summary: 用cpplint进行代码检查的方法

cpplint=cpplint
sum=0

cd $(git rev-parse --show-toplevel)
for file in $(git ls-files | grep '\.\(h\|hpp\|hxx\|c\|cpp\|cc\|cxx\)$'); do
    $cpplint $file
    ## @Study: $?可以用来判断cpplint xxx文件是否执行成功
        # 在 shell 中，$? 是一个特殊变量，用来存储上一次执行命令的返回值（也就是命令执行的状态码）。在大多数情况下，命令执行成功时返回值为 0，否则返回一个非 0 值。通过检查 $? 可以判断上一次命令执行的状态，并据此进行相应的处理。比如在 shell 脚本中，我们可以通过 if [ $? -eq 0 ]; then 的方式判断上一次命令是否执行成功。
    sum=$(expr ${sum} + $?)
done
cd -

if [ ${sum} -eq 0 ]; then
    exit 0
else
    exit 1
fi
