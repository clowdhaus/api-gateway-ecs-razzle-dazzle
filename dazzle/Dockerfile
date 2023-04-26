# Builder
FROM rust:1.68.2-alpine as builder

ENV UP_VERSION=v0.2.0
ENV UP_ARCH=x86_64

RUN apk add --no-cache musl-dev
WORKDIR /opt
COPY . .
RUN wget -qO- https://github.com/clowdhaus/up/releases/download/${UP_VERSION}/up-${UP_VERSION}-${UP_ARCH}-unknown-linux-musl.tar.gz | tar -xzv \
  && mv up-${UP_VERSION}-${UP_ARCH}-unknown-linux-musl/up . \
  && cargo build --release

# Final
FROM scratch

ENV PORT=3000

WORKDIR /app
COPY --from=builder /opt/target/release/dazzle .
COPY --from=builder /opt/up .

EXPOSE ${PORT}
CMD ["/app/dazzle"]
