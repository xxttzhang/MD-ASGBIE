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
bond c.52.SG c.78.SG
bond c.69.SG c.109.SG
bond c.92.SG c.131.SG
bond c.216.SG c.286.SG
bond c.407.SG c.461.SG
bond c.419.SG c.451.SG
bond c.436.SG c.483.SG

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
