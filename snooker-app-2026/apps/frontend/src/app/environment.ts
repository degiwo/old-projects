// This file is injected at build time with API_URL environment variable
export const environment = {
  apiUrl: (window as any)['API_URL'] || 'http://localhost:8000'
};
