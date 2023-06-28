ARG MARIADB_VERSION
FROM docker.io/library/mariadb:${MARIADB_VERSION}

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y libpam-ldap pamtester && rm -rf /var/lib/apt/*

COPY pam-mysql /etc/pam.d/mysql
RUN printf "plugin_load_add = auth_pam\npam_use_cleartext_plugin = ON" >> /etc/mysql/mariadb.conf.d/50-server.cnf
