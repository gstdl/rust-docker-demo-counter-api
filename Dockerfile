FROM rust:1.77.2-alpine3.18                                  # Base image
WORKDIR /app                                                 # Working directory
COPY . .                                                     # Copy application code and dependencies
RUN apk add --no-cache musl-dev                              # Install OS dependencies
RUN cargo install --path .                                   # Build the application
CMD [ "/usr/local/cargo/bin/rust-rocket-counter-api" ]       # Run the application
