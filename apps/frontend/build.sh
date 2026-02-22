#!/bin/sh
# This script is run during Docker build to inject API_URL into environment.ts

# Check if API_URL is provided, otherwise use default
if [ -z "$API_URL" ]; then
  API_URL="http://localhost:8000"
fi

# Create environment.ts with the API_URL
cat > ./src/app/environment.ts <<EOF
export const environment = {
  apiUrl: '$API_URL'
};
EOF

# Run the actual build
npm run build
