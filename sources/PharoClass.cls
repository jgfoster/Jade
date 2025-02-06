"Filed out from Dolphin Smalltalk"!

Object subclass: #PharoClass
	instanceVariableNames: 'superclassName name instVarNames classVarNames classInstVarNames packageName category comment classMethods instanceMethods parent children'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PharoClass guid: (GUID fromString: '{312fc20f-afd9-4869-b375-9545ee6cae76}')!

PharoClass comment: ''!

!PharoClass categoriesForClass!Unclassified! !

!PharoClass methodsFor!

addChild: aPharoClass

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

name
	^name!

packageName

	^packageName
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

superclassName: newSuperclassName subclass: subclassName instVarNames: newInstVarNames classVarNames: newClassVarNames package: aPackageName

	classMethods := Dictionary new.
	instanceMethods := Dictionary new.
	superclassName := newSuperclassName.
	name := subclassName.
	instVarNames := (newInstVarNames copyFrom: 2 to: newInstVarNames size - 1) subStrings.
	classVarNames := (newClassVarNames copyFrom: 2 to: newClassVarNames size - 1) subStrings.
	classInstVarNames := #().
	category := aPackageName copyFrom: 2 to: aPackageName size - 1.
	packageName := (category subStrings: $-) first.
	children := OrderedCollection new.
!

writeClassTo: aStream

	aStream nextPutAll: '!! ------------------- Class definition for ' , name , '
expectvalue /Class
doit
' , superclassName , ' subclass: ' , name printString , '
  instVarNames: ' , instVarNames printString , '
  classVars: ' , classVarNames printString , '
  classInstVars: ' , classInstVarNames printString , '
  poolDictionaries: #()
  inDictionary: ' , packageName , '
  options: #()
%
expectvalue /Class
doit
' , name , ' comment: ' , (comment ifNil: ['']) printString , '
%
expectvalue /Class
doit
' , name , ' category: ' , category printString , '
%
'.
	children do: [:each | each writeClassTo: aStream].
!

writeMethodsTo: aStream

	classMethods keysAndValuesDo: [:eachKey :eachValue |  
		aStream nextPutAll: 'category: ' , eachKey; lf.
		eachValue do: [:each | 
			aStream 
				nextPutAll: 'classMethod: ' , name; lf; 
				nextPutAll: each trimBlanks; lf;
				nextPut: $%; lf.
		].
	].
	instanceMethods keysAndValuesDo: [:eachKey :eachValue |  
		aStream nextPutAll: 'category: ' , eachKey; lf.
		eachValue do: [:each | 
			aStream 
				nextPutAll: 'method: ' , name; lf; 
				nextPutAll: each trimBlanks; lf;
				nextPut: $%; lf.
		].
	].
	children do: [:each | each writeMethodsTo: aStream].
! !

!PharoClass categoriesForMethods!
addChild:!public! !
classInstVarNames:!public! !
classMethod:category:!public! !
comment:!public! !
instanceMethod:category:!public! !
name!public! !
packageName!public! !
parent!public! !
parent:!public! !
superclassName!public! !
superclassName:subclass:instVarNames:classVarNames:package:!public! !
writeClassTo:!public! !
writeMethodsTo:!public! !
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

