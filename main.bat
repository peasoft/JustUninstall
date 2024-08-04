@echo off
setlocal ENABLEDELAYEDEXPANSION

>nul 2>&1 "%WINDIR%\system32\cacls.exe" "%WINDIR%\system32\config\system"
if errorlevel 1 (
    start mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~0","",,"runas",1)(close)"
    exit /B
)

cd /d %~dp0

for /f "tokens=6,7 delims=[]. " %%a in ('ver') do (
    set build=%%a
    set build2=%%b
)
:: Conhost v2 �Ǵ� Windows 10 1511 ��ʼ�е�
if %build% geq 10586 (
    set V2=1==1
    for /f "skip=1 tokens=3" %%a in ('reg query HKCU\Console /v ForceV2') do (
        if "%%a"=="0x0" ( set V2=0==1 )
    )
) else (
    set V2=1==0
)
set V2Re=%V2%

if exist %tmp%\jucons.reg (
    reg delete HKCU\Console /v WindowPosition /f>nul
    reg import %tmp%\jucons.reg 2>nul
    del %tmp%\jucons.reg
    goto main
)

reg export HKCU\Console %tmp%\jucons.reg>nul
reg import newcons.reg 2>nul
if not %V2% ( reg add HKCU\Console /v FaceName /t REG_SZ /d __DefaultTTFont__ /f>nul )

mshta vbscript:CreateObject("Scripting.FileSystemObject").CreateTextFile("%tmp%\getres.bat",true).Write("set W="^&screen.Width^&"&set H="^&screen.Height)(close)
call %tmp%\getres.bat
del %tmp%\getres.bat

if %V2% (
    for /f "tokens=3" %%a in ('reg query "HKCU\Control Panel\Desktop\WindowMetrics" /v AppliedDPI') do ( set DPI=%%a )
) else ( set DPI=96 )
set /a X=W/2-384*DPI/96
if %X% lss 0 ( set X=0 )
set /a Y=H/2-310*DPI/96
if %Y% lss 0 ( set Y=0 )
set /a POS=X+65536*Y
reg add HKCU\Console /v WindowPosition /t REG_DWORD /d %POS% /f >nul 2>&1
start "" cmd /c %0
exit /B

:main
mode con cols=80 lines=30
if %V2% ( color f0 ) else ( color 1f )
title Just Uninstall by @peasoft

for /f %%a in ('echo prompt $E ^| cmd') do set ESC=%%a

where wmic >nul 2>&1
if errorlevel 1 (
    if %build% geq 21996 (
        set OSVER=Windows 11
    ) else if %build% geq 10240 (
        set OSVER=Windows 10
    ) else if %build% geq 9600 (
        set OSVER=Windows 8.1
    ) else if %build% geq 9200 (
        set OSVER=Windows 8
    ) else if %build% geq 7600 (
        set OSVER=Windows 7
    ) else if %build% geq 6000 (
        set OSVER=Windows Vista
    ) else if %build% geq 3663 (
        set OSVER=Windows Longhorn
    ) else if %build% geq 2600 (
        set OSVER=Windows Server 2003
    ) else if %build% geq 2465 (
        set OSVER=Windows XP
    ) else if %build% geq 2242 (
        set OSVER=Windows Whistler
    ) else (
        set OSVER=Windows NT 3.x/4.x/5.x
    )
) else (
    for /f "skip=1 delims=" %%a in ('wmic os get Caption') do ( set OSVER=%%a && goto gotos)
    :gotos
    set OSVER=!OSVER:Microsoft =!
)


set CH1=�����ļ��͸�������
set CH2=��������ϵͳ�����е��ļ�
set CH3=�������ļ�

:menu
cls
echo;
call :ptitle ѡ��Ҫ����������
echo;
echo     ѡ��һ��ѡ�
echo;
if %V2% (
echo       %ESC%[4m1%ESC%[24m. %CH1%
) else (
echo       1. %CH1%
)
echo          ɾ��ϵͳ��Ӧ�ã������������ļ������á�
echo;
if %V2% (
echo       %ESC%[4m2%ESC%[24m. %CH2%
) else (
echo       2. %CH2%
)
echo          ɾ��ϵͳ���ڷ����������ļ��������������̷����е��ļ�����Ӱ�졣
echo;
if %V2% (
echo       %ESC%[4m3%ESC%[24m. %CH3%
) else (
echo       3. %CH3%
)
echo          ɾ�����豸�ϴ洢���κ����ݣ�ͬʱҲ��������豸�ϰ�װ����������ϵͳ��
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
choice /C 123 /M "�ȴ�����"
set CH=%errorlevel%

:confirm
cls
echo;
call :ptitle ׼������������ж��
echo     ��ж�ع������㽫�޷�ʹ�õ��ԡ����ڿ�ʼж��֮ǰ�����沢�ر�����ļ���
echo;
echo     ��������������ѡ��
echo;
echo      * ж�� %OSVER%
echo      * !CH%CH%!
if %V2% (
echo        %ESC%[36m����Ҫ���������� ^(%ESC%[4mC%ESC%[24m^)%ESC%[30m
) else (
echo        [ ����Ҫ���������� ^(C^) ]
)
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
if %V2% (
echo                                                              %ESC%[48;2;225;225;225m ж�� ^(%ESC%[4mU%ESC%[24m^) %ESC%[48;2;255;255;255m
) else (
echo                                                             [ ж�� ^(U^) ]
)
echo;
echo;
choice /C CU /M "�ȴ�����"
if %errorlevel% neq 2 ( goto menu )

:makere
cls
echo;
call :ptitle ����ж�� Windows
echo;
bcdedit>nul 2>&1
if errorlevel 1 (
    set ERROR=�޷����� BCD
    goto error
)
set ROOTDIR=%SystemDrive%\$JustUninstall
rd /s /q %ROOTDIR%>nul 2>&1
mkdir %ROOTDIR%
attrib +H %ROOTDIR%
cd /d %ROOTDIR%
copy %~dp0newcons.reg>nul
copy %~dp0Uninst*.bat>nul
copy %~dp0UninstUI.bat>nul
copy %~dp0PreUninstUI.bat>nul
call :startui

if exist %SystemDrive%\Recovery (
    for /f %%a in ('dir /a /b %SystemDrive%\Recovery') do (
        if exist %SystemDrive%\Recovery\%%a\Winre.wim (
            set ReDrive=%SystemDrive%
            set ReName=%%a
            goto ReFound
        )
    )
)
chcp 437
echo select volume=%SystemDrive%>script.txt
echo list partition>>script.txt
for /f "skip=10 tokens=2,3" %%a in ('diskpart /s script.txt') do (
    if "%%b"=="Recovery" (
        set par=%%a
        goto gotRePar
    )
)
chcp 936
goto downRe
:gotRePar
chcp 936
for %%a in (A B Z Y X W V U T S R Q P O N M L K J I H G F E D C) do (
    if not exist %%a:\ (
        set ReDrive=%%a:
        goto gotReDrive
    )
)
set ERROR=û�пɷ�����̷�
goto clean
:gotReDrive
>script.txt echo select volume=%SystemDrive%
>>script.txt echo select partition=%par%
>>script.txt echo assign letter=%ReDrive%
diskpart /s script.txt
if exist %ReDrive%\Recovery (
    for /f %%a in ('dir /a /b %ReDrive%\Recovery') do (
        if exist %ReDrive%\Recovery\%%a\Winre.wim (
            set ReName=%%a
            goto ReFound
        )
    )
)

:downRe
if %build% lss 9600 ( goto noRe )
if %build% == 9600 (
    if %build2% lss 16610 ( goto noRe )
)
if defined PROCESSOR_ARCHITEW6432 ( set ARCH=%PROCESSOR_ARCHITEW6432% ) else ( set ARCH=%PROCESSOR_ARCHITECTURE% )
if %ARCH% == AMD64 (
    set DOWNID=c71c7e40-40b6-471b-adf1-2ee9f2beba34
) else if %ARCH% == ARM64 (
    set DOWNID=721acb5d-7965-4ced-ae39-a26daf71d11d
) else if %ARCH% == x86 (
    set DOWNID=e811c5d0-1df3-4c57-b992-479f1de7f73a
) else (
    set ERROR=�޷����� Windows �ָ���������֧�ֵ� CPU �ܹ�
    goto clean
)

cls
echo;
call :ptitle ���� Windows �ָ�����
echo;
echo     ж�س�����Ҫ�������ش�СԼ 600 MB �����ݲ��ܼ�����
echo;
echo     Ҫ������
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
if %V2% (
echo                                                    %ESC%[48;2;225;225;225m �� ^(%ESC%[4mY%ESC%[24m^) %ESC%[48;2;255;255;255m    %ESC%[48;2;225;225;225m �� ^(%ESC%[4mN%ESC%[24m^) %ESC%[48;2;255;255;255m
) else (
echo                                                 [ �� ^(Y^) ]    [ �� ^(N^) ]
)
echo;
echo;
del run.mark
choice /C YN /M "�ȴ�����"
if %errorlevel% neq 1 (
    set ERROR=�������û�ȡ��
    goto clean
)
call :startui

cls
echo;
call :ptitle ����ж�� Windows
echo;
call :down "https://www.uupdump.cn/get.php?id=%DOWNID%&pack=zh-cn&edition=professional&aria2=2" down.txt
call :down "https://www.uupdump.cn/public/autodl_files/files20240217/aria2c.exe" aria2c.exe
if exist stop.mark (
    set ERROR=�������û�ȡ��
    goto clean
)
for /f "tokens=1,2 delims=" %%a in (down.txt) do (
    set msg=%%a
    if "!msg:~0,4!" == "http" (
        set url="%%a"
    ) else if "!msg!" == "  out=professional_zh-cn.esd" (
        goto goturl
    )
)
set ERROR=�޷����� Windows �ָ�������δ�ҵ���ַ
goto clean
:goturl
aria2c --no-conf --log-level=info -x16 -s16 -j5 -c -R -o inst.esd %url%
if exist stop.mark (
    set ERROR=�������û�ȡ��
    goto clean
)
Dism /Export-Image /SourceImageFile:inst.esd /SourceIndex:2 /DestinationImageFile:Uninst.wim /Compress:Max /CheckIntegrity
del inst.esd
set V2Re=0==0
if exist Uninst.wim ( goto gotwim )
set ERROR=�޷����� Windows �ָ���������֧�ֵ�ϵͳ
goto clean

:ReFound
xcopy /H %ReDrive%\Recovery\%ReName%\Winre.wim
if not %ReDrive% == %SystemDrive% (
    >script.txt echo select volume=%ReDrive%
    >>script.txt echo remove letter=%ReDrive%
    diskpart /s script.txt
)
attrib -R -S -H Winre.wim
ren Winre.wim Uninst.wim
:gotwim
mkdir NewOS
if exist stop.mark (
    set ERROR=�������û�ȡ��
    goto clean
)
Dism /Mount-Wim /WimFile:Uninst.wim /Index:1 /MountDir:NewOS
copy NewOS\Windows\Boot\DVD\PCAT\boot.sdi
takeown /F NewOS\sources /R /D Y>nul
icacls NewOS\sources /grant:R Everyone:F /T /Q>nul
rd /s /q NewOS\sources
mkdir NewOS\sources
del /f NewOS\setup.exe
set FILES=winpeshl.ini *html* *edge* jscript* Update* cloud* wu* wlan* *wifi* *ProxyStub* *network* *web* *Codec* *audio* *d3d* dx* appx* wer* one*
pushd NewOS\Windows\System32
for %%a in (%FILES%) do (
    takeown /F %%a >nul
    icacls %%a /grant:R Everyone:F /Q>nul
    del /f /a %%a
)
popd
pushd NewOS\Windows\SysWOW64
for %%a in (%FILES%) do (
    takeown /F %%a >nul
    icacls %%a /grant:R Everyone:F /Q>nul
    del /f /a %%a
)
popd
echo @call %%SystemDrive%%\sources\Uninst.bat>NewOS\Windows\System32\startnet.cmd
copy newcons.reg NewOS\sources
copy Uninst.bat+Uninst%CH%.bat NewOS\sources\Uninst.bat
copy UninstUI.bat NewOS\sources
if %V2Re% (
    copy %WINDIR%\Fonts\simhei.ttf NewOS\Windows\Fonts
    reg load HKLM\Uninst NewOS\Windows\System32\config\SOFTWARE
    reg add "HKLM\Uninst\Microsoft\Windows NT\CurrentVersion\Fonts" /v "SimHei (TrueType)" /t REG_SZ /d simhei.ttf /f
    reg unload HKLM\Uninst
)
if exist stop.mark (
    Dism /Unmount-Wim /MountDir:NewOS /Discard
    set ERROR=�������û�ȡ��
    goto clean
)
Dism /Unmount-Wim /MountDir:NewOS /Commit
if exist stop.mark (
    set ERROR=�������û�ȡ��
    goto clean
)
echo;>UNINSTALL.MARK
set GUID={f7d706b0-3db5-11ef-a120-db6d9c7afd5b}
set GUID2={f7d706b0-3db5-11ef-a120-db6d9c7afd5c}
bcdedit /delete %GUID2% /cleanup
bcdedit /delete %GUID% /cleanup
bcdedit /create %GUID2% /d "Just Uninstall" /device
bcdedit /create %GUID% /d "Just Uninstall" /application osloader
bcdedit /set %GUID2% ramdisksdidevice partition=%SystemDrive%
bcdedit /set %GUID2% ramdisksdipath \$JustUninstall\boot.sdi
bcdedit /set %GUID% device ramdisk=[%SystemDrive%]\$JustUninstall\Uninst.wim,%GUID2%
bcdedit /set %GUID% osdevice ramdisk=[%SystemDrive%]\$JustUninstall\Uninst.wim,%GUID2%
for /f "skip=4 tokens=1,2" %%a in ('bcdedit /enum {current}') do (
    if "%%a"=="path" (
        bcdedit /set %GUID% path %%b
        goto bcd2
    )
)
:bcd2
bcdedit /set %GUID% systemroot \Windows
bcdedit /set %GUID% nx OptIn
bcdedit /set %GUID% pae ForceEnable
bcdedit /set %GUID% detecthal yes
bcdedit /set %GUID% winpe yes
bcdedit /bootsequence %GUID%
bcdedit /delete {current} /cleanup
shutdown /r /f /t 0
exit /B

:noRe
set ERROR=δ�ҵ� Windows �ָ�����

:clean
cls
echo;
call :ptitle ж�س������ڽ�������
rd /s /q NewOS
del /s /q *
cd ..
rd /s /q %ROOTDIR%

:error
cls
echo;
call :ptitle Windows ж��ʧ��
echo;
echo     ��������ԭ��ж�س����޷�������
echo;
echo;    %ERROR%
echo;
echo     ��������˳�...
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
echo;
pause>nul
exit

:ptitle
if %V2% (
    echo     %ESC%[36m%*%ESC%[30m
) else (
    echo     %*
)
exit /B

:down
:: Certutil ����֤�����ʱ�ᱨ�������������ļ��������ġ�
del %2 2>nul
for /l %%a in (1,1,5) do (
    certutil -urlcache -split -f %1 %2
    if exist %2 ( exit /B )
)
set ERROR=�ļ�����ʧ��
goto clean
exit /B

:startui
echo;>run.mark
reg export HKCU\Console cons.reg >nul
reg import newcons.reg 2>nul
if not %V2% ( reg add HKCU\Console /v FaceName /t REG_SZ /d __DefaultTTFont__ /f>nul )
reg add HKCU\Console /v AllowAltF4Close /t REG_DWORD /d 0 /f>nul
reg add HKCU\Console /v CtrlKeyShortcutsDisabled /t REG_DWORD /d 0 /f>nul
reg add HKCU\Console /v Fullscreen /t REG_DWORD /d 1 /f>nul
reg add HKCU\Console /v WindowPosition /t REG_DWORD /d 0 /f>nul
start "" cmd /c PreUninstUI.bat
timeout /T 1 /nobreak>nul
exit /B