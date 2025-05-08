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
#########################
num=`grep 'ATOM' ./com.pdb | tail -1 | awk '{print $2}'`
########################
cat >trajin.in<<EOF
parm sol_com.prmtop
trajin min2.rst
strip !@1-${num}
trajout md.nc netcdf
go
EOF
#####################
cpptraj < trajin.in

sleep 60
##########################
cp -r /data/home/zhzhang/xtzhang/base/ASGBIE_base/ASGBIE_AIB/ASGBIE_min2frame .
cd ASGBIE_min2frame
bash asgbie.sh
#####################
echo "done"
        cd ..
    fi  
done
