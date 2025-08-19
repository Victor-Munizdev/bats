@echo off
TITLE Ferramenta de Gerenciamento de Rede

:main_menu
cls
echo -----------------------------------------------------------------
echo     MENU DE FERRAMENTAS DE REDE
echo -----------------------------------------------------------------
echo.
echo Escolha uma opcao:
echo.
echo 1. Teste de Conectividade (Ping Google)
echo 2. Limpeza de Cache DNS (Flush DNS)
echo 3. Otimizacao de Rede (IP Release/Renew)
echo 4. Informacoes de Rede Detalhadas (IPConfig /all)
echo 5. Teste de Velocidade
echo 6. Rastrear Rota para um Site
echo 7. Reiniciar Adaptador de Rede
echo 8. Diagnostico Automatico do Windows
echo 9. Sair
echo.

set /p "choice=Digite o numero da opcao e pressione ENTER: "

if "%choice%"=="1" goto connectivity_test
if "%choice%"=="2" goto flush_dns
if "%choice%"=="3" goto network_optimization
if "%choice%"=="4" goto show_ip_details
if "%choice%"=="5" goto speed_test
if "%choice%"=="6" goto tracert_option
if "%choice%"=="7" goto restart_adapter
if "%choice%"=="8" goto windows_diagnostics
if "%choice%"=="9" goto exit_script

echo.
echo Opcao invalida. Tente novamente.
pause
goto main_menu

:connectivity_test
cls
echo -----------------------------------------------------------------
echo     TESTE DE CONECTIVIDADE
echo -----------------------------------------------------------------
echo.
echo Disparando ping para google.com...
ping google.com
echo.
echo Concluido.
pause
goto main_menu

:flush_dns
cls
echo -----------------------------------------------------------------
echo     LIMPANDO CACHE DNS
echo -----------------------------------------------------------------
echo.
echo Limpando cache do DNS resolver...
ipconfig /flushdns
echo.
echo Cache DNS liberado com sucesso.
pause
goto main_menu

:network_optimization
cls
echo -----------------------------------------------------------------
echo     OTIMIZACAO DE REDE
echo -----------------------------------------------------------------
echo.
echo Liberando endereco IP...
ipconfig /release
echo.
echo Renovando endereco IP...
ipconfig /renew
echo.
echo Otimizacao de rede concluida.
pause
goto main_menu

:show_ip_details
cls
echo -----------------------------------------------------------------
echo     INFORMACOES DE REDE DETALHADAS
echo -----------------------------------------------------------------
echo.
ipconfig /all
echo.
echo Concluido.
pause
goto main_menu

:speed_test
cls
echo -----------------------------------------------------------------
echo     TESTE DE VELOCIDADE
echo -----------------------------------------------------------------
echo.
echo Abrindo o site de teste de velocidade...
start https://www.speedtest.net/
echo.
echo Concluido.
pause
goto main_menu

:tracert_option
cls
echo -----------------------------------------------------------------
echo     RASTREAR ROTA (ESTA OPERACAO PDOE DEMORAR ALGUNS MINUTOS!)
echo -----------------------------------------------------------------
echo.
set /p "site=Digite o site ou IP para rastrear (ex: sistema.gruponasli.com.br): "
echo.
echo Rastreando rota para %site% com limite de 15 saltos...
tracert -h 15 %site%
echo.
echo Rastreamento concluido.
pause
goto main_menu

:restart_adapter
cls
echo -----------------------------------------------------------------
echo     REINICIAR ADAPTADOR DE REDE
echo -----------------------------------------------------------------
echo.
echo Esta funcao reinicia seu adaptador de rede.
echo Primeiro, vamos ver o nome do adaptador:
echo.
ipconfig | findstr "Adaptador"
echo.
set /p "adapter_name=Copie o nome exato do seu adaptador de rede (ex: Wi-Fi): "
echo.
echo Desativando o adaptador "%adapter_name%"...
netsh interface set interface "%adapter_name%" admin=disable
echo.
echo Ativando o adaptador "%adapter_name%"...
netsh interface set interface "%adapter_name%" admin=enable
echo.
echo Adaptador reiniciado com sucesso.
pause
goto main_menu

:windows_diagnostics
cls
echo -----------------------------------------------------------------
echo     DIAGNOSTICO AUTOMATICO DO WINDOWS
echo -----------------------------------------------------------------
echo.
echo Abrindo a ferramenta de diagnostico de rede do Windows...
msdt.exe -id NetworkDiagnosticsWeb
echo.
echo Diagnostico concluido.
pause
goto main_menu

:exit_script
cls
echo Sair do script...
echo.
exit