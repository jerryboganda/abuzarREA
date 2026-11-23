@echo off
rem One compile cycle: import the objects whose source changed, then a full rebuild that records every compiler message.
rem   build_cycle.cmd <folder with abuzar.pbt, ws_objects and the PBLs> <cycle number>
rem Outputs <folder>\import-<n>.json(l), <folder>\rebuild-<n>.json(l), <folder>\cycle-<n>.done
set F=%~1
set N=%~2
del "%F%\cycle-%N%.done" 2>nul
C:\Tools\py32\python.exe -I C:\Projects\Abuzar\re-tools\orca_build.py importeach "%F%\abuzar.pbt" "%F%\import-%N%.json" "%F%\ws_objects" > "%F%\import-%N%.out" 2>&1
C:\Tools\py32\python.exe -I C:\Projects\Abuzar\re-tools\orca_build.py rebuild "%F%\abuzar.pbt" "%F%\rebuild-%N%.json" full > "%F%\rebuild-%N%.out" 2>&1
echo done > "%F%\cycle-%N%.done"
