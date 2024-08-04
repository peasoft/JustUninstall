@echo off
cd /d %SystemDrive%\$JustUninstall
color 1f
if %V2% (
    mode con cols=80 lines=30
    echo CreateObject^("Wscript.Shell"^).SendKeys"{F11}">tmp.vbs
    tmp.vbs
) else (
    mode con cols=200 lines=40
)
reg delete HKCU\Console /v AllowAltF4Close /f>nul
reg delete HKCU\Console /v Fullscreen /f>nul
reg delete HKCU\Console /v WindowPosition /f>nul
reg import cons.reg 2>nul
del cons.reg
cls
echo;
echo;
echo         正在卸载 Windows
echo;
echo         你的电脑会重启几次。这可能需要几分钟时间。
echo;
echo         你的电脑将在不久之后重启。
echo;
if %V2% (
echo         %ESC%[48;2;225;225;225m%ESC%[30m 取消 ^(%ESC%[4mC%ESC%[24m^) %ESC%[38;2;255;255;255m%ESC%[44m
) else (
echo         [ 取消 ^(C^) ]
)
:loop1
if not exist run.mark ( exit )
>nul 2>&1 choice /C CN /N /T 1 /D N
if %errorlevel% == 2 ( goto loop1 )
echo;>stop.mark
cls
echo;
echo;
echo         卸载程序正在进行清理，完成之后才会关闭
echo;
echo         这可能需要几分钟时间。
echo;
:loop2
if not exist run.mark ( exit )
timeout /T 1 /nobreak>nul
goto loop2
