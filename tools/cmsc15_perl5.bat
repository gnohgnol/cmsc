@echo off
@setlocal
rem
rem Copyright (c) 2011 The MyoMake Project <http://www.myomake.org>
rem
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem
rem     http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.
rem
rem Dowloads Strawberry Perl
rem
rem Prerequisites...
set "PATH=%~dp0;%PATH%"
rem
set PVER=5.14.2.1-32bit
if exist strawberry-perl-%PVER%.zip goto HasPerlDist
wget http://strawberry-perl.googlecode.com/files/strawberry-perl-%PVER%.zip
rem
if exist strawberry-perl-%PVER%.zip goto HasPerlDist
echo.
echo Failed to download strawberry-perl-%PVER%.zip
exit /B 1
:HasPerlDist
echo Perl   : %PVER%  >>compile.log
pushd ..
rem Remove previous stuff
rm -rf perl c 2>NUL
rm -f relocation.pl.bat 2>NUL
rm -f strawberry-merge-module.reloc.txt 2>NUL
rem Uncopress
7za x tools\strawberry-perl-%PVER%.zip perl c relocation.pl.bat strawberry-merge-module.reloc.txt
copy /Y perl\bin\perl.exe perl\bin\perlw.exe 2>NUL
xcopy c\bin\*.dll perl\bin /I /Y /Q
rm -rf c 2>NUL
if not "%~1" == "/i" goto PrepareDone
call relocation.pl.bat
rm -f relocation.pl.bat 2>NUL
rm -f strawberry-merge-module.reloc.txt 2>NUL
:PrepareDone
popd
echo.
echo Finished.
:End