# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy project file and restore dependencies
COPY ["RenderBlazorDemo.csproj", "./"]
RUN dotnet restore "RenderBlazorDemo.csproj"

# Copy the remaining source code and build
COPY . .
RUN dotnet publish "RenderBlazorDemo.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
EXPOSE 8080

COPY --from=build /app/publish .

# Bind the app to port 8080 required by Render
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "RenderBlazorDemo.dll"]
