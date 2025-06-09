FROM debian:11

RUN apt update && \
    apt install -y mariadb-server && \
    apt clean

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY tools/init.sh /init.sh

RUN chmod +x /init.sh

EXPOSE 3306
CMD ["/init.sh"]
