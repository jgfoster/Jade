﻿"Filed out from Dolphin Smalltalk"!

GsError subclass: #GsCompileError
	instanceVariableNames: 'list'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GsCompileError guid: (GUID fromString: '{e49be376-e1af-4368-a429-b691f6e547ca}')!

GsCompileError comment: ''!

!GsCompileError categoriesForClass!Unclassified! !

!GsCompileError methodsFor!

gatherData

	super gatherData.
	list := self class 
		errorListFor: gciErrSType args first 
		inSession: self gciSession.
!

list

	^list.
! !

!GsCompileError categoriesForMethods!
gatherData!public! !
list!public! !
!

!GsCompileError class methodsFor!

errorListFor: anOop inSession: aGciSession
 
	| result list |
	result := aGciSession
		serverPerform: #'errorListFor:'
		with: anOop.
	result := aGciSession decode: result.
	list := result subStrings: Character lf.
	list := list collect: [:each | each , '	' subStrings: Character tab].
	list := list collect: [:each | 
		Array
			with: (each at: 1) asNumber
			with: (each at: 2) asNumber
			with: (each at: 3).
	].
	^list.
!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isCompileErrorInSession: aGciSession.
! !

!GsCompileError class categoriesForMethods!
errorListFor:inSession:!public! !
wantsToHandle:session:!public! !
!

