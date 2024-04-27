# First Base image with alias:builder
FROM rust:1.77.2-alpine3.18 AS builder
# Set working directory
WORKDIR /app
# Copy application code and dependencies
COPY . .
# Install OS dependencies
RUN apk add --no-cache musl-dev
# Build the application
RUN cargo install --path .

# Second Base Image
FROM scratch
# Set working directory
WORKDIR /app/bin
# Copy the application binary
COPY --from=builder /usr/local/cargo/bin/rust-rocket-counter-api  /app/bin/app
# Copy config.yaml
COPY config.yaml /app/config.yaml
# Set environment variables
ENV CONFIG_PATH /app/config.yaml
ENV ROCKET_ADDRESS 0.0.0.0
# Run the binary
CMD [ "./app" ]