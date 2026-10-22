FROM nginx:alpine
COPY /dist/<your-app-name>/browser /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
