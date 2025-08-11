#!/bin/bash

# Start script optimized for Render deployment
echo "Starting Bolt.DIY on Render..."

# Set default port if not provided
export PORT=${PORT:-5173}

# Get bindings from environment variables
bindings=$(./bindings.sh)

echo "Using port: $PORT"
echo "Checking for wrangler..."

# Debug: Check what's available
echo "PATH: $PATH"
echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"
echo "PNPM version: $(pnpm --version)"

# Try multiple ways to find wrangler
if command -v wrangler &> /dev/null; then
    echo "Found global wrangler: $(which wrangler)"
    exec wrangler pages dev ./build/client $bindings --ip 0.0.0.0 --port $PORT --no-show-interactive-dev-session
elif command -v npx &> /dev/null; then
    echo "Using npx wrangler..."
    exec npx wrangler pages dev ./build/client $bindings --ip 0.0.0.0 --port $PORT --no-show-interactive-dev-session
elif [ -f "./node_modules/.bin/wrangler" ]; then
    echo "Using local wrangler from node_modules..."
    exec ./node_modules/.bin/wrangler pages dev ./build/client $bindings --ip 0.0.0.0 --port $PORT --no-show-interactive-dev-session
else
    echo "ERROR: Cannot find wrangler anywhere!"
    echo "Available commands:"
    ls -la /usr/local/bin/ | grep -E "(wrangler|npx)" || echo "No wrangler or npx found in /usr/local/bin/"
    echo "Node modules bin:"
    ls -la ./node_modules/.bin/ | grep wrangler || echo "No wrangler found in node_modules/.bin/"
    exit 1
fi
