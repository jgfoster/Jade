"Filed out from Dolphin Smalltalk"!

GsError subclass: #GsFatalError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsFatalError guid: (GUID fromString: '{71eabb54-3a5a-4ca2-bca3-44b39d453586}')!
GsFatalError comment: ''!
!GsFatalError categoriesForClass!Unclassified! !
!GsFatalError methodsFor!

defaultAction

	MessageBox 
		errorMsg: gciErrSType message
		caption: 'Fatal GemStone Error'.
	self gciSession beInvalidSession.
	TerminateProcess signal.
! !
!GsFatalError categoriesForMethods!
defaultAction!public! !
!

!GsFatalError class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType number // 1000 = 4.
! !
!GsFatalError class categoriesForMethods!
wantsToHandle:session:!public! !
!

