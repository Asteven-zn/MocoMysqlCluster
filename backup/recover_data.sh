#!/bin/bash
#初始化变量的值
input=''
#设置 input1 变量值为空
plf="test"
data_dir=$(ls -lr | grep data- | head -1 | awk -F " +" '{print $9}')
data_simulator=$(ls ${data_dir}|grep data_simulator)
open_platform=$(ls ${data_dir}|grep open_platform)

#until 循环，当 input1 变量的值为 exit 时退出该循环
until [ "$input" == '4' ]
do
       echo -e '\033[34m#################################################\033[0m'
       echo -e '\033[34m#-------- Please input the recover data --------#\033[0m'
       echo -e '\033[34m#         >>  1.data_simulator                  #\033[0m'
       echo -e '\033[34m#         >>  2.open_platform                   #\033[0m'
       echo -e '\033[34m#         >>  3.recover all data                #\033[0m'
       echo -e '\033[34m#         >>  4.exit                            #\033[0m'
       echo -e '\033[34m#################################################\033[0m'

       #读取键盘输入的数据
       read input
       #输入的不是 exit 时把用户输入的数据显示在屏幕上
       if [ "$input" == '1' ]
       then
                echo -e "\n\033[33myou change recover data_simulator\033[0m"
                echo $data_simulator
                kubectl exec -it -n mysql-test moco-mysql-0 \
			-- mysql -h moco-mysql-primary -u tcsa -ptcsaMysql8016 \
			data_simulator_${plf}<${data_dir}/${data_simulator}
                echo -e "\n\033[32mRestore data complete\033[0m\n"
       elif [ "$input" == '2' ]
       then
		echo -e "\n\033[33myou change recover open_platform\033[0m"
                echo -e "${open_platform}"
  		 kubectl exec -it -n mysql-test moco-mysql-0 \
			-- mysql -h moco-mysql-primary -u tcsa -ptcsaMysql8016 \
                        open_platform_${plf}<${data_dir}/${open_platform}
                echo -e "\n\033[32mRestore data complete\033[0m\n"
       elif [ "$input" == '3' ]
       then
                echo -e "\n\033[33myou change recover all data\033[0m"
                echo ${data_simulator} ${open_platform}
                kubectl exec -it -n mysql-test moco-mysql-0 \
                       -- mysql -h moco-mysql-primary -u tcsa -ptcsaMysql8016 \
                       data_simulator_${plf}<${data_dir}/${data_simulator}

                kubectl exec -it -n mysql-test moco-mysql-0 \
                       -- mysql -h moco-mysql-primary -u tcsa -ptcsaMysql8016 \
                       open_platform_${plf}<${data_dir}/${open_platform}
                echo -e "\n\033[32mRestore data complete\033[0m\n"
       #当输入为 exit 时显示退出脚本的提示
       else
                echo -e '\033[33mExit the script.\033[0m\n'
       fi
done
