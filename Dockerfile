# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy and restore dependencies
COPY ["Library Management/Library Management.csproj", "./"]
RUN dotnet restore "./Library Management.csproj"

# Copy entire source code
COPY . .

# ✅ Remove duplicate assembly attribute file (precaution)
RUN rm -f /src/obj/Release/net8.0/*.AssemblyAttributes.cs

# Publish the project
RUN dotnet publish "./Library Management.csproj" \
    -c Release -o /app/out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Set the entrypoint
ENTRYPOINT ["dotnet", "Library Management.dll"]
