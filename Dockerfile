FROM node:20-bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 \
    libdbus-1-2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 \
    libxrandr2 libgbm1 libasound2 libpango-1.0-0 libgtk-3-0 \
    libxshmfence1 libx11-xcb1 libxcb-dri3-0 libxext6 libx11-6 libxcb1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm ci

RUN npx playwright install --with-deps chromium firefox webkit

COPY playwright.config.ts ./
COPY tests/ ./tests/

CMD ["npx", "playwright", "test", "--reporter=line"]
