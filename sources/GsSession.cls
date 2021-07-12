"Filed out from Dolphin Smallalk"!

GsObject subclass: #GsSession
	instanceVariableNames: 'backlog cacheDesc description hasOldestCR host hostId id ip lifeTime objects pages primitive priority process quietTime serial state transaction viewAge voteState'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsSession guid: (GUID fromString: '{15f90553-cccf-4f17-bf73-85dc91c7f6d0}')!
GsSession comment: ''!
!GsSession categoriesForClass!Unclassified! !
!GsSession methodsFor!

backlog

	^backlog!

cacheDesc

	^cacheDesc!

description

	^description!

hasOldestCR
	^hasOldestCR!

host
	^host!

hostId

	^hostId!

id
	^id!

initialize: xmlElement 

	self error: 'use #initializeXML:'.
!

initializeXML: xmlElement 

	| value |
	super initializeXML: xmlElement.
	(value := xmlElement getAttribute: 'backlog'		) notNil ifTrue: [backlog 		:= value = '' ifTrue: [nil] ifFalse: [value asNumber]].
	(value := xmlElement getAttribute: 'cacheDesc'		) notNil ifTrue: [cacheDesc		:= value = '' ifTrue: [nil] ifFalse: [value]].
	(value := xmlElement getAttribute: 'description'		) notNil ifTrue: [description  	:= value].
	(value := xmlElement getAttribute: 'hasOldestCR'	) notNil ifTrue: [hasOldestCR 	:= value].
	(value := xmlElement getAttribute: 'host'			) notNil ifTrue: [host 		:= value].
	(value := xmlElement getAttribute: 'hostId'			) notNil ifTrue: [hostId		:= value = '' ifTrue: [nil] ifFalse: [value asNumber]].
	(value := xmlElement getAttribute: 'id'			) notNil ifTrue: [id 			:= value asNumber].
	(value := xmlElement getAttribute: 'ip'			) notNil ifTrue: [ip 			:= value].
	(value := xmlElement getAttribute: 'lifeTime'		) notNil ifTrue: [lifeTime 		:= value = '' ifTrue: [nil] ifFalse: [value asNumber]].
	(value := xmlElement getAttribute: 'objects'		) notNil ifTrue: [objects  		:= value = '' ifTrue: [nil] ifFalse: [value asNumber]].
	(value := xmlElement getAttribute: 'pages'			) notNil ifTrue: [pages  		:= value = '' ifTrue: [nil] ifFalse: [value asNumber]].
	(value := xmlElement getAttribute: 'primitive'		) notNil ifTrue: [primitive 		:= value. self updatePrimitive].
	(value := xmlElement getAttribute: 'priority'		) notNil ifTrue: [priority 		:= value = '' ifTrue: [nil] ifFalse: [value asNumber]].
	(value := xmlElement getAttribute: 'process'		) notNil ifTrue: [process 		:= value asNumber].
	(value := xmlElement getAttribute: 'quietTime'		) notNil ifTrue: [quietTime 	:= value = '' ifTrue: [nil] ifFalse: [value asNumber]].
	(value := xmlElement getAttribute: 'serial'			) notNil ifTrue: [serial 		:= value asNumber].
	(value := xmlElement getAttribute: 'state'			) notNil ifTrue: [state 		:= value asNumber].
	(value := xmlElement getAttribute: 'transaction'		) notNil ifTrue: [transaction	:= value asNumber].
	(value := xmlElement getAttribute: 'viewAge'		) notNil ifTrue: [viewAge 		:= value asNumber].
	(value := xmlElement getAttribute: 'voteState'		) notNil ifTrue: [voteState 	:= value = '' ifTrue: [nil] ifFalse: [value asNumber]].
!

ip
	^ip!

lifeTime

	^self stringFromSeconds: lifeTime!

objects

	^objects!

pages

	^pages!

primitive
	^primitive!

priority
	^priority!

process
	^process!

quietTime

	^self stringFromSeconds: quietTime!

sendSigAbort

	gciSession 
		serverPerform: #'sendSigAbortToSession:'
		with: id.
!

sendSigUsr1

	gciSession 
		serverPerform: #'sendSigUsr1ToSession:'
		with: id.
!

serial
	^serial!

state
	^state!

stopSession

	gciSession 
		serverPerform: #'stopSession:'
		with: id.
!

stringFromSeconds: anInteger

	| x |
	(x := anInteger) ifNil: [^''].
	x < 120 ifTrue: [^x printString , ' secs'].
	(x := x // 60) < 120 ifTrue: [^x printString , ' mins'].
	(x := x // 60) < 48 ifTrue: [^x printString , ' hrs'].
	x := x // 24.
	^x printString , ' days'.
!

transaction
	^transaction!

updatePrimitive

	primitive = '431' ifTrue: [primitive := 'MFC'].
!

viewAge

	^self stringFromSeconds: viewAge!

voteState
	^voteState! !
!GsSession categoriesForMethods!
backlog!accessing!public! !
cacheDesc!accessing!public! !
description!accessing!public! !
hasOldestCR!accessing!public! !
host!accessing!public! !
hostId!accessing!public! !
id!accessing!public! !
initialize:!public! !
initializeXML:!private! !
ip!accessing!public! !
lifeTime!accessing!public! !
objects!accessing!public! !
pages!accessing!public! !
primitive!accessing!public! !
priority!accessing!public! !
process!accessing!public! !
quietTime!accessing!public! !
sendSigAbort!accessing!public! !
sendSigUsr1!accessing!public! !
serial!accessing!public! !
state!accessing!public! !
stopSession!accessing!public! !
stringFromSeconds:!accessing!public! !
transaction!accessing!public! !
updatePrimitive!public! !
viewAge!accessing!public! !
voteState!accessing!public! !
!

!GsSession class methodsFor!

fromXML: xmlElement session: gciSession

	| list |
	list := xmlElement getElementsByTagName: 'session'.
	list := list collect: [:each | 
		super
			fromXML: each 
			session: gciSession.
	].
	^list.
!

xmlBaseName

	^'sessions'.
! !
!GsSession class categoriesForMethods!
fromXML:session:!public! !
xmlBaseName!public! !
!

