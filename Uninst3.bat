>script.txt echo select volume=%1
>>script.txt echo clean
>>script.txt echo create partition primary
>>script.txt echo format recommended quick
diskpart /s script.txt
