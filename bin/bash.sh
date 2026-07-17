 Set up your credentials
cp .env.example .env
# Edit .env and add your API key

# Run with defaults
./tmp/api-client.zsh

# Run with custom model and prompt
./tmp/api-client.zsh "gemini-pro" "Your custom prompt here"
 # Clone and set up environment
git clone https://github.com/auraecosystem/aura-moby
cd aura-moby
chmod +x bash.sh bash.zsh
./bash.sh

# Build via Zig + Go cross-compilation
zig build -Doptimize=ReleaseFast
go build -o aura-moby ./cmd/dev

# Or use the Makefile for multi-arch build + Docker packaging
make all
# Compiles: aura-moby-linux-amd64, aura-moby-linux-arm64
# Packages: ghcr.io/auraecosystem/aura-moby:latest

# Run tests
go test ./engine/...

# Sync docs for GitHub Pages
make doc-sync
