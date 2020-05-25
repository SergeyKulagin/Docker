# About
Zookeeper image adopted for Kubernetes Stateful pods
based on https://github.com/31z4/zookeeper-docker.
I did a little clean-up and adopted for my needs.
# Build command
```
docker buildx build \
--platform linux/arm64,linux/amd64 \
--tag sergeykulagin/zookeeper:3.5.7 --push . 
```