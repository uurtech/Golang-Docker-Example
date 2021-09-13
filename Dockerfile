FROM golang:latest

# because we use go mod
WORKDIR /app
COPY src/ .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .


FROM alpine:latest as certs
RUN apk --update add ca-certificates

FROM scratch

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=0 /app/main .
CMD ["./main"]