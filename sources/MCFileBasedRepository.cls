"Filed out from Dolphin Smallalk"!

MCRepository subclass: #MCFileBasedRepository
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MCFileBasedRepository guid: (GUID fromString: '{02ab65a3-7933-4ff3-a1c8-7960c4414821}')!
MCFileBasedRepository comment: ''!
!MCFileBasedRepository categoriesForClass!Unclassified! !
!MCFileBasedRepository methodsFor!

allVersionInfoNames

	| string list |
	string := gciSession
		serverPerform: #'mcAllFileNamesIn:' 
		with: self.
	list := string subStrings: Character lf.
	^list.
!

fullNameOfPackage: packageNameString versionName: versionNameString 

	^packageNameString , '-' , versionNameString.
!

loadPackageNamed: packageName versionName: versionName

	gciSession
		serverPerform: #'mcVersionLoad:fromFile:autoMigrate:' 
		with: (gciSession encode: (self fullNameOfPackage: packageName versionName: versionName))
		with: self
		with: true.
!

patchFrom: string1 to: string2 

	| string |
	string := gciSession
		serverPerform: #'mcPatchFrom:to:inFileBasedRepository:'
		with: string1
		with: string2
		with: self.
	^MCPatch
		fromString: string
		session: gciSession.
!

topazFrom: aString 

	^gciSession
		serverPerform: #'mcTopazFrom:inFileRepository:'
		with: (gciSession encode: aString)
		with: self.
!

versionInfoForPackageNamed: packageName version: versionName 

	^self versionInfoForPackageNamed: packageName , '-' , versionName.
! !
!MCFileBasedRepository categoriesForMethods!
allVersionInfoNames!public! !
fullNameOfPackage:versionName:!public! !
loadPackageNamed:versionName:!public! !
patchFrom:to:!public! !
topazFrom:!public! !
versionInfoForPackageNamed:version:!public! !
!

