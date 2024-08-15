FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

WORKDIR /home/pgadmin

# create a non-privileged user to use at runtime
RUN microdnf install shadow-utils \
 && useradd -u 1000 -r -g 50 -d /pgadmin -s /sbin/nologin -c "pgAdmin" pgadmin \
 && mkdir -p /pgadmin/config /pgadmin/storage \
 && chown -R 1000:50 /pgadmin

RUN microdnf install ca-certificates

# Install postgresql tools for backup/restore
RUN microdnf install libedit postgresql \
 && cp /usr/bin/psql /usr/bin/pg_dump /usr/bin/pg_dumpall /usr/bin/pg_restore /usr/local/bin/ \
 && microdnf remove postgresql \
 && microdnf install postgresql-devel libffi-devel

ARG PGADMIN_VERSION=8.9
ENV PYTHONDONTWRITEBYTECODE=1

# Install linux headers and upgrade pip
RUN microdnf install curl gcc glibc-devel make linux-headers \
 && pip install --upgrade pip 

# Install pgadmin tool
RUN curl -SO https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py3-none-any.whl
RUN pip install pgadmin4-${PGADMIN_VERSION}-py3-none-any.whl && microdnf remove gcc glibc-devel make linux-headers

EXPOSE 5050

COPY config_distro.py /usr/local/lib/python3.9/site-packages/pgadmin4/

USER pgadmin:pgadmin
CMD ["python", "/usr/local/lib/python3.9/site-packages/pgadmin4/pgAdmin4.py"]
VOLUME /pgadmin/