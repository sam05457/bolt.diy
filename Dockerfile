# Use Node.js 20 LTS as base image (alpine variant for smaller image size)
FROM node:20.18.0-alpine AS base

# Set working directory
WORKDIR /app

# Install pnpm globally
RUN npm install -g pnpm@9.14.4

# Copy package files for dependency installation
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Production build stage
FROM base AS production

# Set environment variables for production
ENV NODE_ENV=production \
    WRANGLER_SEND_METRICS=false \
    RUNNING_IN_DOCKER=true

# Build arguments for API keys (will be passed from Render environment)
ARG GROQ_API_KEY
ARG HuggingFace_API_KEY
ARG OPENAI_API_KEY
ARG ANTHROPIC_API_KEY
ARG OPEN_ROUTER_API_KEY
ARG GOOGLE_GENERATIVE_AI_API_KEY
ARG OLLAMA_API_BASE_URL
ARG XAI_API_KEY
ARG TOGETHER_API_KEY
ARG TOGETHER_API_BASE_URL
ARG AWS_BEDROCK_CONFIG
ARG VITE_LOG_LEVEL=info
ARG DEFAULT_NUM_CTX
ARG OPENAI_LIKE_API_KEY
ARG OPENAI_LIKE_API_BASE_URL
ARG DEEPSEEK_API_KEY
ARG LMSTUDIO_API_BASE_URL
ARG MISTRAL_API_KEY
ARG PERPLEXITY_API_KEY

# Set environment variables from build args
ENV GROQ_API_KEY=${GROQ_API_KEY} \
    HuggingFace_API_KEY=${HuggingFace_API_KEY} \
    OPENAI_API_KEY=${OPENAI_API_KEY} \
    ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY} \
    OPEN_ROUTER_API_KEY=${OPEN_ROUTER_API_KEY} \
    GOOGLE_GENERATIVE_AI_API_KEY=${GOOGLE_GENERATIVE_AI_API_KEY} \
    OLLAMA_API_BASE_URL=${OLLAMA_API_BASE_URL} \
    XAI_API_KEY=${XAI_API_KEY} \
    TOGETHER_API_KEY=${TOGETHER_API_KEY} \
    TOGETHER_API_BASE_URL=${TOGETHER_API_BASE_URL} \
    AWS_BEDROCK_CONFIG=${AWS_BEDROCK_CONFIG} \
    VITE_LOG_LEVEL=${VITE_LOG_LEVEL} \
    DEFAULT_NUM_CTX=${DEFAULT_NUM_CTX} \
    OPENAI_LIKE_API_KEY=${OPENAI_LIKE_API_KEY} \
    OPENAI_LIKE_API_BASE_URL=${OPENAI_LIKE_API_BASE_URL} \
    DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY} \
    LMSTUDIO_API_BASE_URL=${LMSTUDIO_API_BASE_URL} \
    MISTRAL_API_KEY=${MISTRAL_API_KEY} \
    PERPLEXITY_API_KEY=${PERPLEXITY_API_KEY}

# Pre-configure wrangler to disable metrics
RUN mkdir -p /root/.config/.wrangler && \
    echo '{"enabled":false}' > /root/.config/.wrangler/metrics.json

# Make scripts executable
RUN chmod +x ./bindings.sh ./start-render.sh

# Build the application
RUN pnpm run build

# Expose port (Render will use PORT environment variable)
EXPOSE $PORT

# Start command optimized for Render
CMD ["./start-render.sh"]
