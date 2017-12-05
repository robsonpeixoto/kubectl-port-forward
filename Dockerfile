FROM alpine:3.7

RUN apk update \
  && apk add --no-cache socat supervisor py-jinja2 curl ca-certificates \
  && curl https://storage.googleapis.com/kubernetes-release/release/v1.7.6/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && mkdir -p /etc/supervisor.d \
  && mkdir -p /scripts \
  && mkdir -p /scripts/pids \
  && mkdir -p /app

WORKDIR /app

COPY ./files/watchman.sh /scripts/
COPY ./files/watchman.ini /etc/supervisor.d/
COPY ./templates /app/templates
COPY ./create-configs-file.py /app/
COPY ./entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
