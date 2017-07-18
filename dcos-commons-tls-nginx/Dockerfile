FROM nginx
MAINTAINER Mesosphere Support <support@mesosphere.com>

RUN apt-get update && \
    rm -rf /etc/nginx/conf.d/* && \
    sed -i 's/access_log.*/access_log \/dev\/stdout;/g' /etc/nginx/nginx.conf && \
    sed -i 's/error_log.*/error_log \/dev\/stdout info;/g' /etc/nginx/nginx.conf && \
    sed -i 's/^pid/daemon off;\npid/g' /etc/nginx/nginx.conf

ADD ./assets/nginx.conf /etc/nginx/
ADD ./assets/tls.conf /etc/nginx/conf.d/
ADD ./assets/http.conf /etc/nginx/conf.d/

CMD ['nginx']