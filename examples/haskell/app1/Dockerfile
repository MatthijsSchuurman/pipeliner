FROM alpine:lastest

RUN apk --no-cache add \
    libffi \
    libgmpxx

RUN addgroup -g 1000 app && adduser -D -u 1000 -G app app
WORKDIR /home/app
USER app:app

COPY --chown=app:app dist/helloworld .

EXPOSE 8080
CMD ["./helloworld"]