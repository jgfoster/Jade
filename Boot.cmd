@ECHO OFF
cd ..
Dolphin7 DPRO.img7 -q -i Jade\JadeDev -d . -x
cd Jade
start ..\Dolphin7 JadeDev.img7 -q -f Boot.st
