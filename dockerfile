FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /dotnet-app
EXPOSE 80


FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Tailspin.SpaceGame.Web/Tailspin.SpaceGame.Web.csproj", "Tailspin.SpaceGame.Web/"]
RUN dotnet restore "Tailspin.SpaceGame.Web/Tailspin.SpaceGame.Web.csproj"
COPY . .
WORKDIR "/src/Tailspin.SpaceGame.Web"
RUN dotnet build "Tailspin.SpaceGame.Web.csproj" -c Release -o /dotnet-app/build

FROM build AS publish
RUN dotnet publish "Tailspin.SpaceGame.Web.csproj" -c Release -o /dotnet-app/publish

FROM base AS final
WORKDIR /dotnet-app
COPY --from=publish /dotnet-app/publish .
ENTRYPOINT ["dotnet", "Tailspin.SpaceGame.Web.dll"]
