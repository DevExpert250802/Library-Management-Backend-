# Stage 1: Build and publish the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy all source and build
COPY . ./
RUN dotnet publish -c Release -o /app/out

# Stage 2: Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .

EXPOSE 80
ENTRYPOINT ["dotnet", "Library_Management_Backend.dll"]
