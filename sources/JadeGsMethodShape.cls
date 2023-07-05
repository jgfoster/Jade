"Filed out from Dolphin Smalltalk"!

Object subclass: #JadeGsMethodShape
	instanceVariableNames: 'ownerClass methodName source replacementSource isInstanceMethod packageName applied'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeGsMethodShape guid: (GUID fromString: '{1aa1fb1a-ff88-4de6-ba91-71450fbb3ec6}')!
JadeGsMethodShape comment: ''!
!JadeGsMethodShape categoriesForClass!Unclassified! !
!JadeGsMethodShape methodsFor!

applied
	^applied!

applied: anObject
	applied := anObject!

apply

	applied := true.!

beClassMethod

	isInstanceMethod := false!

initialize

	super initialize.

	isInstanceMethod := true.
	applied := false.!

isInstanceMethod
	^isInstanceMethod!

isInstanceMethod: anObject
	isInstanceMethod := anObject!

methodName
	^methodName!

methodName: anObject
	methodName := anObject!

ownerClass
	^ownerClass!

ownerClass: anObject
	ownerClass := anObject!

packageName
	^packageName!

packageName: anObject
	packageName := anObject!

printClass

	^isInstanceMethod ifTrue: [ownerClass] ifFalse: [ownerClass , ' class']!

printOn: target

	super printOn: target.

	target nextPutAll: '(', self printClass, '>>', methodName, ')'!

replacementSource
	^replacementSource!

replacementSource: anObject
	replacementSource := anObject!

source
	^source!

source: anObject
	source := anObject! !
!JadeGsMethodShape categoriesForMethods!
applied!accessing!private! !
applied:!accessing!private! !
apply!public! !
beClassMethod!public! !
initialize!public! !
isInstanceMethod!accessing!private! !
isInstanceMethod:!accessing!private! !
methodName!accessing!private! !
methodName:!accessing!private! !
ownerClass!accessing!private! !
ownerClass:!accessing!private! !
packageName!accessing!private! !
packageName:!accessing!private! !
printClass!public! !
printOn:!public! !
replacementSource!accessing!private! !
replacementSource:!accessing!private! !
source!accessing!private! !
source:!accessing!private! !
!

!JadeGsMethodShape class methodsFor!

newFor: className methodName: methodName source: source

	^super new initialize
		ownerClass: className;
		methodName: methodName;
		source: source;
		yourself! !
!JadeGsMethodShape class categoriesForMethods!
newFor:methodName:source:!public! !
!

