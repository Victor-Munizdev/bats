@echo off
TITLE Backup Completo do Usuario (Final)

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
echo     INICIANDO BACKUP COMPLETO DO PERFIL DE USUARIO
echo -----------------------------------------------------------------
echo.
echo.

:: Define a pasta de origem principal (o perfil do usuario)
set "user_profile_dir=%USERPROFILE%"
set "username_normalized=%USERNAME: =_%"

:: Obtem a data e hora para criar uma pasta com timestamp no formato brasileiro (DD-MM-AAAA)
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do set "data=%%a-%%b-%%c"
for /f "tokens=1-2 delims=:" %%a in ('time /t') do set "hora=%%a-%%b"

:: Define o nome da pasta de backup de forma mais legivel e segura
set "nome_pasta=Backup-%username_normalized%-%data%-%hora%"

:: Define a pasta de destino, que sera criada na raiz do drive C
set "backup_dir=C:\Backup"
set "destino=%backup_dir%\%nome_pasta%"

echo O backup sera salvo em: %destino%
echo.

:: Cria a pasta de destino
if not exist "%backup_dir%" mkdir "%backup_dir%"
if not exist "%destino%" mkdir "%destino%"

::
:: Inicia a copia das pastas padrao do usuario (com localizacao precisa)
::

echo.
echo Copiando Documentos...
echo.
set "documents_path="
for /f "delims=" %%a in ('powershell -command "[Environment]::GetFolderPath('MyDocuments')"') do set "documents_path=%%a"
if defined documents_path (
    robocopy "%documents_path%" "%destino%\Documentos" /E /S /Z /zb /r:0 /w:0 /xjd /tee 2>&1
) else (
    echo [AVISO] A pasta de Documentos nao foi encontrada. Pulando...
)
echo Concluido.

echo.
echo Copiando Downloads...
echo.
set "downloads_path="
for /f "delims=" %%a in ('powershell -command "[Environment]::GetFolderPath('MyDocuments')"') do set "downloads_path=%%a"
set "downloads_path=%user_profile_dir%\Downloads"
if defined downloads_path (
    robocopy "%downloads_path%" "%destino%\Downloads" /E /S /Z /zb /r:0 /w:0 /xjd /tee 2>&1
) else (
    echo [AVISO] A pasta de Downloads nao foi encontrada. Pulando...
)
echo Concluido.

echo.
echo Copiando Area de Trabalho...
echo.
set "desktop_path="
for /f "delims=" %%a in ('powershell -command "[Environment]::GetFolderPath('Desktop')"') do set "desktop_path=%%a"
if defined desktop_path (
    robocopy "%desktop_path%" "%destino%\Area de Trabalho" /E /S /Z /zb /r:0 /w:0 /xjd /tee 2>&1
) else (
    echo [AVISO] A pasta de Area de Trabalho nao foi encontrada. Pulando...
)
echo Concluido.

echo.
echo Copiando Imagens...
echo.
set "pictures_path="
for /f "delims=" %%a in ('powershell -command "[Environment]::GetFolderPath('MyPictures')"') do set "pictures_path=%%a"
if defined pictures_path (
    robocopy "%pictures_path%" "%destino%\Imagens" /E /S /Z /zb /r:0 /w:0 /xjd /tee 2>&1
) else (
    echo [AVISO] A pasta de Imagens nao foi encontrada. Pulando...
)
echo Concluido.

echo.
echo Copiando Videos...
echo.
set "videos_path="
for /f "delims=" %%a in ('powershell -command "[Environment]::GetFolderPath('MyVideos')"') do set "videos_path=%%a"
if defined videos_path (
    robocopy "%videos_path%" "%destino%\Videos" /E /S /Z /zb /r:0 /w:0 /xjd /tee 2>&1
) else (
    echo [AVISO] A pasta de Videos nao foi encontrada. Pulando...
)
echo Concluido.

echo.
echo Copiando Musicas...
echo.
set "music_path="
for /f "delims=" %%a in ('powershell -command "[Environment]::GetFolderPath('MyMusic')"') do set "music_path=%%a"
if defined music_path (
    robocopy "%music_path%" "%destino%\Musicas" /E /S /Z /zb /r:0 /w:0 /xjd /tee 2>&1
) else (
    echo [AVISO] A pasta de Musicas nao foi encontrada. Pulando...
)
echo Concluido.

echo.
echo Copiando Favoritos do Google Chrome...
echo.
set "source_path=%user_profile_dir%\AppData\Local\Google\Chrome\User Data\Default"
if exist "%source_path%\Bookmarks" (
    robocopy "%source_path%" "%destino%\Favoritos\Chrome" "Bookmarks*" /E /S /Z /zb /r:0 /w:0 /xjd /tee 2>&1
) else (
    echo [AVISO] A pasta de favoritos do Chrome nao foi encontrada. Pulando...
)
echo Concluido.

echo.
echo Copiando Favoritos do Mozilla Firefox...
echo.
set "source_path=%user_profile_dir%\AppData\Roaming\Mozilla\Firefox"
if exist "%source_path%" (
    robocopy "%source_path%" "%destino%\Favoritos\Firefox" /E /S /Z /zb /r:0 /w:0 /xjd /tee 2>&1
) else (
    echo [AVISO] A pasta de favoritos do Firefox nao foi encontrada. Pulando...
)
echo Concluido.

echo.
echo -----------------------------------------------------------------
echo     BACKUP COMPLETO CONCLUIDO!
echo -----------------------------------------------------------------
echo.
echo Pressione qualquer tecla para fechar...
pause >nul