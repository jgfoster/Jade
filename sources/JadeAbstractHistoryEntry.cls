﻿"Filed out from Dolphin Smalltalk"!

Object subclass: #JadeAbstractHistoryEntry
	instanceVariableNames: 'methodName className classCategory'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

JadeAbstractHistoryEntry guid: (GUID fromString: '{bee97cde-c39a-4f05-8286-df3a70c0fbf6}')!

JadeAbstractHistoryEntry comment: ''!

!JadeAbstractHistoryEntry categoriesForClass!Unclassified! !

!JadeAbstractHistoryEntry methodsFor!

classCategory
	^classCategory
!

classCategory: anObject
	classCategory := anObject
!

className
	^className
!

className: anObject
	className := anObject
!

getClassName
	"<className> is anArray with all hierarchy names"

	(className isKindOf: String) ifTrue: [^className].

	(className isNil or: [className isEmpty]) ifTrue: [^''].

	^className last
!

getMethodName
	"<methodName> is anArray with different GemStone values"

	(methodName isKindOf: String) ifTrue: [^methodName].

	(methodName isNil or: [methodName isEmpty]) ifTrue: [^''].

	^methodName first!

hasAllValues

	^self hasMethodName and: [self hasClassName] !

hasClassName
	"<className> is anArray with all hierarchy names"

	^self getClassName notEmpty!

hasMethodName

	^self getMethodName notEmpty
	!

methodName
	^methodName
!

methodName: anObject
	methodName := anObject!

printOn: target


	target nextPutAll: ('aHistoryEntry ', self getClassName, '>>', self getMethodName)! !

!JadeAbstractHistoryEntry categoriesForMethods!
classCategory!accessing!private! !
classCategory:!accessing!private! !
className!accessing!private! !
className:!accessing!private! !
getClassName!public! !
getMethodName!public! !
hasAllValues!public! !
hasClassName!public! !
hasMethodName!public! !
methodName!accessing!private! !
methodName:!accessing!private! !
printOn:!public! !
!

!JadeAbstractHistoryEntry class methodsFor!

newFrom: aJadeAutoSystemBrowserPresenter

	^super new initialize
		populateFrom: aJadeAutoSystemBrowserPresenter;
		yourself! !

!JadeAbstractHistoryEntry class categoriesForMethods!
newFrom:!public! !
!

