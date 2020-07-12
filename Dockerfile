# build environment
FROM node:10 as build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .

#RUN CI=true npm test

RUN npm run build

# production environment
FROM nginx:1.16.0-alpine
COPY --from=build /usr/src/app/build/ /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]