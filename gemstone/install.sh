echo "This will reload your GciLibrary WebApp code."
echo "Make sure you have saved all your edits!"
read -n 1 -s -r -p "Press any key to continue"
echo ""
topaz -lq << EOF
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

! set stone name
set gems gs64stone

! configure for Unicode
set user SystemUser pass swordfish
login
send CharacterCollection enableUnicodeComparisonMode
commit
logout

! install GciLibraryApp
set user DataCurator pass swordfish
login

input ./GciApp.gs
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
