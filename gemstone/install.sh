echo "This will reload your GciLibrary WebApp code."
echo "Make sure you have saved all your edits!"
read -n 1 -s -r -p "Press any key to continue"
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
input ./GciApp.gs
output pop
errorCount
commit
logout
set user SystemUser pass swordfish
login
send CharacterCollection enableUnicodeComparisonMode
commit
logout
set user DataCurator pass swordfish
login
iferr 1 stk
iferr 2 exit
send GciLibraryApp run
EOF
