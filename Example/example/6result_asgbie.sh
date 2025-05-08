path=$(pwd)
line=`wc -l sele.txt | awk '{printf $1}'`


for j in $(seq 1 $line)
do
d=`cat sele.txt | head -$j |tail -1`

#tail -1 ${path}/${d}/ASGBIE_pp/ASGB/prepare/AlaScan_GB.dat | awk ' {print $6}' >> ASGBIE.dat
tail -1 ${path}/${d}/ASGBIE_10~20/ASGB/prepare/AlaScan_GB.dat  >> ASGB.dat
tail -1 ${path}/${d}/ASGBIE_10~20/ASIE/prepare/AlaScan_IE.dat | awk ' {print $3}'>> ASIE.dat

done

paste ASGB.dat ASIE.dat >asgb_1.dat
paste sele.txt asgb_1.dat >ASGBIE.dat
rm ASIE.dat ASGB.dat asgb_1.dat
