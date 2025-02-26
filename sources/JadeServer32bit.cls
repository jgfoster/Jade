﻿"Filed out from Dolphin Smalltalk"!

JadeServer subclass: #JadeServer32bit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

JadeServer32bit guid: (GUID fromString: '{6bd4ac2a-d6a4-438a-9b0b-e050dd50b3a2}')!

JadeServer32bit comment: ''!

!JadeServer32bit categoriesForClass!Unclassified! !

!JadeServer32bit methodsFor!

_asString: anObject

	(anObject isKindOf: String) ifTrue: [^anObject].
	Exception
		category: nil
		number: nil
		do: [:ex :cat :num :args | 
			^'<<#printString error: ' , ex printString , '>>'.
		].
	^super _asString: anObject.
!

_installTranscript

	Exception
		category: nil
		number: nil
		do: [:ex :cat :num :args | ^self].
	super _installTranscript.
!

_mcInitialsA: aString

	(System class includesSelector: #'_cacheName:') ifFalse: [^true].
	Exception
		category: nil
		number: nil
		do: [:ex :cat :num :args | ^false].
	super _mcInitialsA: aString.
	^true.
! !

!JadeServer32bit categoriesForMethods!
_asString:!private!Transcript! !
_installTranscript!private!Transcript! !
_mcInitialsA:!private! !
!

!JadeServer32bit class methodsFor!

gsClassDefinitionStringFor: aClass
	"Some class variables exist only in Dolphin and map to globals in GemStone; others exist only in GemStone and map to globals in Dolphin!!"

	^'class subclass: ''' , aClass name , '''
		instVarNames: ' , aClass instVarNames printString , '
		classVars: #(' , aClass classVarsForGemStone , ')
		classInstVars: #()
		poolDictionaries: (#() class withAll: symbolList)
		inDictionary: SymbolDictionary new
		constraints: #()
		instancesInvariant: false
		isModifiable: false.'
! !

!JadeServer32bit class categoriesForMethods!
gsClassDefinitionStringFor:!public! !
!

