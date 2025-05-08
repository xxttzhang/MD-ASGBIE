path=$(pwd)
cd ${path}
for dir in $(ls ${path})
do
    if [ -d "${path}/$dir" ]; then
        cd "${path}/$dir"
        current_dir=$(basename "$(pwd)")
        echo "${current_dir}"
#############################
cat >TER.py<<EOF
def insert_ter_between_residues(pdb_filename):
    # 打开PDB文件并读取所有行
    with open(pdb_filename, 'r') as file:
        lines = file.readlines()

    # 初始化一个变量来记录是否插入了TER
    ter_inserted = False

    # 遍历行以找到目标残基编号之间的位置
    for i in range(len(lines) - 1):
        # 获取当前行和下一行的残基编号
        current_residue_number = lines[i][22:26].strip()
        next_residue_number = lines[i + 1][22:26].strip()

        # 检查当前行和下一行的残基编号是否只包含数字
        if current_residue_number.isdigit() and next_residue_number.isdigit():
            # 转换为整数以便比较
            current_residue_number = int(current_residue_number)
            next_residue_number = int(next_residue_number)

            # 如果匹配 37 和 38 之间，插入 TER
            if current_residue_number == 37 and next_residue_number == 38:
                lines.insert(i + 1, "TER\n")
                print(f"在残基编号37和38之间成功插入TER。")
                ter_inserted = True

            # 如果匹配 406 和 407 之间，插入 TER
            if current_residue_number == 406 and next_residue_number == 407:
                lines.insert(i + 1, "TER\n")
                print(f"在残基编号406和407之间成功插入TER。")
                ter_inserted = True

    # 检查是否插入了TER，如果没有则提示
    if not ter_inserted:
        print("未找到符合条件的残基编号，未插入任何TER。")

    # 将修改后的内容写回文件
    with open(pdb_filename, 'w') as file:
        file.writelines(lines)

# 使用指定的PDB文件名调用函数
pdb_filename = 'bilayer_com.pdb'
insert_ter_between_residues(pdb_filename)
EOF
####################
python TER.py
####################
x_len=$(awk '{if($1=="x_len"){printf $3}}' ./packmol-memgen.log)
y_len=$(awk '{if($1=="y_len"){printf $3}}' ./packmol-memgen.log)
z_len=$(awk '{if($1=="z_len"){printf $3}}' ./packmol-memgen.log)
####################
cat >leap.in<<EOF
source leaprc.mimetic.ff15ipq
source leaprc.water.spceb
source leaprc.lipid21
c = loadpdb ./bilayer_com.pdb
bond c.2.SG c.7.SG
bond c.52.SG c.78.SG
bond c.69.SG c.109.SG
bond c.92.SG c.131.SG
bond c.216.SG c.286.SG
bond c.407.SG c.461.SG
bond c.419.SG c.451.SG
bond c.436.SG c.483.SG
set c box {$x_len $y_len $z_len}
saveamberparm c sol_com.prmtop sol_com.inpcrd
savepdb c sol_com.pdb
quit
EOF
#############################
tleap -sf leap.in > leap.out &
#############################
#rm low_* bilayer_com.pdb_FORCED comin_memembed.log packmol.inp packmol.log packmol-memgen.log resfile.in ru.sh score.sc TER.py
#############################
 cat >min1.in<<EOF
minimize
 &cntrl
  imin=1,maxcyc=1000,ncyc=500,
  ntb=1,ntp=0,
  ntf=1,ntc=1,
  ntpr=50,
  ntwr=2000,
  cut=10.0,
 /
EOF
cat >min2.in<<EOF
minimize
 &cntrl
  imin=1,maxcyc=10000,ncyc=5000,   
  ntb=1,ntp=0,
  ntf=1,ntc=1,
  ntpr=50,
  ntwr=2000,
  cut=10.0,
 /
EOF
cat >heat1.in<<EOF
 heating LIPID 128 100K
 &cntrl
   imin=0, ntx=1, irest=0, 
   ntc=2, ntf=2, tol=0.0000001,
   nstlim=2500, ntt=3, gamma_ln=1.0,
   ntr=1, ig=-1,
   ntpr=100, ntwr=10000,ntwx=100,
   dt=0.002,nmropt=1,
   ntb=1,ntp=0,cut=10.0,ioutfm=1,ntxo=2,
   restraint_wt=5.0, restraintmask='!:WAT,Na+,K+,Cl-',
 /
 &wt type='TEMP0', istep1=0, istep2=2500,
                   value1=0.0, value2=100.0 /
 &wt type='END' /
EOF
cat >heat2.in<<EOF
 heating LIPID 128 303K
 &cntrl
   imin=0, ntx=5, irest=1, 
   ntc=2, ntf=2,tol=0.0000001,
   nstlim=50000, ntt=3, gamma_ln=1.0, 
   ntr=1, ig=-1,
   ntpr=100, ntwr=10000,ntwx=100,
   dt=0.002,nmropt=1,
   ntb=2,taup=2.0,cut=10.0,ioutfm=1,ntxo=2,
   ntp=2,
   restraint_wt=5.0, restraintmask='!:WAT,Na+,K+,Cl-',
 /
 &wt type='TEMP0', istep1=0, istep2=50000,
                   value1=100.0, value2=303.0 /
 &wt type='END' /
EOF
cat >back.in<<EOF
 pro 1ns LIPID 303K backbone atoms
 &cntrl
   imin=0, ntx=5, irest=1, 
   ntc=2, ntf=2, tol=0.0000001,
   nstlim=500000, ntt=3, gamma_ln=1.0,
   temp0=303.0,
   ntpr=5000, ntwr=500000, ntwx=5000,
   dt=0.002, ig=-1,
   ntr=1, ntb=2, cut=10.0, ioutfm=1, ntxo=2,
   ntp=3, csurften=3, gamma_ten=0.0, ninterface=2, 
   restraint_wt=5.0, restraintmask=':@CA,C,N'
 /
 /
 &ewald
  skinnb=3.0,
 /
EOF
cat >Calpha.in<<EOF
 pro 1ns LIPID 303K alpha carbons only 
 &cntrl
   imin=0, ntx=5, irest=1, 
   ntc=2, ntf=2, tol=0.0000001,
   nstlim=500000, ntt=3, gamma_ln=1.0,
   temp0=303.0,
   ntpr=5000, ntwr=500000, ntwx=5000,
   dt=0.002, ig=-1,
   ntr=1, ntb=2, cut=10.0, ioutfm=1, ntxo=2,
   ntp=3, csurften=3, gamma_ten=0.0, ninterface=2, 
   restraint_wt=5.0, restraintmask=':@CA'
 /
 /
 &ewald
  skinnb=3.0,
 /
EOF
###################
num=`grep 'ATOM' ./com.pdb | tail -1 | awk '{print $2}'`
#############################
cat >prod.in<<EOF
pro 20ns LIPID 303K
 &cntrl
   imin=0, ntx=5, irest=1,
   ntc=2, ntf=2, tol=0.0000001,
   nstlim=10000000, ntt=3, gamma_ln=1.0,
   temp0=303.0,
   ntpr=5000, ntwr=500000, ntwx=5000,
   dt=0.002, ig=-1,
   ntb=2, cut=10.0, ioutfm=1, ntxo=2,
   ntp=3, csurften=3, gamma_ten=0.0, ninterface=2,
   ntwprt = ${num},
 /
 /
 &ewald
  skinnb=3.0,
 /
EOF
####################
current_dir=$(basename "$(pwd)")
echo ${current_dir}
###################
cat >gpu.sh<<EOF
#!/bin/sh
#BSUB -J ${current_dir}
#BSUB -gpu "num=1:mode=exclusive_process"
#BSUB -n 1
#BSUB -q gpu
#BSUB -o test%J.out
#BSUB -e test%J.err
nvidia-smi > out

##################################################################
source ~/ylcong/.bashrc
###cuda
export CUDA_HOME=/data/apps/cuda-10.2/
export PATH=/data/apps/cuda-10.2/bin:\$PATH
export LD_LIBRARY_PATH=/data/apps/cuda-10.2/lib64:\$LD_LIBRARY_PATH
##################################################################
#command:
pmemd -O -i \$PWD/min1.in -o min1.out -p sol_com.prmtop -c sol_com.inpcrd  -r min1.rst -ref sol_com.inpcrd
pmemd.cuda -O -i \$PWD/min2.in -o min2.out -p sol_com.prmtop -c min1.rst -r min2.rst
pmemd.cuda -O -i \$PWD/heat1.in  -o heat1.out  -p sol_com.prmtop -c min2.rst -r heat1.rst  -ref min2.rst -x heat1.nc
pmemd.cuda -O -i \$PWD/heat2.in  -o heat2.out  -p sol_com.prmtop -c heat1.rst -r heat2.rst  -ref heat1.rst -x heat2.nc
pmemd.cuda -O -i \$PWD/back.in -o back.out -p sol_com.prmtop -c heat2.rst  -r back.rst -x back.nc -ref heat2.rst
pmemd.cuda -O -i \$PWD/Calpha.in -o Calpha.out -p sol_com.prmtop -c back.rst  -r Calpha.rst -x Calpha.nc -ref back.rst
pmemd.cuda -O -i \$PWD/prod.in -o prod.out -p sol_com.prmtop -c Calpha.rst  -r prod.rst -x prod.nc -ref Calpha.rst

cpptraj < trajin_rmsd
rm heat1.nc heat2.nc back.nc Calpha.nc 

#let "i=2"
#while [ \$i -le 2 ]
#do
#let "j=i-1"
#pmemd.cude -O -i md1.in  -o md\${i}.out -p pep.top -c md\${j}.rst -r md\${i}.rst -x md\${i}.crd </dev/null
#let "i++"
#done
EOF
#####################
cat >trajin_rmsd<<EOF
parm ./com.prmtop
trajin prod.nc  

reference ./com.pdb
autoimage

rms com reference mass out rms.dat :1-523@CA,C,N time 0.01
rms pep reference mass out rms.dat :1-37@CA,C,N time 0.01
rms pro reference mass out rms.dat :38-523@CA,C,N time 0.01
rms bind reference mass out rms.dat ((:1-37<:5)&(:38-523@CA,C,N))|((:38-523<:5)&(:1-37@CA,C,N))  time 0.01
EOF
#####################
chmod +x *pu.sh 
#####################
echo "done"
        cd ..
    fi  
done      
