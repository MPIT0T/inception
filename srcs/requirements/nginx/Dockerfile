FROM debian:12

RUN apt update && \
    apt install -y nginx openssl curl bash && \
    apt clean

COPY conf /etc/nginx/conf.d/
COPY tools /tools

RUN chmod +x /tools/init.sh
RUN chmod +x /tools/generate_cert.sh

EXPOSE 443

ENTRYPOINT ["/tools/init.sh"]
