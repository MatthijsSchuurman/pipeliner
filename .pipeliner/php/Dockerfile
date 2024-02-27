FROM php:8.3-cli-alpine

RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN mkdir /php && \
    cd /php && \
    composer require --dev phpunit/phpunit ^11

WORKDIR /work
