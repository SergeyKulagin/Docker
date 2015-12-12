FROM ubuntu:14.04

### add postgres repo
RUN touch /etc/apt/sources.list.d/pgdg.list
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install -y --force-yes postgresql-9.4 && apt-get install nano

###configure postgresql
#RUN useradd postgres
#-p means create parent as nessesary
RUN mkdir -p /usr/local/pgsql/data
RUN mkdir -p /var/run/postgresql/9.4-main.pg_stat_tmp
RUN chown postgres /usr/local/pgsql/data
RUN chown postgres /var/run/postgresql/9.4-main.pg_stat_tmp

env PATH $PATH:/usr/lib/postgresql/9.4/bin

USER postgres
RUN echo "host all  all    0.0.0.0/0  trust" >> /etc/postgresql/9.4/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf


RUN initdb -D /usr/local/pgsql/data
#RUN /etc/init.d/postgresql start

EXPOSE 5432
 
#CMD ["/etc/init.d/postgresql", "start"]  -- this not working
#ENTRYPOINT postgres -D /usr/local/pgsql/data -- this not working
CMD ["postgres", "-D", "/usr/local/pgsql/data", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]
