# Stage 1: Build and publish
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy and restore only the .csproj (using JSON syntax for the space)
COPY ["Library Management/Library Management.csproj", "./"]
RUN dotnet restore "./Library Management.csproj"

# Copy the rest of the code
COPY . .

# Publish, disabling automatic generation of assembly attributes
RUN dotnet publish "./Library Management.csproj" \
    -c Release -o /app/out \
    /p:GenerateAssemblyInfo=false

# Stage 2: Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=build /app/out .

EXPOSE 80
ENTRYPOINT ["dotnet", "Library Management.dll"]
