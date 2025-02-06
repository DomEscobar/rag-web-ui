FROM node:18-alpine AS builder

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm@8

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy the rest of the application
COPY . .

# Build the frontend
RUN pnpm build

# Production image
FROM node:18-alpine AS runner

WORKDIR /app

# Copy the built app from the builder stage
COPY --from=builder /app /app

# Expose the port (assuming 3000 for Next.js, change if needed)
EXPOSE 3000

# Start the app in production mode
CMD ["pnpm", "start"]
