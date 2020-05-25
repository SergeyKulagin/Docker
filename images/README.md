# Multiarch build (requires docker > 19.03)
```shell script
docker run --privileged multiarch/qemu-user-static --reset -p yes
docker buildx rm builder
docker buildx create --name builder --driver docker-container --use
docker buildx inspect --bootstrap
```
#Images
- [Kafka](/images/kafka)  
- [Zookeeper](/images/zookeeper)