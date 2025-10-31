@echo off
SETLOCAL

:: -----------------------------------------------------------------
:: Verifica por privilegios de administrador
:: -----------------------------------------------------------------
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ====================================================================
    echo  Este script precisa de privilegios de Administrador.
    echo.
    echo  Por favor, clique com o botao direito neste arquivo .bat e
    echo  selecione "Executar como administrador".
    echo ====================================================================
    echo.
    echo Pressione qualquer tecla para sair...
    pause >nul
    exit /b
)

echo Iniciando o processo de reinstalacao limpa do Medidor Educacao Conectada...
echo.

:: 1- Deleta o instalador antigo da pasta Downloads (ignora se nao existir)
echo [1/9] Deletando instalador antigo (se existir)...
del "%USERPROFILE%\Downloads\MedidorEducacaoConectada.exe" /f /q
echo.

:: 2- Instala o provedor NuGet e desinstala o programa "Medidor Educação Conectada" (Metodo PowerShell)
echo [2/9] Tentando desinstalar o programa "Medidor Educação Conectada" via PowerShell...
echo      (Instalando/verificando provedor NuGet... Aguarde...)
:: Este comando primeiro garante que o NuGet esta instalado e depois desinstala o pacote.
powershell -ExecutionPolicy Bypass -NoProfile -Command "Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208 -Force -Scope CurrentUser > $null; Get-Package -Name 'Medidor Educacao Conectada' | Uninstall-Package -ErrorAction SilentlyContinue -Force"
echo      Tentativa de desinstalacao via PowerShell concluida.
echo.

:: 3- Apaga a pasta "C:\Program Files\Nic.br" (se existir)
echo [3/9] Apagando pasta em Program Files...
if exist "C:\Program Files\Nic.br" (
    rmdir /s /q "C:\Program Files\Nic.br"
    echo      Pasta "C:\Program Files\Nic.br" removida.
) else (
    echo      Pasta "C:\Program Files\Nic.br" nao encontrada.
)
echo.

:: 4- Apaga a pasta "C:\Program FIles (x86)\NIC.br" (se existir)
echo [4/9] Apagando pasta em Program Files (x86)...
if exist "C:\Program Files (x86)\NIC.br" (
    rmdir /s /q "C:\Program Files (x86)\NIC.br"
    echo      Pasta "C:\Program Files (x86)\NIC.br" removida.
) else (
    echo      Pasta "C:\Program Files (x86)\NIC.br" nao encontrada.
)
echo.

:: 5- Apaga a pasta "C:\ProgramData\regid.2018-10.br.nic.simet,educ-conectada" (se existir)
echo [5/9] Apagando pasta em ProgramData...
if exist "C:\ProgramData\regid.2018-10.br.nic.simet,educ-conectada" (
    rmdir /s /q "C:\ProgramData\regid.2018-10.br.nic.simet,educ-conectada"
    echo      Pasta de ProgramData removida.
) else (
    echo      Pasta de ProgramData nao encontrada.
)
echo.

:: 6- Apaga a chave de Registro "HKEY_LOCAL_MACHINE\SOFTWARE\NIC.br" (ignora se nao existir)
echo [6/9] Apagando chave de Registro (HKLM\SOFTWARE)...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\NIC.br" /f >nul 2>&1
echo      Chave de Registro HKLM\SOFTWARE\NIC.br removida (se existia).
echo.

:: 7- Apaga a chave de Registro "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\NIC.br" (ignora se nao existir)
echo [7/9] Apagando chave de Registro (HKLM\SOFTWARE\WOW6432Node)...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\NIC.br" /f >nul 2>&1
echo      Chave de Registro HKLM\SOFTWARE\WOW6432Node\NIC.br removida (se existia).
echo.

:: 8- Baixa o novo instalador usando o curl (nativo do Windows 10/11)
echo [8/9] Baixando novo instalador de https://download.simet.nic.br/ ...
curl -L "https://download.simet.nic.br/medidor-educ-conectada/MedidorEducacaoConectada.exe" -o "%USERPROFILE%\Downloads\MedidorEducacaoConectada.exe"
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo      ERRO: Falha ao baixar o novo instalador.
    echo      Verifique sua conexao com a internet e tente novamente.
    pause
    exit /b
)
echo      Download concluido para a pasta Downloads.
echo.

:: 9- Executa o novo instalador
echo [9/9] Executando o novo instalador...
echo      A instalacao sera iniciada. Siga as instrucoes na tela.
start "" "%USERPROFILE%\Downloads\MedidorEducacaoConectada.exe"
echo.

:: 10- Fim
echo ====================================================================
echo  Processo concluido!
echo.
echo  O instalador foi iniciado. Se nao aparecer, verifique sua
echo  barra de tarefas ou a pasta Downloads.
echo ====================================================================
echo.
echo Pressione qualquer tecla para fechar esta janela...
pause >nul
ENDLOCAL

