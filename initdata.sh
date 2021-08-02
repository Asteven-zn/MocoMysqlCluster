#/bin/bash

dbuser="tcsa"
ns="moco-demo"

databases_arr=(
        "data_simulator_dev"
        "data_simulator_dev"
)

#Check DataBases
echo -e "\033[34m#>>>>>>-Check DataBases\033[0m"

for item in ${databases_arr[*]}
do
	kubectl-moco mysql -it -u moco-admin -n ${ns} mysql -- -e "show databases;" | grep ${item} > /dev/null 2>&1
	if [ $? -eq 0 ];then
        	echo -e "\033[33mDataBases ${item} is created\033[0m"
	else
		echo -e "\033[32mStart ${item} DataBases\033[0m"
		kubectl-moco mysql -it -u moco-admin -n mysql-test mysql -- -e "CREATE DATABASE ${item}" 
        fi
done

#Check user
echo -e "\033[34m#>>>>>>-Check DataBases User ${dbuser}\033[0m"

kubectl-moco mysql -it -u moco-admin -n ${ns} mysql -- -e "select user from mysql.user;" | grep ${dbuser} > /dev/null 2>&1

if [ $? -eq 0 ];then
        echo -e "\033[33mUser ${dbuser} is created\033[0m"
else
        echo -e "\033[32mStart create ${dbuser}\033[0m"
        kubectl-moco mysql -it -u moco-admin -n mysql-test mysql -- -e "CREATE USER '${dbuser}'@'%' IDENTIFIED BY '${dbuser}';"
        kubectl-moco mysql -it -u moco-admin -n mysql-test mysql -- -e "GRANT ALL PRIVILEGES ON *.* TO '${dbuser}'@'%';"
        kubectl-moco mysql -it -u moco-admin -n mysql-test mysql -- -e "flush privileges;"
fi
