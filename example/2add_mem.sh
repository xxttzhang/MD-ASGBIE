path=$(pwd)
cd ${path}
for dir in $(ls ${path})
do
    if [ -d "${path}/$dir" ]; then
        cd "${path}/$dir"
        current_dir=$(basename "$(pwd)")
        echo "${current_dir}"
#############################
rm bilayer_com.pdb packmol-memgen* sol_com* packmol* test* C*
################################
cat >packmol_memgen.sh<<EOF
#!/bin/sh
#BSUB -J packmol
#BSUB -q normal
#BSUB -n 1
#BSUB -R "span[hosts=1]"
#BSUB -o packmol%J.out

##################################################################
source ~/yhe/.bashrc
##################################################################
packmol-memgen --pdb ./com.pdb --lipids POPC:CHL1 --ratio 9:1 --salt --salt_c Na+ --saltcon 0.15 --dist 10 --dist_wat 15 --notprotonate --nottrim

EOF
################################
bsub < packmol_memgen.sh
################################
        echo "done"
        cd ..
    fi
done
