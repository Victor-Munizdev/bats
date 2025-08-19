@echo off
TITLE Otimizacao do PC

:: Define o arquivo de log para registrar a execucao
set "log_file=%~dp0log_otimizacao.txt"
echo Otimizacao iniciada em %date% %time% > "%log_file%"
echo ----------------------------------------------------------------- >> "%log_file%"

:: Forca a execucao com permissoes de administrador imediatamente
:force_runas
if /i "%~1" equ "runas" goto :admin_mode
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\runas.vbs"
echo UAC.ShellExecute "%~s0", "runas", "", "runas", 1 >> "%temp%\runas.vbs"
"%temp%\runas.vbs"
del "%temp%\runas.vbs"
goto :eof

:admin_mode
cls

echo -----------------------------------------------------------------
echo     OTIMIZACAO AUTOMATICA DO SISTEMA
echo -----------------------------------------------------------------
echo.

echo Pressione qualquer tecla para iniciar...
pause >nul

::
:: SECAO 1: OTIMIZACAO E LIMPEZA DO SISTEMA
::

echo -----------------------------------------------------------------
echo     INICIANDO OTIMIZACAO E LIMPEZA
echo -----------------------------------------------------------------
echo.
>> "%log_file%" echo.
>> "%log_file%" echo -----------------------------------------------------------------
>> "%log_file%" echo     INICIANDO OTIMIZACAO E LIMPEZA
>> "%log_file%" echo -----------------------------------------------------------------
>> "%log_file%" echo.

echo Fechando navegadores para garantir a limpeza do cache...
taskkill /f /im chrome.exe >nul 2>nul
taskkill /f /im firefox.exe >nul 2>nul
echo Concluido.
echo.

echo Limpando arquivos temporarios do sistema...
>> "%log_file%" echo Limpando arquivos temporarios do sistema...
rem Limpa o conteudo das pastas temporarias de forma robusta
del /f /s /q "%TEMP%\*.*" >nul 2>nul
for /d %%d in ("%TEMP%\*") do rmdir "%%d" /s /q >nul 2>nul
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>nul
for /d %%d in ("C:\Windows\Temp\*") do rmdir "%%d" /s /q >nul 2>nul
echo Concluido.
echo.

echo Limpando cache do Google Chrome...
>> "%log_file%" echo Limpando cache do Google Chrome...
rem Limpa o cache do Chrome (perfil padrao) de forma robusta
if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Cache" (
    del /f /s /q "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>nul
    for /d %%d in ("%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Cache\*") do rmdir "%%d" /s /q >nul 2>nul
)
if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Code Cache" (
    del /f /s /q "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Code Cache\*.*" >nul 2>nul
    for /d %%d in ("%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Code Cache\*") do rmdir "%%d" /s /q >nul 2>nul
)
echo Concluido.
echo.

echo Limpando cache do Mozilla Firefox...
>> "%log_file%" echo Limpando cache do Mozilla Firefox...
rem Limpa o cache do Firefox de forma robusta, buscando por perfis
for /d %%d in ("%USERPROFILE%\AppData\Local\Mozilla\Firefox\Profiles\*.default-release") do (
    if exist "%%d\cache2" (
        del /f /s /q "%%d\cache2\*.*" >nul 2>nul
        for /d %%e in ("%%d\cache2\*") do rmdir "%%e" /s /q >nul 2>nul
    )
)
echo Concluido.
echo.

::
:: FIM DO SCRIPT
::

echo -----------------------------------------------------------------
echo     OTIMIZACAO COMPLETA CONCLUIDA!
echo -----------------------------------------------------------------
echo.
echo Pressione qualquer tecla para fechar...
pause >nul