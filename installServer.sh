echo "This will reload your GciLibrary WebApp code."
echo "Make sure you have saved all your edits!"
read -n 1 -s -r -p "Press any key to continue"
echo ""

cd WebGS
topaz -ilq << EOF
iferr 1 stk
iferr 2 output pop
iferr 3 stk
iferr 4 abort
iferr 5 logout
iferr 6 exit
errorCount
output push WebGS.out only
errorCount
fileformat utf8

! configure for Unicode
set user SystemUser pass swordfish gems gs64stone
login
send CharacterCollection enableUnicodeComparisonMode
commit
logout

set user DataCurator pass swordfish gems gs64stone
login
input WebGS.gs
errorCount
output pop
errorCount
commit
logout
EOF
echo "Topaz exit status = $?\n"
cd ../gemstone
topaz -ilq << EOF
iferr 1 stk
iferr 2 output pop
iferr 3 stk
iferr 4 abort
iferr 5 logout
iferr 6 exit
errorCount
output push GciApp.out only
errorCount
fileformat utf8

set user DataCurator pass swordfish gems gs64stone
login
input GciApp.gs
send GciTsLibraryFull initializeFunctions
output pop
errorCount
commit
logout

! run application
login
iferr 1 stk
iferr 2 exit
send GciLibraryApp run: 50378
EOF
