@echo off
cd /d %~dp0
mode con cols=160 lines=40
echo CreateObject("Wscript.Shell").SendKeys"{F11}">tmp.vbs
tmp.vbs
echo;
echo     ����ж�� Windows
echo;
echo     �벻Ҫ�ػ���������豸��
echo WScript.sleep 1000>tmp.vbs
:loop
if exist done.mark ( goto end )
tmp.vbs
goto loop
:end
cls
echo;
echo     Windows ж�����
echo;
echo     ��л��ʹ�� Microsoft Windows �Լ� Just Uninstall by @peasoft��
echo;
echo     �ټ���
echo;
echo     ��������ػ�...
pause>nul
wpeutil Shutdown
