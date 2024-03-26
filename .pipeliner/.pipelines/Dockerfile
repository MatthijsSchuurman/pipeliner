FROM nginx:alpine

ARG package

COPY $package \
    .pipeliner/README.md \
    .pipeliner/install \
    /usr/share/nginx/html/

RUN echo -e "server {\n\
    listen 80;\n\
    server_name localhost;\n\
    absolute_redirect off;\n\
    location / {\n\
        root /usr/share/nginx/html;\n\
        index index.html;\n\
    }\n\
    location /pipeliner.zip {\n\
        return 301 /$(basename $package);\n\
    }\n\
}" > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]