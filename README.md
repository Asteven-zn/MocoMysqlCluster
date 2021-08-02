# MocoMysqlCluster
Start MocoMysqlCluster

Start sharding-proxy
1. 配置shardingsphere-proxy-5.0.0/configmap目录下的配置文件
config-server.yaml
config-readwrite-splitting.yaml

及shardingsphere-proxy-5.0.0/shardingsphere-proxy.yaml

2. 启动sharding-proxy
kubectl apply -f shardingsphere-proxy-5.0.0/shardingsphere-proxy.yaml