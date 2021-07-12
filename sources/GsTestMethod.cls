"Filed out from Dolphin Smallalk"!

Object subclass: #GsTestMethod
	instanceVariableNames: 'className methodName result'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsTestMethod guid: (GUID fromString: '{49ac780a-e100-43d1-812c-5132b52980ab}')!
GsTestMethod comment: ''!
!GsTestMethod categoriesForClass!Unclassified! !
!GsTestMethod methodsFor!

className
	^className!

className: anObject
	className := anObject!

icon

	result ifNil: [^self class icon].

	(result = 'passed') ifTrue: [^True icon].
	(result = 'failure') ifTrue: [^Warning icon].
	(result = 'error') ifTrue: [^False icon].

	^self class icon

	!

methodName
	^methodName!

methodName: anObject
	methodName := anObject!

result
	^result!

result: anObject
	result := anObject!

setError

	result := 'error'

	!

setFailure

	result := 'failure'!

setPassed

	result := 'passed'
	! !
!GsTestMethod categoriesForMethods!
className!accessing!private! !
className:!accessing!private! !
icon!public! !
methodName!accessing!private! !
methodName:!accessing!private! !
result!accessing!private! !
result:!accessing!private! !
setError!public! !
setFailure!public! !
setPassed!public! !
!

!GsTestMethod class methodsFor!

icon
	"Answers an <Icon> that can be used to represent this class"

	^Icon fromId: 'COMInterface.ico'!

name: aString

	^super new initialize
		methodName: aString;
		yourself!

newOn: className methodName: methodName

	^super new initialize
		className: className;
		methodName: methodName;
		yourself! !
!GsTestMethod class categoriesForMethods!
icon!public! !
name:!public! !
newOn:methodName:!public! !
!

