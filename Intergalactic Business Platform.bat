@echo off
setlocal EnableDelayedExpansion

rem Set the size of the Sensor view (adjust as needed)
set rows=10
set cols=20

rem Set initial SpatialMap state
set "UniverseSector="

rem Initialize Resources list
set "ResourcesList="

rem Function to initialize the SpatialMap grid
:initialize
for /l %%i in (1,1,%rows%) do (
    set "row="
    for /l %%j in (1,1,%cols%) do (
        set /a "rand=!random! %% 2"
        if !rand! equ 0 (
            set "row=!row!O"
        ) else (
            set "row=!row!X"
        )
    )
    set "UniverseSector=!UniverseSector!!row!"
)
goto :start

:start
cls
echo Corporate Alliance System - Sensor View

rem Print Sensor view
for /l %%i in (0,1,%rows%) do (
    set "row=!UniverseSector:~%%i*%cols%,%cols%!"
    echo !row!
)

rem Track SpatialMap evolution (replace this with your own SpatialMap of distance rules)
set "newState="
for /l %%i in (0,1,%rows%) do (
    set "row=!UniverseSector:~%%i*%cols%,%cols%!"
    set "newRow="
    for /l %%j in (0,1,%cols%) do (
        set /a "neighbors=0"
        for %%k in (-1,0,1) do (
            for %%l in (-1,0,1) do (
                if %%k neq 0 if %%l neq 0 (
                    set /a "rowIndex=%%i+%%k"
                    set /a "colIndex=%%j+%%l"
                    if !rowIndex! geq 0 if !rowIndex! lss %rows% if !colIndex! geq 0 if !colIndex! lss %cols% (
                        set "neighbor=!UniverseSector:~!rowIndex!*%cols%+!colIndex!,1!"
                        if "!neighbor!" neq "-" set /a "neighbors+=1"
                    )
                )
            )
        )
        set "cell=!row:~%%j,1!"
        if "!cell!"=="O" (
            if !neighbors! leq 1 set "newRow=!newRow!-"
            if !neighbors! gtr 3 set "newRow=!newRow!-"
            if !neighbors! equ 2 if !neighbors! equ 3 set "newRow=!newRow!O"
        ) else if "!cell!"=="X" (
            if !neighbors! leq 1 set "newRow=!newRow!-"
            if !neighbors! gtr 3 set "newRow=!newRow!-"
            if !neighbors! equ 2 if !neighbors! equ 3 set "newRow=!newRow!X"
        ) else (
            if !neighbors! equ 3 (
                if "!cell!"=="O" set "newRow=!newRow!O"
                if "!cell!"=="X" set "newRow=!newRow!X"
            ) else (
                set "newRow=!newRow!-"
            )
        )
    )
    set "newState=!newState!!newRow!"
)
set "UniverseSector=!newState!"

rem Count the number of Operators and calculate Killss
set "teamAOperators=0"
set "teamBOperators=0"
set "teamAKills=0"
set "teamBKills=0"
for /l %%i in (0,1,%rows%) do (
    set "row=!UniverseSector:~%%i*%cols%,%cols%!"
    for /l %%j in (0,1,%cols%) do (
        set "cell=!row:~%%j,1!"
        if "!cell!"=="O" (
            set /a "teamAOperators+=1"
            set /a "teamAKills+=1"
        ) else if "!cell!"=="X" (
            set /a "teamBOperators+=1"
            set /a "teamBKills+=1"
        )
    )
)
set "ResourcesList=Corporate Alliance A: RTSBOTS=%teamAOperators% Operators=%teamAOperators%, Kills=%teamAKills%, Corporate Alliance B: RTSBOTS=%teamBOperators% Operators=%teamBOperators%, Kills=%teamBKills%"


rem Display Resources list
echo.
echo Resources:
echo %ResourcesList%

timeout /t 1 >nul
goto :start
