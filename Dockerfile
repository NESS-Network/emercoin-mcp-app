# Multi-stage build
FROM golang:1.22-alpine AS builder
WORKDIR /src
COPY . .
RUN go mod download && go build -o /out/emercoin-mcp-app ./cmd

FROM alpine:3.20
WORKDIR /app
COPY --from=builder /out/emercoin-mcp-app /usr/local/bin/emercoin-mcp-app
# Expect TLS certs to be mounted at /certs/cert.pem and /certs/key.pem
ENV TLS_CERT=/certs/cert.pem
ENV TLS_KEY=/certs/key.pem
EXPOSE 443
ENTRYPOINT ["/usr/local/bin/emercoin-mcp-app]