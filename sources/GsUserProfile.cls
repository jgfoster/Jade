﻿"Filed out from Dolphin Smalltalk"!

GsObject subclass: #GsUserProfile
	instanceVariableNames: 'lastLoginTime remainingLogins isDisabled maxSessions language disabledReason lastPasswordChange isSpecial'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GsUserProfile guid: (GUID fromString: '{399e972a-24dd-4e6c-a458-fc8e949470a5}')!

GsUserProfile comment: ''!

!GsUserProfile categoriesForClass!Unclassified! !

!GsUserProfile methodsFor!

disabledReason

	^disabledReason.
!

editGroup: anArray value: aBoolean

	| selector string |
	string := gciSession encode: (anArray at: 2).
	anArray
		at: 3
		put: aBoolean.
	selector := aBoolean
		ifTrue: [#'addGroup:toUser:']
		ifFalse: [#'removeGroup:fromUser:'].
	gciSession
		serverPerform: selector
		with: (gciSession encode: string)
		with: self.
!

editPrivilege: anArray value: aBoolean

	| selector string |
	string := gciSession encode: (anArray at: 2).
	anArray
		at: 3
		put: aBoolean.
	selector := aBoolean
		ifTrue: [#'addPrivilege:toUser:']
		ifFalse: [#'removePrivilege:fromUser:'].
	gciSession
		serverPerform: selector
		with: (gciSession decode: string)
		with: self.
!

groupList
	| string list |
	string := gciSession serverPerform: #groupListFor: with: self.
	list := string subStringsTrimmingTrailingEmptyElement: Character lf.
	list := list collect: [:each | each subStrings: Character tab].
	list := list collect: 
					[:each |
					Array
						with: self
						with: (each at: 1)
						with: (each at: 2) = 'true'].
	^list!

initialize: aList

	| list |
	list := aList collect: [:each | each = 'nil' ifTrue: [nil] ifFalse: [each]].
	list size < 10 ifTrue: [^self].
	lastLoginTime 				:= list at: 3.
	remainingLogins 			:= list at: 4.
	isDisabled 					:= (list at: 5) = 'true'.
	maxSessions 				:= list at: 6.
	language						:= list at: 7.
	disabledReason				:= list at: 8.
	lastPasswordChange 	:= list at: 9.
	isSpecial 						:= (list at: 10) = 'true'.
!

isDisabled

	^isDisabled.
!

isSpecial

	^isSpecial.
!

language

	^language.
!

lastLoginTime

	^lastLoginTime.
!

lastPasswordChange

	^lastPasswordChange.
!

maxSessions

	^maxSessions.
!

privilegeList
	| string list |
	string := gciSession serverPerform: #privilegeListFor: with: self.
	list := string subStringsTrimmingTrailingEmptyElement: Character lf.
	list := list collect: [:each | each subStrings: Character tab].
	list := list collect: 
					[:each |
					Array
						with: self
						with: (each at: 1)
						with: (each at: 2) = 'true'].
	^list!

remainingLogins

	^remainingLogins.
!

symbolList
	| string list |
	string := gciSession serverPerform: #dictionaryListFor: with: self.
	string := gciSession decode: string.
	list := string subStringsTrimmingTrailingEmptyElement: Character lf.
	list := list collect: [:each | GsSymbolDictionary new initialize: each session: gciSession].
	^list! !

!GsUserProfile categoriesForMethods!
disabledReason!public! !
editGroup:value:!public! !
editPrivilege:value:!public! !
groupList!public! !
initialize:!public! !
isDisabled!public! !
isSpecial!public! !
language!public! !
lastLoginTime!public! !
lastPasswordChange!public! !
maxSessions!public! !
privilegeList!public! !
remainingLogins!public! !
symbolList!public! !
!

!GsUserProfile class methodsFor!

allIn: aGciSession
	| string list |
	(string := aGciSession serverPerform: #userList) isNil ifTrue: [^#()].
	list := string subStringsTrimmingTrailingEmptyElement: Character lf.
	list := list collect: [:each | self new initialize: each session: aGciSession].
	^list! !

!GsUserProfile class categoriesForMethods!
allIn:!public! !
!

