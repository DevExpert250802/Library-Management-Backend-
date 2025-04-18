# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project file and restore dependencies
COPY ["Library Management/Library Management.csproj", "Library Management/"]
WORKDIR "/src/Library Management"
RUN dotnet restore "Library Management.csproj"

# Copy everything else
WORKDIR /src
COPY . .

#  REMOVE duplicate TargetFramework attribute file
RUN rm -f "Library Management/obj/Release/net8.0/*.AssemblyAttributes.cs"

# Publish the app
WORKDIR "/src/Library Management"
RUN dotnet publish "Library Management.csproj" -c Release -o /app/out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .

ENTRYPOINT ["dotnet", "Library Management.dll"]
