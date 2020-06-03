# About
Zookeeper image adopted for Kubernetes Stateful pods
based on https://github.com/31z4/zookeeper-docker.
I did a little clean-up and adopted it for my needs.
# Cli
`zkCli.sh -server 192.168.100.34:30130` - to connect to a zookeeper node.  
After the connection it will show the list of available commands. 
# Build command
```
docker buildx build \
--platform linux/arm64,linux/amd64 \
--tag sergeykulagin/zookeeper:3.5.7 --push . 
```