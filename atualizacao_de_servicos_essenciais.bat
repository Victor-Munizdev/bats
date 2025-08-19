@echo off
TITLE Atualizacao Automatica de Aplicativos - v3 (Com Logs)

:: Define o local e nome do arquivo de log na Area de Trabalho do usuario
SET LOG_FILE="%USERPROFILE%\Desktop\update_log.txt"

:: -----------------------------------------------------------------
:: Verificacao de Privilegios de Administrador
:: -----------------------------------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo.
    echo [ERRO] Solicitando privilegios de Administrador...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:: -----------------------------------------------------------------

cls

:: Inicia o arquivo de log, sobrescrevendo o antigo
echo ---------------------------------------------------- > %LOG_FILE%
echo Log de Atualizacao iniciado em: %DATE% as %TIME% >> %LOG_FILE%
echo ---------------------------------------------------- >> %LOG_FILE%
echo. >> %LOG_FILE%

echo -----------------------------------------------------------------
echo     ATUALIZACAO AUTOMATICA DE APLICATIVOS (COM LOGS)
echo -----------------------------------------------------------------
echo.
echo As operacoes serao registradas no arquivo:
echo %LOG_FILE%
echo.

:: Verifica se o winget esta instalado
echo Verificando a existencia do winget... >> %LOG_FILE%
where winget >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] O Windows Package Manager (winget) nao foi encontrado.
    echo [ERRO] O Windows Package Manager (winget) nao foi encontrado. >> %LOG_FILE%
    pause
    exit /b
)
echo Winget encontrado com sucesso. >> %LOG_FILE%
echo. >> %LOG_FILE%

echo --- VERIFICANDO APLICATIVOS PARA ATUALIZAR ---
echo Registrando a lista de aplicativos para atualizar no log...
echo.
echo Listando aplicativos com atualizacoes disponiveis... >> %LOG_FILE%
winget upgrade >> %LOG_FILE% 2>&1

echo.
echo Pressione qualquer tecla para iniciar a atualizacao...
pause
echo.

echo --- INICIANDO ATUALIZACAO ---
echo O processo comecara agora e pode levar varios minutos!
echo A saida completa sera gravada no arquivo de log.
echo.
echo Iniciando 'winget upgrade --all'. Isso pode demorar... >> %LOG_FILE%

:: Comando principal do winget, com saida e erros redirecionados para o log
winget upgrade --all --silent --accept-package-agreements --accept-source-agreements >> %LOG_FILE% 2>&1

echo Comando 'winget upgrade --all' concluido. Verificando o log para erros. >> %LOG_FILE%
echo. >> %LOG_FILE%
echo ---------------------------------------------------- >> %LOG_FILE%
echo Log de Atualizacao concluido em: %DATE% as %TIME% >> %LOG_FILE%
echo ---------------------------------------------------- >> %LOG_FILE%

echo.
echo -----------------------------------------------------------------
echo --- PROCESSO CONCLUIDO ---
echo -----------------------------------------------------------------
echo.
echo A operacao foi finalizada. Verifique o arquivo de log na sua
echo Area de Trabalho para ver os detalhes e possiveis erros.
echo.
echo Pressione qualquer tecla para fechar a janela.
pause