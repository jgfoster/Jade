﻿"Filed out from Dolphin Smalltalk"!

TestResource subclass: #GciLibraryTestResource
	instanceVariableNames: 'library session'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GciLibraryTestResource guid: (GUID fromString: '{689b0a0e-e39a-43ab-ae67-060af181bb24}')!

GciLibraryTestResource comment: ''!

!GciLibraryTestResource categoriesForClass!Unclassified! !

!GciLibraryTestResource methodsFor!

libraryClass

	^self subclassResponsibility
!

session

	^session!

setUp
	super setUp.
	library := self libraryClass default.
	session ifNil: [
		session := library 
			loginUser: 'DataCurator'
			password: 'swordfish'
			gemNRS: '!!@portugal#netldi:ldijfoster1#task!!gemnetobject'
			stoneNRS: 'jfoster1'.
	]!

tearDown

	session ifNotNil: [
		library logoutSession: session.
		session := nil.
	].
	super tearDown.
! !

!GciLibraryTestResource categoriesForMethods!
libraryClass!private! !
session!accessing!public! !
setUp!private! !
tearDown!private! !
!

