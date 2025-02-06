"Filed out from Dolphin Smalltalk"!

GsAnsiError subclass: #GsTestFailure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GsTestFailure guid: (GUID fromString: '{bd39ca74-6d0f-4a45-a5ed-2acf574ab10f}')!

GsTestFailure comment: ''!

!GsTestFailure categoriesForClass!Unclassified! !

!GsTestFailure class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType message = 'aTestFailure signal: ''Assertion failed'''.
! !

!GsTestFailure class categoriesForMethods!
wantsToHandle:session:!public! !
!

