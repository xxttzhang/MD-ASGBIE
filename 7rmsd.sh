path=$(pwd)
cd ${path}
mkdir RMSD
cd ./RMSD
cp ../mut_*/*.dat .
###################################
cat >RMSD.py<<EOF
import matplotlib.pyplot as plt 
import pandas as pd
import os
import re

def plot(filename,i):
    fig = plt.figure(1)
    # fig.patch.set_alpha(0) #透明
    fig.set_figwidth(7)
    fig.set_figheight(5)
    plt.rcParams['font.family']='DeJavu Serif'
    plt.rcParams['font.serif']=['Times New Roman']
    # fig.patch.set_alpha(0) #透明
    plt.rcParams["font.weight"] = "bold"
    plt.rcParams["axes.labelweight"] = "bold"
    ax1 = fig.add_subplot(1, 1, 1)
    ax1.patch.set_alpha(0.0)
    filename.plot(x='#Frame', y='com', ax=ax1, color='black', linewidth=0.2)
    filename.plot(x='#Frame', y='pep', ax=ax1, color='darkblue', linewidth=0.2)
    filename.plot(x='#Frame', y='pro', ax=ax1, color='red', linewidth=0.2)
    filename.plot(x='#Frame', y='bind', ax=ax1, color='deepskyblue', linewidth=0.2)
    #filename.plot(x='#Frame', y='fe', ax=ax1, color='blue', linewidth=0.2)
    #filename.plot(x='#Frame', y='heme_no_fe', ax=ax1, color='gray', linewidth=0.2)
    #filename.plot(x='#Frame', y='oxy', ax=ax1, color='deepskyblue', linewidth=0.2)
    ax1.set_title('RMSD{}'.format(i[3:-4]), fontsize=15, fontweight='bold')
    ax1.set_xlabel('Time (ns)', fontsize=15)
    ax1.set_ylabel('RMSD ' + r'\$(\mathrm{\AA})$', fontsize=15)
    ax1.set_xlim([0, 100])
    ax1.set_ylim([0,5])
    # ax1.xaxis.set_ticks([60,65,70,75])
    ax1.xaxis.set_ticks([0,20,40,60,80,100])
    ax1.yaxis.set_ticks([0,1,2,3,4,5])
    ax1.tick_params(axis='y', labelsize=15)
    ax1.tick_params(axis='x', labelsize=15)
    ax1.legend(['com', 'pep','pro','bind'], frameon=False, fontsize=10)
    ax1.spines['bottom'].set_linewidth(1.5);  ###设置底部坐标轴的粗细
    ax1.spines['left'].set_linewidth(1.5);  ####设置左边坐标轴的粗细
    ax1.spines['right'].set_linewidth(1.5);  ###设置右边坐标轴的粗细
    ax1.spines['top'].set_linewidth(1.5);  ####设置上部坐标轴的粗细
    plt.subplots_adjust(left=None, bottom=0.18, right=None, top=None)
    plt.savefig('rmsd{}.png'.format(i[3:-4]), dpi=300)
    plt.clf()

filenames = os.listdir()
filename = []
for i in range(len(filenames)):
    if re.match(r'mut_\d{1}.dat', filenames[i]) :
        filename.append(filenames[i])

for i in range(len(filename)):
    rmsd = pd.read_table(r'{}'.format(filename[i]), encoding='utf_8_sig', engine='python', sep='\\s+')
    plot(rmsd,'{}'.format(filename[i]))
EOF
#############
python RMSD.py
##############
cd ..            
