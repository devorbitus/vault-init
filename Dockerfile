FROM golang:1.13 AS builder

ENV GO111MODULE=on \
  CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64

WORKDIR /go/src/app
# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
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
