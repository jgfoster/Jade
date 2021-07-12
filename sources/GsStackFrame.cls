"Filed out from Dolphin Smallalk"!

GsObject subclass: #GsStackFrame
	instanceVariableNames: 'ipOffset frameOffset gsMethod stepPoint vars offsets breaks source'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsStackFrame guid: (GUID fromString: '{06285ec9-259c-47b7-980f-c6eca7ced95e}')!
GsStackFrame comment: ''!
!GsStackFrame categoriesForClass!Unclassified! !
!GsStackFrame methodsFor!

breaks

	^breaks.
!

frameOffset
	^frameOffset!

frameOffset: anObject
	frameOffset := anObject!

gsMethod

	^gsMethod
!

initialize: xmlNode

	self error: 'use #initializeXML:'.
!

initializeXML: xmlNode

	| string stream |
	super initializeXML: xmlNode.
	ipOffset := (xmlNode getAttribute: 'ipOffset') asNumber.
	frameOffset := (xmlNode getAttribute: 'frameOffset') asNumber.
	stepPoint := (xmlNode getAttribute: 'stepPoint') asNumber.
	vars := OrderedCollection new.
	(xmlNode getElementsByTagName: 'var') do: [:each | 
		vars add: (each getAttribute: 'oop') -> (each getAttribute: 'name')  -> each text.
	].
	string := (xmlNode getElementsByTagName: 'source') first text.
	stream := JadeServerReadStream on: string.
	gsMethod := GsMethod
		fromStream: stream
		session: gciSession.
	source := gsMethod source.
	offsets := gsMethod stepPoints collect: [:each | each key start].
	breaks := gsMethod breakPoints.
!

ipOffset
	^ipOffset!

ipOffset: anObject
	ipOffset := anObject!

offsets
	^offsets!

source
	^source!

source: anObject
	source := anObject!

stepPoint
	^stepPoint!

stepPoint: anObject
	stepPoint := anObject!

vars
	^vars!

vars: anObject
	vars := anObject! !
!GsStackFrame categoriesForMethods!
breaks!public! !
frameOffset!accessing!private! !
frameOffset:!accessing!private! !
gsMethod!accessing!public! !
initialize:!public! !
initializeXML:!public! !
ipOffset!accessing!private! !
ipOffset:!accessing!private! !
offsets!accessing!private! !
source!accessing!private! !
source:!accessing!private! !
stepPoint!accessing!private! !
stepPoint:!accessing!private! !
vars!accessing!private! !
vars:!accessing!private! !
!

!GsStackFrame class methodsFor!

xmlBaseName

	^'frame'.
! !
!GsStackFrame class categoriesForMethods!
xmlBaseName!public! !
!

