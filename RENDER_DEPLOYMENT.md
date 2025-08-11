# Deploying Bolt.DIY to Render

This guide explains how to deploy Bolt.DIY to Render using Docker.

## Prerequisites

1. A Render account (https://render.com)
2. Your Bolt.DIY project files
3. API keys for the AI services you want to use

## Deployment Steps

### 1. Prepare Your Project

Make sure you have the following files in your project:
- `Dockerfile` (optimized for Render)
- `.dockerignore` (to exclude unnecessary files)
- `render.yaml` (optional, for infrastructure as code)
- `start-render.sh` (startup script)

### 2. Upload to Render

1. **Via GitHub (Recommended):**
   - Push your code to a GitHub repository
   - Connect your GitHub account to Render
   - Create a new Web Service and select your repository

2. **Via Direct Upload:**
   - Zip your project folder
   - Upload directly to Render

### 3. Configure Environment Variables

In your Render dashboard, add the following environment variables:

#### Required:
- `NODE_ENV=production`
- `WRANGLER_SEND_METRICS=false`
- `RUNNING_IN_DOCKER=true`

#### API Keys (add as needed):
- `GROQ_API_KEY` - Your Groq API key
- `OPENAI_API_KEY` - Your OpenAI API key
- `ANTHROPIC_API_KEY` - Your Anthropic API key
- `GOOGLE_GENERATIVE_AI_API_KEY` - Your Google AI API key
- `OLLAMA_API_BASE_URL` - Your Ollama instance URL
- `XAI_API_KEY` - Your xAI API key
- `TOGETHER_API_KEY` - Your Together AI API key
- `TOGETHER_API_BASE_URL` - Together AI base URL
- `AWS_BEDROCK_CONFIG` - AWS Bedrock configuration
- `DEEPSEEK_API_KEY` - DeepSeek API key
- `MISTRAL_API_KEY` - Mistral API key
- `PERPLEXITY_API_KEY` - Perplexity API key

#### Optional:
- `VITE_LOG_LEVEL=info` (or debug for more verbose logging)
- `DEFAULT_NUM_CTX` - Default context window size

### 4. Service Configuration

- **Environment**: Docker
- **Dockerfile Path**: `./Dockerfile`
- **Docker Context**: `.`
- **Port**: Render will automatically set the PORT environment variable
- **Health Check Path**: `/`

### 5. Deploy

1. Click "Create Web Service"
2. Render will automatically build and deploy your application
3. The build process will:
   - Install dependencies with pnpm
   - Build the application
   - Start the server on the assigned port

## Troubleshooting

### Expected Warnings (Normal):

These warnings appear during build but don't affect functionality:

1. **"The CJS build of Vite's Node API is deprecated"**:
   - This is informational about future Vite versions
   - Your build will complete successfully
   - No action needed

2. **"Data fetching is changing to a single fetch in React Router v7"**:
   - Future compatibility notice for React Router
   - Current setup works fine
   - Optional: Add `v3_singleFetch` future flag if desired

3. **"no-git-info" version**: Normal when uploading directly (not via Git)

4. **"Some chunks are larger than 500 kB"**: Performance warning, doesn't affect functionality

5. **"Error when using sourcemap"**: Normal in production builds, doesn't affect functionality

### Common Issues:

1. **Git repository error**: This is normal when uploading directly. The app will show "no-git-info" for the commit version.

2. **Cloudflare Workerd binary error**: Fixed in the optimized Dockerfile by disabling the dev proxy during builds.

3. **"wrangler: not found" error**: Fixed by installing wrangler globally and adding npx fallback in startup script.

3. **Port binding issues**: Make sure the Dockerfile uses the PORT environment variable correctly.

4. **API key issues**: Verify all required API keys are set in the Render dashboard.

5. **Build failures**: Check the build logs in Render dashboard for specific error messages.

### Logs:

Monitor your application logs in the Render dashboard to troubleshoot any issues.

## Performance Notes

- The application uses Alpine Linux for a smaller image size
- Dependencies are cached for faster builds
- The build process is optimized for production deployment

## Security

- Never commit API keys to your repository
- Use Render's environment variable system for sensitive data
- The application runs in a containerized environment for security

## Support

If you encounter issues:
1. Check the Render build and runtime logs
2. Verify all environment variables are set correctly
3. Ensure your API keys are valid and have sufficient credits
