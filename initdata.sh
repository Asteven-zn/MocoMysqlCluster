#/bin/bash

# Authenticated user
dbuser="tcsa"
# Authenticated user password
userpwd="tcsaMysql8016"
# The namespace of the database
ns="mysql-test"
#platform:dev,test,prod
plf="test"

# Read write separated database
databases_arr=(
        "data_simulator"
        "open_platform"
)

#Check user
echo -e "\033[34m#>>>>>>-Check DataBases User ${dbuser}\033[0m"

kubectl-moco mysql -it -u moco-admin -n ${ns} mysql -- -e "select user from mysql.user;" | grep ${dbuser} > /dev/null 2>&1

if [ $? -eq 0 ];then
        echo -e "\033[33mUser ${dbuser} is created\033[0m"
else
        echo -e "\033[32mStart create user ${dbuser}\033[0m"
        kubectl-moco mysql -it -u moco-admin -n ${ns} mysql -- -e "CREATE USER '${dbuser}'@'%' IDENTIFIED WITH mysql_native_password BY '${userpwd}';"
        kubectl-moco mysql -it -u moco-admin -n ${ns} mysql -- -e "GRANT ALL PRIVILEGES ON *.* TO '${dbuser}'@'%';"
        kubectl-moco mysql -it -u moco-admin -n ${ns} mysql -- -e "CREATE USER 'sharding'@'%' IDENTIFIED WITH mysql_native_password BY 'sharding';"
        kubectl-moco mysql -it -u moco-admin -n ${ns} mysql -- -e "GRANT ALL PRIVILEGES ON *.* TO 'sharding'@'%';"
        kubectl-moco mysql -it -u moco-admin -n ${ns} mysql -- -e "flush privileges;"
fi

#Check DataBases
echo -e "\033[34m#>>>>>>-Check DataBases\033[0m"

for item in ${databases_arr[*]}
do
	kubectl-moco mysql -it -u moco-admin -n ${ns} mysql -- -e "show databases;" | grep ${item} > /dev/null 2>&1
	if [ $? -eq 0 ];then
        	echo -e "\033[33m${item}_${plf} DataBases is created\033[0m"
	else
		echo -e "\033[32mStart ${item}_${plf} DataBases\033[0m"
                kubectl-moco mysql -it -u moco-admin -n ${ns} mysql -- -e "CREATE DATABASE ${item}_${plf};"
        fi
done
