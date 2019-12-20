FROM golang:1.13 AS builder

ENV GO111MODULE=on \
  CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64

WORKDIR /go/src/app
COPY . .

RUN go build \
  -a \
  -ldflags "-s -w -extldflags 'static'" \
  -installsuffix cgo \
  -tags netgo \
  -mod vendor \
  -o /bin/vault-init \
  .

FROM centurylink/ca-certs
COPY --from=builder /bin/vault-init /
CMD ["/vault-init"]
