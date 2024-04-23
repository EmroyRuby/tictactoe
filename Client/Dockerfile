FROM node:alpine
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
ENV HOST=0.0.0.0
EXPOSE 5173
CMD ["npm", "run", "dev"]
