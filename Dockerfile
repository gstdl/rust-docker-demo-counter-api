FROM rust:1.77.2-alpine3.18 AS builder

WORKDIR /app
COPY . .

RUN apk add --no-cache musl-dev
RUN cargo install --path .

# FROM alpine:3.18
FROM scratch

WORKDIR /app/bin
COPY --from=builder /usr/local/cargo/bin/rust-rocket-counter-api  /app/bin/app

CMD [ "./app" ]