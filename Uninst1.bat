pushd %1:\
set DIRS=$JustUninstall $SysReset $WINDOWS.~BT $WINRE_BACKUP_PARTITION.MARKER Perflogs "Program Files" "Program Files (x86)" "Program Files (Arm)" Recovery Windows
>nul del /F /S /A /Q %DIRS% hiberfil.sys
>nul rd /S /Q "Documents and Settings" %DIRS%
attrib -H ProgramData
popd
