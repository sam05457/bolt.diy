#!/bin/bash

# Start script optimized for Render deployment
echo "Starting Bolt.DIY on Render..."

# Set default port if not provided
export PORT=${PORT:-5173}

# Get bindings from environment variables
bindings=$(./bindings.sh)

echo "Using port: $PORT"
echo "Starting wrangler pages dev..."

# Start the application
exec wrangler pages dev ./build/client $bindings --ip 0.0.0.0 --port $PORT --no-show-interactive-dev-session
