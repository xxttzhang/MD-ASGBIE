path=$(pwd)
cd ${path}
for dir in $(ls ${path})
do
    if [ -d "${path}/$dir" ]; then
        cd "${path}/$dir"
        current_dir=$(basename "$(pwd)")
        echo "${current_dir}"
#############################
  cat >leap_0.in<<EOF
source leaprc.mimetic.ff15ipq
source leaprc.water.spceb
set default PBRadii mbondi2
c = loadpdb ./complex.pdb
bond c.2.SG c.7.SG
bond c.55.SG c.81.SG
bond c.72.SG c.112.SG
bond c.95.SG c.134.SG
bond c.219.SG c.289.SG

savepdb c com.pdb
saveamberparm c com.prmtop com.inpcrd
quit
EOF
#############################
tleap -sf leap_0.in >leap_0.out
################################
        echo "done"
        cd ..
    fi
done
