FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source
EXPOSE 80

# copy csproj and restore as distinct layers
COPY ["ConversaoPeso.sln", "."]
COPY ["ConversaoPeso.Web/ConversaoPeso.Web.csproj", "conversaopeso.web/"]
RUN dotnet restore "conversaopeso.web/ConversaoPeso.Web.csproj"

# copy everything else and build app
COPY ConversaoPeso.Web/. ./conversaopeso.web/
WORKDIR /source/conversaopeso.web
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]