FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY TestService.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish -c release -o /app


FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app .
ENV ASPNETCORE_URLS http://*:5082
ENV DOTNET_STARTUP_HOOKS Instana.Tracing.Core.dll
ENTRYPOINT ["dotnet", "TestService.dll"]