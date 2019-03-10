FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY BooksApi/*.csproj ./BooksApi/
RUN dotnet restore

# copy everything else and build app
COPY BooksApi/. ./BooksApi/
WORKDIR /app/BooksApi
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS runtime
WORKDIR /app
COPY --from=build /app/BooksApi/out ./
ENTRYPOINT ["dotnet", "BooksApi.dll"]