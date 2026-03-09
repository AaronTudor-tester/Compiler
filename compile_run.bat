@echo off
REM Script para compilar y ejecutar el compilador

setlocal enabledelayedexpansion

set JAVAC=javac
set JAVA=java
set SRC_DIR=src
set BUILD_DIR=build\classes
set CP=%BUILD_DIR%;lib\JavaCUP\*;lib\JFlex\*

echo ===== Compilando Java =====
REM Primero compilar las clases base sin dependencias
%JAVAC% -cp "lib\JavaCUP\*;lib\JFlex\*" -d %BUILD_DIR% -encoding UTF-8 %SRC_DIR%\compiler\sintactic\ErroresSemanticos.java
REM Luego compilar todo junto con el classpath actualizado
%JAVAC% -cp "%CP%" -d %BUILD_DIR% -encoding UTF-8 %SRC_DIR%\compiler\sintactic\*.java %SRC_DIR%\compiler\sintactic\Symbols\*.java %SRC_DIR%\compiler\codigo_intermedio\*.java %SRC_DIR%\compiler\codigo_ensamblador\*.java %SRC_DIR%\compiler\lexic\*.java %SRC_DIR%\lenguaje\*.java

if errorlevel 1 (
    echo Error en compilacion
    exit /b 1
)

echo.
echo ===== Ejecutando compilador =====
%JAVA% -cp "%CP%" lenguaje.LenguajeNatural %1

echo.
echo ===== Completado =====
