# PGADMIN4 on OCP

This is based off the following project.

git@github.com:intuotechnologies/pgadmin-openshift.git

# Installing podman compose

https://www.redhat.com/sysadmin/install-python-pip-linux

pip3 install podman-compose

# Podman steps 

podman pull registry.access.redhat.com/ubi9/python-312:1-20.1722518948 

podman run --name pgadmin4 -it -p 5050:5050 registry.access.redhat.com/ubi9/python-312:1-20.1722518948 /bin/bash

podman run --name pgadmin4 -it -p 5050:5050 quay.education.nsw.gov.au/pgadmin4/pgadmin4 

