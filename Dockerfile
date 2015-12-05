FROM ubuntu:14.04

### add postgres repo
RUN touch /etc/apt/sources.list.d/pgdg.list
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install -y --force-yes postgresql-9.4

###configure postgresql
#RUN useradd postgres
#-p means create parent as nessesary
RUN mkdir -p /usr/local/pgsql/data
RUN chown postgres /usr/local/pgsql/data

env PATH $PATH:/usr/lib/postgresql/9.4/bin

USER postgres
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf


RUN initdb -D /usr/local/pgsql/data

EXPOSE 5432
 
ENTRYPOINT postgres -D /usr/local/pgsql/data