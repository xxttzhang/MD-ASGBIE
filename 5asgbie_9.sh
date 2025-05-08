path=$(pwd)
cd ${path}
for dir in $(ls ${path})
do
    if [ -d "${path}/$dir" ]; then
        cd "${path}/$dir"
        current_dir=$(basename "$(pwd)")
        echo "${current_dir}"
#############################
current_dir=$(basename "$(pwd)")
echo ${current_dir}
##RMSD记得改是次数
mv rms.dat ${current_dir}_md1.dat
#########################
rm -r ASGBIE_10~20 
rm com.pdb pro.pdb lig.pdb
#########################
cat >pdb.sh<<EOF
#!/bin/bash
input_file="sol_com.pdb"

# 删除第一行并存储到临时文件
tail -n +2 "\$input_file" > temp_file.pdb

# 找到所有包含 "TER" 的行号
mapfile -t ter_lines < <(grep -n "^TER" "temp_file.pdb" | cut -d: -f1)

# 提取第一个TER段前的部分（包括第一个TER），保存为pro.pdb
sed -n "1,\${ter_lines[0]}p" temp_file.pdb > pro.pdb
echo "END" >> pro.pdb

# 提取第一个到第三个TER段之间的部分（不包括第一个TER，只保留第二个TER），保存为lig.pdb
sed -n "\$((ter_lines[0] + 1)),\$((ter_lines[2]))p" temp_file.pdb | sed "/^TER$/d" > lig.pdb
echo "TER" >> lig.pdb
echo "END" >> lig.pdb

# 提取前三个TER段的内容，保存为com.pdb
sed -n "1,\${ter_lines[2]}p" temp_file.pdb > com.pdb
echo "END" >> com.pdb

# 删除临时文件
rm temp_file.pdb
EOF
#####################
bash pdb.sh
##########################
cp -r /data/home/zhzhang/xtzhang/base/ASGBIE_base/ASGBIE_AIB/ASGBIE_10~20 .
cd ASGBIE_10~20
bash asgbie.sh
#####################
echo "done"
        cd ..
    fi  
done
