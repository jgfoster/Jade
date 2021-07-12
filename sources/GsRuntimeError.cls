"Filed out from Dolphin Smallalk"!

GsError subclass: #GsRuntimeError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsRuntimeError guid: (GUID fromString: '{a3b64446-755d-4647-9cca-2354531dc693}')!
GsRuntimeError comment: ''!
!GsRuntimeError categoriesForClass!Unclassified! !
!GsRuntimeError methodsFor!

isResumableInGem

	^true.
! !
!GsRuntimeError categoriesForMethods!
isResumableInGem!public! !
!

!GsRuntimeError class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isRuntimeErrorInSession: aGciSession.
! !
!GsRuntimeError class categoriesForMethods!
wantsToHandle:session:!public! !
!

