#!/bin/bash

app='apache-shardingsphere-4.1.1-sharding-proxy-bin'
image_name='cloudhere/sharding-proxy:4.1.1'

tar zcf ./target/${app}.tar.gz ${app}

docker build -t ${image_name} --build-arg APP_NAME=${app} .
