@echo off
TITLE Limpeza Definitiva de Arquivos Temporarios

:: Este trecho verifica se o script esta sendo executado como administrador
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: Se o codigo de erro for 0, significa que o usuario é administrador
if %errorlevel% neq 0 (
    echo.
    echo -----------------------------------------------------------------
    echo     ATENCAO: Este script precisa de permissoes de Administrador.
    echo     Ele sera executado novamente com permissoes elevadas.
    echo -----------------------------------------------------------------
    echo.
    echo Pressione qualquer tecla para continuar...
    pause >nul
    
    :: Cria um script VBS para executar o .bat como administrador
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    
    :: Executa o script VBS
    "%temp%\getadmin.vbs"
    
    :: Apaga o arquivo VBS temporario
    del "%temp%\getadmin.vbs"
    
    goto :eof
)

:: Se o script chegou ate aqui, ele ja esta com permissoes de administrador
cls

echo -----------------------------------------------------------------
echo     Este script fara a limpeza de arquivos temporarios do sistema.
echo -----------------------------------------------------------------
echo.
echo ATENCAO: Alguns arquivos podem nao ser apagados se estiverem
echo em uso no momento. Isso e normal.
echo.
echo Pressione qualquer tecla para iniciar a limpeza...
pause
cls

echo.
echo --- INICIANDO LIMPEZA ---
echo.

echo [1/3] Limpando a pasta Temp do Usuario (%TEMP%)...
pushd %TEMP% && (
    del /q /f /s *.* >nul 2>&1
    for /d %%i in (*) do rd /s /q "%%i" >nul 2>&1
    popd
) || (
    echo     --> Nao foi possivel acessar a pasta Temp do Usuario.
)
echo Limpeza da pasta Temp do Usuario concluida.
echo.

echo [2/3] Limpando a pasta Temp do Windows (C:\Windows\Temp)...
pushd C:\Windows\Temp && (
    del /q /f /s *.* >nul 2>&1
    for /d %%i in (*) do rd /s /q "%%i" >nul 2>&1
    popd
) || (
    echo     --> Nao foi possivel acessar a pasta Temp do Windows. Execute como Administrador.
)
echo Limpeza da pasta Temp do Windows concluida.
echo.

echo [3/3] Limpando a pasta Prefetch (C:\Windows\Prefetch)...
pushd C:\Windows\Prefetch && (
    del /q /f /s *.* >nul 2>&1
    popd
) || (
    echo     --> Nao foi possivel acessar a pasta Prefetch. Execute como Administrador.
)
echo Limpeza da pasta Prefetch concluida.
echo.

echo -----------------------------------------------------------------
echo Limpeza de arquivos temporarios CONCLUIDA!
echo -----------------------------------------------------------------
echo.
echo A janela permanecera aberta. Pressione qualquer tecla para fechar.

REM Este comando aguarda indefinidamente ate que uma tecla seja pressionada.
timeout /t -1 >nul