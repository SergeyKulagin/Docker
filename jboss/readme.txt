put standalone.xml

run:
docker run -t -i -d --name pg -p 5432:5432 d660728a9a85

run:
docker run -i -t --link pg:pg -v ~/standalone.xml:/usr/local/share/jboss/standalone/configuration/standalone.xml -p 8080:8080 -p 9990:9990 -p 9998:999
9 b6af43c7585a

run:
/usr/local/share/jboss/bin/standalone.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0
