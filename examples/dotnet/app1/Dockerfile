FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build-env

WORKDIR /home/app
USER app:app

COPY --chown=app:app . .
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0-alpine
WORKDIR /home/app

COPY --from=build-env /home/app/out .

EXPOSE 8080
CMD ["./work"]