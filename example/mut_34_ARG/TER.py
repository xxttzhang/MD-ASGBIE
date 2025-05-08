def insert_ter_between_residues(pdb_filename):
    # 打开PDB文件并读取所有行
    with open(pdb_filename, 'r') as file:
        lines = file.readlines()

    # 遍历行以找到第六个字段为30和下一行的第六个字段为31的行
    for i in range(len(lines) - 1):
        # 获取当前行和下一行的残基编号
        current_residue_number = lines[i][22:26].strip()
        next_residue_number = lines[i + 1][22:26].strip()

        # 检查当前行和下一行的残基编号是否只包含数字
        if current_residue_number.isdigit() and next_residue_number.isdigit():
            # 检查当前行残基编号为30且下一行残基编号为31
            current_residue_number = int(current_residue_number)
            next_residue_number = int(next_residue_number)
            if current_residue_number == 37 and next_residue_number == 38:
                # 在这两行之间插入TER
                lines.insert(i + 1, 'TER\n')
                print(f"在残基编号29和30之间成功插入TER。")
                # 只插入一次TER，如果需要插入多个TER，则取消下面这行的注释
                # break
                # 添加这个条件来确保只修改第一次符合条件的情况
                break
    # 将修改后的内容写回文件
    with open(pdb_filename, 'w') as file:
        file.writelines(lines)
# 使用指定的PDB文件名调用函数
pdb_filename = 'bilayer_com.pdb'
insert_ter_between_residues(pdb_filename)
