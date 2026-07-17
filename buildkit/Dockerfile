# ==========================================
# STAGE 1: Build the Go Binary
# ==========================================
FROM golang:1.22-alpine AS builder

# Install system dependencies required for Web3/Ecosystem native compilation
RUN apk add --no-cache git make g++ gcc

WORKDIR /app

# Copy dependency maps and download modules
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Compile the static Go binary optimized for production 
# (removes debugging symbols to minimize size)
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o aura-service .

# ==========================================
# STAGE 2: Absolute Minimal Production Runtime
# ==========================================
FROM alpine:3.19 AS runtime
WORKDIR /aura-runtime

# Install basic SSL certificates so your service can make secure HTTPS requests
RUN apk add --no-cache ca-certificates

# Copy only the compiled binary from the builder stage
COPY --from=builder /app/aura-service .

# Standard default port for many gRPC services (change if your app uses a different port)
EXPOSE 50051

# Inject your target metadata tags directly into the container
ENV ECOSYSTEM="AURA" \
    LAYER="S4X" \
    BUILD_VERSION="V.FADK"

# Run the application
CMD ["./aura-service"]
