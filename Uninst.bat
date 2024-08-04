@echo off
echo 请稍候，请勿关闭当前窗口
cd /d %~dp0
reg import newcons.reg 2>nul
reg add HKCU\Console /v AllowAltF4Close /t REG_DWORD /d 0 /f>nul
reg add HKCU\Console /v CtrlKeyShortcutsDisabled /t REG_DWORD /d 0 /f>nul
reg add HKCU\Console /v Fullscreen /t REG_DWORD /d 1 /f>nul
reg add HKCU\Console /v WindowPosition /t REG_DWORD /d 0 /f>nul
start "" /Max cmd /c UninstUI.bat
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
bcdedit /delete {f7d706b0-3db5-11ef-a120-db6d9c7afd5b} /cleanup
bcdedit /delete {f7d706b0-3db5-11ef-a120-db6d9c7afd5c} /cleanup
for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z A B) do (
    if exist %%a:\$JustUninstall\UNINSTALL.MARK (
        call :uninstall %%a
        goto end
    )
)
:end
echo;>done.mark
echo 按任意键关机...
pause>nul
wpeutil Shutdown
exit /B
:uninstall
