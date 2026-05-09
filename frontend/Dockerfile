FROM node:20
WORKDIR /usr/src/app

# Copy package files first to leverage Docker cache
COPY package*.json ./

# Install dependencies (fall back to npm install if npm ci fails)
RUN npm ci --silent || npm install --silent

# Copy rest of the app
COPY . .

EXPOSE 4200
CMD ["npm", "start"]
