﻿"Filed out from Dolphin Smalltalk"!

GsObject subclass: #MCPackageVersion
	instanceVariableNames: 'date time author id ancestors stepChildren message'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MCPackageVersion guid: (GUID fromString: '{75779a06-81a7-42de-8521-65d983f02d77}')!

MCPackageVersion comment: ''!

!MCPackageVersion categoriesForClass!Unclassified! !

!MCPackageVersion methodsFor!

ancestors
	^ancestors!

author
	^author!

date
	^date!

id
	^id!

initialize: aList

	name 			:= name , '.mcz'.
	date 				:= aList at: 3.
	time 				:= aList at: 4.
	author 			:= aList at: 5.
	id 				:= aList at: 6.
	ancestors 		:= (aList at: 7) subStrings: Character tab.
	stepChildren 	:= (aList at: 8) subStrings: Character tab.
	message 		:= ''.
	(aList copyFrom: 9 to: aList size) do: [:each | 
		message notEmpty ifTrue: [message := message , '
'.].
		message := message , each.
	].
!

initialize: aString session: aGciSession

	| list |
	gciSession := aGciSession.
	aString isEmpty ifTrue: [^self].
	list := aString subStrings: Character lf.
	oopType := gciSession oopTypeWithOop: (list at: 1) asNumber.
	name := list at: 2.
	self initialize: list.
!

message
	^message!

stepChildren
	^stepChildren!

time
	^time! !

!MCPackageVersion categoriesForMethods!
ancestors!accessing!public! !
author!accessing!public! !
date!accessing!public! !
id!accessing!public! !
initialize:!public! !
initialize:session:!public! !
message!accessing!public! !
stepChildren!accessing!public! !
time!accessing!public! !
!

