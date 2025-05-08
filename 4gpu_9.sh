#Sleep
sleep 1s
##
ls -1 ./ > pwd.txt
awk '$1 ~ /^mut_*/' pwd.txt > sele.txt
rm pwd.txt 

#!/bin/bash

# 读取sele.txt文件中的每个目录名称
while IFS= read -r directory
do
    # 进入当前目录
    cd "$directory"
    
    # 如果在目录下找到了gpu.sh，则执行bsub命令提交作业
    if [[ -f "gpu.sh" ]]; then
        bsub < gpu.sh
    else
        echo "在目录 $directory 下没有找到 gpu.sh 文件。"
    fi  
    
    # 返回到脚本所在的目录
    cd ..
done < sele.txt
