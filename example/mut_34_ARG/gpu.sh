#!/bin/sh
#BSUB -J mut_34_ARG
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
export PATH=/data/apps/cuda-10.2/bin:$PATH
export LD_LIBRARY_PATH=/data/apps/cuda-10.2/lib64:$LD_LIBRARY_PATH
##################################################################
#command:
pmemd -O -i $PWD/min1.in -o min1.out -p sol_com.prmtop -c sol_com.inpcrd  -r min1.rst -ref sol_com.inpcrd
pmemd.cuda -O -i $PWD/min2.in -o min2.out -p sol_com.prmtop -c min1.rst -r min2.rst
pmemd.cuda -O -i $PWD/heat1.in  -o heat1.out  -p sol_com.prmtop -c min2.rst -r heat1.rst  -ref min2.rst -x heat1.nc
pmemd.cuda -O -i $PWD/heat2.in  -o heat2.out  -p sol_com.prmtop -c heat1.rst -r heat2.rst  -ref heat1.rst -x heat2.nc
pmemd.cuda -O -i $PWD/back.in -o back.out -p sol_com.prmtop -c heat2.rst  -r back.rst -x back.nc -ref heat2.rst
pmemd.cuda -O -i $PWD/Calpha.in -o Calpha.out -p sol_com.prmtop -c back.rst  -r Calpha.rst -x Calpha.nc -ref back.rst
pmemd.cuda -O -i $PWD/prod.in -o prod.out -p sol_com.prmtop -c Calpha.rst  -r prod.rst -x prod.nc -ref Calpha.rst

cpptraj < trajin_rmsd
rm heat1.nc heat2.nc back.nc Calpha.nc 

#let "i=2"
#while [ $i -le 2 ]
#do
#let "j=i-1"
#pmemd.cude -O -i md1.in  -o md${i}.out -p pep.top -c md${j}.rst -r md${i}.rst -x md${i}.crd </dev/null
#let "i++"
#done
