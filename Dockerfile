FROM python:3.7
ENV PYTHONUNBUFFERED 1
WORKDIR /code
COPY requirements /code/
RUN apt-get update && apt-get install -y \
    gdal-bin libgdal-dev \
    python3-gdal \
    binutils libproj-dev \
 && rm -rf /var/lib/apt/lists/*
RUN pip install -r production.txt

ARG TEST
ENV DOCKERIZE_VERSION v0.6.1
RUN [ "x$TEST" = "x" ] && true || pip install -r test.txt
RUN [ "x$TEST" = "x" ] && true || curl -L -s -o dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz
RUN [ "x$TEST" = "x" ] && true || tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz
RUN [ "x$TEST" = "x" ] && true || rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY . /code
WORKDIR /code
