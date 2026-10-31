@echo off
setlocal
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
    echo ERRO: Flutter nao foi encontrado no PATH.
    echo Configure o Flutter e execute novamente.
    pause
    exit /b 1
)
echo Preparando o projeto Flutter...
call flutter create --project-name apis_divertidas_flutter --platforms=android,web .
if errorlevel 1 goto falha
call flutter pub get
if errorlevel 1 goto falha
call flutter run
if errorlevel 1 goto falha
exit /b 0
:falha
echo.
echo Ocorreu um erro. Confira as mensagens acima.
pause
exit /b 1
