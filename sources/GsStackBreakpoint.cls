"Filed out from Dolphin Smalltalk"!

GsEventError subclass: #GsStackBreakpoint
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GsStackBreakpoint guid: (GUID fromString: '{601667a8-f7d5-4fab-97f1-c753a26ebc27}')!

GsStackBreakpoint comment: ''!

!GsStackBreakpoint categoriesForClass!Unclassified! !

!GsStackBreakpoint methodsFor!

isStackBreakpoint

	^true.
! !

!GsStackBreakpoint categoriesForMethods!
isStackBreakpoint!public! !
!

!GsStackBreakpoint class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isStackBreakpointInSession: aGciSession.
! !

!GsStackBreakpoint class categoriesForMethods!
wantsToHandle:session:!public! !
!

