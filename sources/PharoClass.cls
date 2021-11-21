"Filed out from Dolphin Smallalk"!

Object subclass: #PharoClass
	instanceVariableNames: 'superclassName name instVarNames classVarNames classInstVarNames package comment classMethods instanceMethods parent children'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PharoClass guid: (GUID fromString: '{312fc20f-afd9-4869-b375-9545ee6cae76}')!
PharoClass comment: ''!
!PharoClass categoriesForClass!Unclassified! !
!PharoClass methodsFor!

addChild: aPharoClass

	children ifNil: [children := OrderedCollection new].
	children add: aPharoClass.
!

classInstVarNames: aString

	| string |
	string := aString copyFrom: 2 to: aString size - 1.
	classInstVarNames := string subStrings.!

classMethod: sourceString category: categoryString

	(classMethods at: categoryString ifAbsentPut: [OrderedCollection new]) add: sourceString.
!

comment: aString

	comment := aString.

!

instanceMethod: sourceString category: categoryString

	(instanceMethods at: categoryString ifAbsentPut: [OrderedCollection new]) add: sourceString.
!

parent

	^parent
!

parent: aPharoClass

	parent := aPharoClass.
!

superclassName

	^superclassName
!

superclassName: newSuperclassName subclass: subclassName instVarNames: newInstVarNames classVarNames: newClassVarNames package: packageName

	classMethods := Dictionary new.
	instanceMethods := Dictionary new.
	superclassName := newSuperclassName.
	name := subclassName.
	instVarNames := newInstVarNames.
	classVarNames := newClassVarNames.
	package := packageName.
! !
!PharoClass categoriesForMethods!
addChild:!public! !
classInstVarNames:!public! !
classMethod:category:!public! !
comment:!public! !
instanceMethod:category:!public! !
parent!public! !
parent:!public! !
superclassName!public! !
superclassName:subclass:instVarNames:classVarNames:package:!public! !
!

!PharoClass class methodsFor!

superclassName: superclassName subclass: subclassName instVarNames: instVarNames classVarNames: classVarNames package: packageName

	^self basicNew
		superclassName: superclassName subclass: subclassName instVarNames: instVarNames classVarNames: classVarNames package: packageName;
		yourself
! !
!PharoClass class categoriesForMethods!
superclassName:subclass:instVarNames:classVarNames:package:!public! !
!

