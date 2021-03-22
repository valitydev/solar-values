#!/bin/sh
set -ue

java \
    "-XX:OnOutOfMemoryError=kill %p" -XX:+HeapDumpOnOutOfMemoryError \
    -jar \
    /opt/proxy-mocketbank-mpi-vulnerable/proxy-mocketbank-mpi-vulnerable.jar \
    --server.port=8080 \
    ${@}
