FROM rust:1.77.2-alpine3.18 AS builder

WORKDIR /app
COPY . .

RUN apk add --no-cache musl-dev
RUN cargo install --path .

CMD [ "/usr/local/cargo/bin/rust-rocket-counter-api" ]
