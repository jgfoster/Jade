﻿"Filed out from Dolphin Smalltalk"!

MCRepository subclass: #MCDictionaryRepository
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MCDictionaryRepository guid: (GUID fromString: '{e3f38d70-6ede-4358-ac87-4309206f17db}')!

MCDictionaryRepository comment: ''!

!MCDictionaryRepository categoriesForClass!Unclassified! !

!MCDictionaryRepository methodsFor!

allVersionInfoNames

	| string list |
	string := gciSession
		serverPerform: #'mcAllVersionNamesInDict:' 
		with: self.
	list := string subStrings: Character lf.
	list := list collect: [:each | each , '.mcz'].
	^list.
!

fullNameOfPackage: packageNameString versionName: versionNameString 

	^packageNameString , '-' , versionNameString.
!

isDefault

	^true.
!

loadPackageNamed: packageName versionName: versionName

	gciSession
		serverPerform: #'mcVersionLoad:fromDictionary:autoMigrate:' 
		with: (gciSession encode: packageName , '-' , (versionName copyFrom: 1 to: versionName size - 4))
		with: self
		with: true.
!

patchFrom: string1 to: string2 

	| string |
	string := gciSession
		serverPerform: #'mcPatchFrom:to:inDictionaryRepository:'
		with: (string1 ifNotNil: [:value | value copyFrom: 1 to: value size - 4])
		with: (string2 ifNotNil: [:value | value copyFrom: 1 to: value size - 4])
		with: self.
	^MCPatch
		fromString: string
		session: gciSession.
!

topazFrom: aString 

	| string |
	string := aString.
	(string endsWith: '.mcz') ifTrue: [string := string copyFrom: 1 to: string size - 4].
	^gciSession
		serverPerform: #'mcTopazFrom:inDictionaryRepository:'
		with: (gciSession encode: string)
		with: self.
!

updateVersionDialogTabIn: aMCVersionDialog

	aMCVersionDialog updateDictionaryTabWith: self.
!

versionInfoFor: aString 

	| string version |
	string := gciSession 
		serverPerform: #mcVersionInfoFromDictionaryPackageNamed:in:
		with: (gciSession encode: aString)
		with: self.
	string isEmpty ifTrue: [^nil].
	string := gciSession decode: string.
	version := MCPackageVersion fromString: string session: gciSession.
	^version!

versionInfoForPackageNamed: aString version: aString2 

	| string version |
	string := aString , '-' , aString2.
	(string endsWith: '.mcz') ifTrue: [string := string copyFrom: 1 to: string size - 4].
	string := gciSession 
		serverPerform: #mcVersionInfoFromDictionaryPackageNamed:in:
		with: (gciSession encode: string)
		with: self.
	string isEmpty ifTrue: [^nil].
	string := gciSession decode: string.
	version := MCPackageVersion fromString: string session: gciSession.
	^version! !

!MCDictionaryRepository categoriesForMethods!
allVersionInfoNames!public! !
fullNameOfPackage:versionName:!public! !
isDefault!public! !
loadPackageNamed:versionName:!public! !
patchFrom:to:!public! !
topazFrom:!public! !
updateVersionDialogTabIn:!public! !
versionInfoFor:!public! !
versionInfoForPackageNamed:version:!public! !
!

