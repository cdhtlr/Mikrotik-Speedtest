# builder image
FROM golang:alpine as builder
USER root
RUN mkdir -m 777 /speedtest-go/
COPY speedtest-go/. /speedtest-go/
WORKDIR /speedtest-go/
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w -extldflags=-static" -a -o speedtest .

# generate clean, final image for end users (ppc64le and s390x using 1.28.1-musl variant)
FROM busybox:1.28.1

LABEL maintainer="Sidik Hadi Kurniadi" name="Mikrotik Speedtest" description="Base minimum MikroTik-Terminal friendly Download Speedtest" version="4.2"

ENV URL="https://jakarta.speedtest.telkom.net.id.prod.hosts.ooklaserver.net:8080/download?size=25000000"
ENV MAX_DLSIZE="1.0"
ENV MIN_THRESHOLD="1.0"

COPY --from=builder /speedtest-go/speedtest .

EXPOSE 80

CMD ["/speedtest"]
