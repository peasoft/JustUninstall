for /f "tokens=3,*" %%a in ('vol %1:') do (
    set label=%%b
    goto got
)
:got
>script.txt echo select volume=%1
>>script.txt echo format label="%label%" quick override
diskpart /s script.txt
