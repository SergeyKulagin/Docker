docker pull webcenter/activemq:5.13.2

docker run --name='activemq1' -it --rm -P \
-p 8161:8161 \
-p 61616:61616 \
-p 61613:61613 \
webcenter/activemq:5.13.2