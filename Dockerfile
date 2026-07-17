# ----------------------------------------------------
# Stage 1: Build Environment
# ----------------------------------------------------
FROM golang:1.22-alpine AS builder
RUN apk add --no-cache \
    git \
    gcc \
    g++ \
    make \
    clang \
    lld \
    cmake \
    ninja \
    pkgconf \
    nasm \
    yasm \
    curl
WORKDIR /src
# Cache Go dependencies
COPY go.mod go.sum ./
RUN go mod download
# Copy source code
COPY . .
# Build static binary
RUN CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    go build \
    -a \
    -trimpath \
    -ldflags="-s -w" \
    -o /out/aura-service .
# ----------------------------------------------------
# Stage 2: Minimal Runtime
# ----------------------------------------------------
FROM scratch
WORKDIR /
COPY --from=builder /out/aura-service /aura-service
EXPOSE 50051
ENV SYSTEM_LAYER=S4X
ENV BUILD_CONFIG=ALL_ENV_PROD
ENTRYPOINT ["/aura-service"]
