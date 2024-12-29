FROM golang:1.23-alpine AS build-env

WORKDIR /home/app

COPY . .
RUN go build -o work .

# Runtime image
FROM alpine

WORKDIR /home/app
RUN addgroup -S app && adduser -S app -G app
USER app:app

COPY --from=build-env --chown=app:app /home/app/work .

EXPOSE 8080
CMD ["./work"]
