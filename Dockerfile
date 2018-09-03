FROM node:carbon-alpine

WORKDIR /usr/tmp

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk --no-cache update \
    && apk add --no-cache --virtual .build-deps \
    gifsicle pngquant optipng libjpeg-turbo-utils \
    udev ttf-freefont chromium \
    && rm -rf /var/cache/apk/* /tmp/*

RUN npm install  -g pm2

# clear up
RUN rm -rf /usr/tmp

ENV CHROME_BIN=/usr/bin/chromium-browser
ENV LIGHTHOUSE_CHROMIUM_PATH=/usr/bin/chromium-browser

