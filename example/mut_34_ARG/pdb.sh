#!/bin/bash
input_file="sol_com.pdb"

# 删除第一行并存储到临时文件
tail -n +2 "$input_file" > temp_file.pdb

# 找到所有包含"TER"的行的行号
mapfile -t ter_lines < <(grep -n "^TER" "temp_file.pdb" | cut -d: -f1)

# 提取第一个TER段前的部分，并添加END，保存为l.pdb
sed "${ter_lines[0]}q" "temp_file.pdb" > pro.pdb
echo "END" >> pro.pdb

# 提取第一个到第二个TER段之间的部分，并添加END，保存为p.pdb
sed -n "$((ter_lines[0] + 1)),${ter_lines[1]}p" "temp_file.pdb" > lig.pdb
echo "END" >> lig.pdb

# 提取前两个TER段的内容，并添加END，保存为c.pdb
sed "${ter_lines[1]}q" "temp_file.pdb" > com.pdb
echo "END" >> com.pdb

# 删除临时文件
rm temp_file.pdb
