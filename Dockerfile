FROM denoland/deno:1.41.3

# Set working directory
WORKDIR /app

# Copy dependency configuration files
COPY deno.json deno.lock ./

# Copy source code
COPY . .

# Cache dependencies
RUN deno cache main.ts

# Expose port (port 8080 is used in main.ts)
EXPOSE 8080

# Configure health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD deno eval "try { await fetch('http://localhost:8080/mcp'); Deno.exit(0); } catch { Deno.exit(1); }"

# Run application
CMD ["deno", "run", "--allow-net", "--allow-env", "--allow-read", "main.ts"]
