# About
Kafka image adopted for Kubernetes Stateful pods
based on https://github.com/wurstmeister/kafka-docker
# Build command
```
docker buildx build \
 --platform linux/arm64,linux/amd64 \
 --tag sergeykulagin/kafka:2.5.0 \
 --push .```