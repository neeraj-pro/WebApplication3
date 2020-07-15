FROM registry.redhat.io/dotnet/dotnet-31-rhel7 AS base
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.vbproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "WebApplication3.dll"]
