﻿"Filed out from Dolphin Smalltalk"!

GsObject subclass: #MCWorkingCopy
	instanceVariableNames: 'isModified ancestors repositories'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MCWorkingCopy guid: (GUID fromString: '{d388c1a7-ecc0-4fd6-b7ce-78433225bfa9}')!

MCWorkingCopy comment: ''!

!MCWorkingCopy categoriesForClass!Unclassified! !

!MCWorkingCopy methodsFor!

addRepository: aRepository

	gciSession
		serverPerform: #'mcAddRepository:toPackage:' 
		with: aRepository
		with: self.
	self repositories add: aRepository.
!

ancestors

	ancestors := ancestors collect: [:each | self mcVersionInfoFrom: each].
	^ancestors.
!

authorInitials: aString

	gciSession
		serverPerform: #'authorInitials:'
		with: aString.
!

globals

	^#().
!

initialize: aList

	| stream |
	stream := ReadStream on: aList.
	stream next; next.
	isModified := stream next = 'true'.
	ancestors := Array new: stream next asNumber.
	1 to: ancestors size do: [:i | 
		ancestors 
			at: i
			put: stream next asNumber.
	].
	repositories := Array new: stream next asNumber.
	1 to: repositories size do: [:i | 
		repositories 
			at: i
			put: stream next asNumber.
	].
!

isModified
	^isModified!

mcRepositoryFrom: anObject

	(anObject isKindOf: MCRepository) ifTrue: [^anObject].
	^MCRepository
		gciSession: gciSession
		oop: anObject.
!

mcVersionInfoFrom: anObject

	(anObject isKindOf: MCVersionInfo) ifTrue: [^anObject].
	^MCVersionInfo
		gciSession: gciSession
		oop: anObject.
!

newVersionWithName: nameString message: messageString

	| string |
	string := gciSession
		serverPerform: #'mcNewVersionWithNname:message:'
		with: self
		with: nameString 
		with: messageString.
	MessageBox notify: 'Sorry, we have not yet implemented this feature!!'.
	SessionManager current pause.
!

removeRepository: aRepository 

	gciSession
		serverPerform: #'mcRemoveRepository:fromPackage:' 
		with: aRepository
		with: self.
	self repositories remove: aRepository.
!

repositories

	repositories := repositories asOrderedCollection collect: [:each | self mcRepositoryFrom: each].
	^repositories.
!

uniqueVersionName

	^gciSession
		serverPerform: #'mcUniqueVersionNameFor:'
		with: self.
!

versionNameAndMessage

	| string list |
	string := gciSession
		serverPerform: #'mcVersionNameAndMessageFrom:' 
		with: self.
	string := gciSession decode: string.
	list := string subStrings: Character tab.
	^list first -> list last.
! !

!MCWorkingCopy categoriesForMethods!
addRepository:!public! !
ancestors!public! !
authorInitials:!public! !
globals!public! !
initialize:!public! !
isModified!public! !
mcRepositoryFrom:!public! !
mcVersionInfoFrom:!public! !
newVersionWithName:message:!public! !
removeRepository:!public! !
repositories!public! !
uniqueVersionName!public! !
versionNameAndMessage!public! !
!

