"Filed out from Dolphin Smalltalk"!

GsFatalError subclass: #GsInvalidSessionError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsInvalidSessionError guid: (GUID fromString: '{343d0696-b2fc-405f-9e96-01929dfb6cb6}')!
GsInvalidSessionError comment: ''!
!GsInvalidSessionError categoriesForClass!Unclassified! !
!GsInvalidSessionError methodsFor!

defaultAction

	MessageBox errorMsg: 'Invalid Session!!'.
	self gciSession logout.
	TerminateProcess signal.
!

signal

	self gciSession 
		ifNil: [^self]
		ifNotNil: [:aGciSession | aGciSession beInvalidSession].
	super signal.! !
!GsInvalidSessionError categoriesForMethods!
defaultAction!public! !
signal!public! !
!

!GsInvalidSessionError class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isInvalidSessionInSession: aGciSession.
! !
!GsInvalidSessionError class categoriesForMethods!
wantsToHandle:session:!public! !
!

