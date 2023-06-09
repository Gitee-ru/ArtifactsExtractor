FROM golang:1.17-alpine AS builder
RUN adduser -D -g '' app
RUN apk --update add ca-certificates
COPY src/ /src/
WORKDIR /src
RUN env CGO_ENABLED=0 go build -o artifactsextractor main.go

FROM scratch
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /src/artifactsextractor /usr/bin/artifactsextractor
USER app
ENTRYPOINT ["/usr/bin/artifactsextractor"]