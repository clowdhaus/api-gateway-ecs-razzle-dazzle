# Builder
FROM rust:1.68.2-alpine as builder

RUN apk add --no-cache musl-dev
WORKDIR /opt
COPY . .
RUN cargo build --release

# Final
FROM scratch

WORKDIR /opt/razzle
COPY --from=builder /opt/target/release/dazzle .

EXPOSE 3030
CMD ["/opt/razzle/dazzle"]
