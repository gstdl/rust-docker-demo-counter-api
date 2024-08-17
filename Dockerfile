# Base image
FROM rust:1.77.2-alpine3.18
# Set working directory
WORKDIR /app
# Copy application code and dependencies
COPY . .
# Install OS dependencies
RUN apk add --no-cache musl-dev
# Build the application
RUN cargo install --path .
# Set environment variable ROCKET_ADDRESS
ENV ROCKET_ADDRESS 0.0.0.0
# Run the application
CMD [ "/usr/local/cargo/bin/rust-rocket-counter-api" ]
