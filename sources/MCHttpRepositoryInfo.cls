﻿"Filed out from Dolphin Smalltalk"!

Object subclass: #MCHttpRepositoryInfo
	instanceVariableNames: 'location user password'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MCHttpRepositoryInfo guid: (GUID fromString: '{9297ce93-5e15-48ce-8be4-01aa17099f34}')!

MCHttpRepositoryInfo comment: ''!

!MCHttpRepositoryInfo categoriesForClass!Unclassified! !

!MCHttpRepositoryInfo methodsFor!

initialize

	location		:= 'http://seaside.gemtalksystems.com/ss/'.
	user			:= ''.
	password	:= ''.
!

location
	^location!

location: anObject
	location := anObject!

password
	^password!

password: anObject
	password := anObject!

user
	^user!

user: anObject
	user := anObject! !

!MCHttpRepositoryInfo categoriesForMethods!
initialize!private! !
location!accessing!private! !
location:!accessing!private! !
password!accessing!private! !
password:!accessing!private! !
user!accessing!private! !
user:!accessing!private! !
!

!MCHttpRepositoryInfo class methodsFor!

new

	^super new
		initialize;
		yourself.
! !

!MCHttpRepositoryInfo class categoriesForMethods!
new!public! !
!

