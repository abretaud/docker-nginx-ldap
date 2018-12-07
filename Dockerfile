FROM debian:stretch

MAINTAINER Anthony Bretaudeau <anthony.bretaudeau@inra.fr>

ENV NGINX_VERSION release-1.15.7

# Use jessie-backports for openssl >= 1.0.2
# This is required by nginx-auth-ldap when ssl_check_cert is turned on.
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
	&& echo 'deb http://ftp.debian.org/debian/ stretch-backports main' > /etc/apt/sources.list.d/backports.list \
	&& apt-get update \
	&& apt-get install -t stretch-backports -y \
		ca-certificates \
		git \
		gcc \
		make \
		libpcre3-dev \
		zlib1g-dev \
		libldap2-dev \
		libssl-dev \
		wget

# See http://wiki.nginx.org/InstallOptions
RUN mkdir /var/log/nginx \
	&& mkdir /etc/nginx \
	&& cd ~ \
	&& git clone https://github.com/kvspb/nginx-auth-ldap.git \
	&& git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module.git \
	&& git clone https://github.com/nginx/nginx.git \
    && git clone --branch v0.32 https://github.com/openresty/set-misc-nginx-module.git \
    && git clone --branch v0.3.1rc1 https://github.com/simpl/ngx_devel_kit.git \
	&& cd ~/nginx \
	&& git checkout tags/${NGINX_VERSION} \
	&& ./auto/configure \
		--add-module=/root/nginx-auth-ldap \
        --add-module=/root/ngx_http_substitutions_filter_module \
        --add-module=/root/ngx_devel_kit \
        --add-module=/root/set-misc-nginx-module \
		--with-http_ssl_module \
		--with-debug \
		--conf-path=/etc/nginx/nginx.conf \
		--sbin-path=/usr/sbin/nginx \
		--pid-path=/var/log/nginx/nginx.pid \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
	&& make install \
	&& cd .. \
	&& rm -rf nginx-auth-ldap \
	&& rm -rf nginx

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Include conf from subdir + no default server block
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["nginx","-g","daemon off;"]
