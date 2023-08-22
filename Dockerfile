FROM golang:1.17-alpine AS builder

RUN apk update && apk add --no-cache git
ENV USER=appuser
ENV UID=10001

RUN adduser \
--disabled-password \
--gecos "" \
--home "/nonexistent" \
--shell "/sbin/nologin" \
--no-create-home \
--uid "${UID}" \
"${USER}"WORKDIR $GOPATH/src/mypackage/myapp

WORKDIR /go/src/app
COPY go.mod ./
COPY *.go ./
RUN go mod download
RUN go mod verify
COPY static ./static
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/main


FROM scratch

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /go/bin/main /go/bin/main

USER appuser:appuser

EXPOSE 9001

ENTRYPOINT [ "/main" ]
