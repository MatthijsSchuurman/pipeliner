FROM alpine:latest

RUN apk add --no-cache \
    openjdk21-jre-headless

# Workaround for workdir (WORKDIR command creates it as root)
RUN addgroup -S java && adduser -S java -G java -h /home/java && \
    mkdir -p /home/java/app && \
    chown -R java:java /home/java

WORKDIR /home/java/app
USER java:java

COPY --chown=java:java build/distributions/HelloWorld-*.tar .
RUN tar -xvf HelloWorld-*.tar --strip-components=1 && \
    rm bin/*.bat

EXPOSE 8080
CMD [ "bin/HelloWorld" ]