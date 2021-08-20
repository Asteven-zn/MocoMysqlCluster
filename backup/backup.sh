#!/bin/bash
#source /etc/profile

#################### Modify variable ###############
# Authenticated user
dbuser="tcsa"
# Authenticated user password
userpwd="tcsaMysql8016"
# The namespace of the database
ns="mysql-test"
#platform:dev,test,prod
plf="test"
######################## End #######################

#Judge primary variable,is master node and wirte data
primary=$(kubectl get -n mysql-${plf} mysqlclusters.moco.cybozu.com  | awk '/mysql/{print $4}')

# Read write separated database
databases_arr=(
        "data_simulator"
        "open_platform"
)

# Start backup
base_dir=$(cd "$(dirname "$0")"; pwd)
tim=$(date +"%Y-%m-%d_%H-%M-%S")
backup_dir=data-${tim}

echo -e "\033[34m#>>>>>>-Start backup databases\033[0m"
mkdir -p ${base_dir}/${backup_dir}

for itme in ${databases_arr[*]}
do
	echo -e "\033[32m#>>>>>>-Backup databases:${itme}\033[0m"
	kubectl exec -it -n ${ns} moco-mysql-${primary} -- mysqldump -h moco-mysql-primary -u ${dbuser} -p${userpwd} --set-gtid-purged=OFF --skip-add-locks --no-create-db --databases ${itme}_${plf} > ${base_dir}/${backup_dir}/${itme}-${tim}.sql
	
        if [ $? -eq 0 ];then
        	echo -e "\033[33m${itme} DataBases is backup success\033[0m"
	else
		echo -e "\033[31m${itme} DataBases is backup failed\033[0m"
		mv ${base_dir}/${backup_dir}/${itme}-${tim}.sql ${base_dir}/${backup_dir}/${itme}-${tim}-failed.sql
        fi
done

#check failed backup
ls ${base_dir}/${backup_dir}/ | grep failed > /dev/null 2>&1

if [ $? -eq 0 ];then
	mv ${base_dir}/${backup_dir} ${base_dir}/${backup_dir}_failed
fi
