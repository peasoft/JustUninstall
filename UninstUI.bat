@echo off
cd /d %~dp0
mode con cols=160 lines=40
echo CreateObject("Wscript.Shell").SendKeys"{F11}">tmp.vbs
tmp.vbs
echo;
echo     正在卸载 Windows
echo;
echo     请不要关机或操作此设备。
echo WScript.sleep 1000>tmp.vbs
:loop
if exist done.mark ( goto end )
tmp.vbs
goto loop
:end
cls
echo;
echo     Windows 卸载完成
echo;
echo     感谢您使用 Microsoft Windows 以及 Just Uninstall by @peasoft。
echo;
echo     再见。
echo;
echo     按任意键关机...
pause>nul
wpeutil Shutdown
