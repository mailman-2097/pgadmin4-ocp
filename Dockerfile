# TODO: Change to UBI Image
FROM python:3.11-alpine3.18

# create a non-privileged user to use at runtime
RUN addgroup -g 50 -S pgadmin \
 && adduser -D -S -h /pgadmin -s /sbin/nologin -u 1000 -G pgadmin pgadmin \
 && mkdir -p /pgadmin/config /pgadmin/storage \
 && chown -R 1000:50 /pgadmin

RUN apk add --no-cache ca-certificates

# Install postgresql tools for backup/restore
RUN apk add --no-cache libedit postgresql \
 && cp /usr/bin/psql /usr/bin/pg_dump /usr/bin/pg_dumpall /usr/bin/pg_restore /usr/local/bin/ \
 && apk del postgresql \
 && apk add --no-cache postgresql-dev libffi-dev

ARG PGADMIN_VERSION=8.9
ENV PYTHONDONTWRITEBYTECODE=1

# Install linux headers and upgrade pip 
RUN apk add --no-cache curl alpine-sdk linux-headers \
 && pip install --upgrade pip 

# Install pgadmin tool 
COPY cacert.pem $HOME
RUN pwd && ls -al $HOME
# RUN curl --cacert ~/cacert.pem -SO https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py3-none-any.whl
RUN curl -SO https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py3-none-any.whl
RUN pip install pgadmin4-${PGADMIN_VERSION}-py3-none-any.whl && apk del alpine-sdk linux-headers

EXPOSE 5050

COPY config_distro.py /usr/local/lib/python3.11/site-packages/pgadmin4/

USER pgadmin:pgadmin
CMD ["python", "./usr/local/lib/python3.11/site-packages/pgadmin4/pgAdmin4.py"]
VOLUME /pgadmin/
