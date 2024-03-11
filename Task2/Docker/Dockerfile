FROM mcr.microsoft.com/powershell:latest

WORKDIR /app

COPY Fibonacci.ps1 .

ENTRYPOINT ["pwsh", "-File", "./Fibonacci.ps1"]