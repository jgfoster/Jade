﻿"Filed out from Dolphin Smalltalk"!

GsObject subclass: #MCVersionInfo
	instanceVariableNames: 'date time author id ancestors stepChildren message'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MCVersionInfo guid: (GUID fromString: '{202a46bc-0a0e-407f-a82d-5ad5b9de8b87}')!

MCVersionInfo comment: ''!

!MCVersionInfo categoriesForClass!Unclassified! !

!MCVersionInfo methodsFor!

gciSession: aGciSession oop: anInteger 

	| string stream |
	gciSession := aGciSession.
	oopType := gciSession oopTypeWithOop: anInteger.
	string := gciSession
		serverPerform: #'mcVersionInfoFrom:' 
		with: oopType.
	stream := ReadStream on: string.
	stream nextLine. "OOP"
	name := stream nextLine.
	date := stream nextLine.
	time := stream nextLine.
	author := stream nextLine.
	id := stream nextLine.
	ancestors := stream nextLine subStrings: Character tab.
	stepChildren := stream nextLine subStrings: Character tab.
	message := stream upToEnd.
!

message
	^message!

timeStamp

	^date , ' ' , time.
! !

!MCVersionInfo categoriesForMethods!
gciSession:oop:!public! !
message!public! !
timeStamp!public! !
!

!MCVersionInfo class methodsFor!

gciSession: aGciSession oop: anInteger 

	^self new
		gciSession: aGciSession 
		oop: anInteger.
! !

!MCVersionInfo class categoriesForMethods!
gciSession:oop:!public! !
!

