﻿"Filed out from Dolphin Smalltalk"!

GsEventError subclass: #GsClientForwarderSend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GsClientForwarderSend guid: (GUID fromString: '{12ab69fe-6b24-4cb4-8cfc-7782a7b028c7}')!

GsClientForwarderSend comment: '
System 
	_signalGciError: 2336
    args:#[ 
		1, "aClientForwarder"
		2 "receiver" , 
	    3 "selector" , 
        #() "arguments to selector" ,
		0 "number of arguments" ]
    signalDictionary: GemStoneError.
'!

!GsClientForwarderSend categoriesForClass!Unclassified! !

!GsClientForwarderSend methodsFor!

signal

	self gatherData.
	^tag clientForwardError: gciErrSType.
! !

!GsClientForwarderSend categoriesForMethods!
signal!public! !
!

!GsClientForwarderSend class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isClientForwarderSendInSession: aGciSession.
! !

!GsClientForwarderSend class categoriesForMethods!
wantsToHandle:session:!public! !
!

