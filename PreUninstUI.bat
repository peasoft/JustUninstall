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
echo         ����ж�� Windows
echo;
echo         ��ĵ��Ի��������Ρ��������Ҫ������ʱ�䡣
echo;
echo         ��ĵ��Խ��ڲ���֮��������
echo;
if %V2% (
echo         %ESC%[48;2;225;225;225m%ESC%[30m ȡ�� ^(%ESC%[4mC%ESC%[24m^) %ESC%[38;2;255;255;255m%ESC%[44m
) else (
echo         [ ȡ�� ^(C^) ]
)
:loop1
if not exist run.mark ( exit )
>nul 2>&1 choice /C CN /N /T 1 /D N
if %errorlevel% == 2 ( goto loop1 )
echo;>stop.mark
cls
echo;
echo;
echo         ж�س������ڽ����������֮��Ż�ر�
echo;
echo         �������Ҫ������ʱ�䡣
echo;
:loop2
if not exist run.mark ( exit )
timeout /T 1 /nobreak>nul
goto loop2
