"Filed out from Dolphin Smallalk"!

GsObject subclass: #GsMethod2
	instanceVariableNames: 'gsClass category isTestCase'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsMethod2 guid: (GUID fromString: '{d21971c6-fa84-4d7b-a684-d1de5b9f0519}')!
GsMethod2 comment: ''!
!GsMethod2 categoriesForClass!Unclassified! !
!GsMethod2 methodsFor!

<= aGsMethod

	"self classCategory ~= aGsMethod classCategory ifTrue: [^self classCategory <= aGsMethod classCategory].
	self gsClass name ~= aGsMethod gsClass name ifTrue: [^self gsClass name ~= aGsMethod gsClass name].
	self category ~= aGsMethod category ifTrue: [^self category <= aGsMethod category]."
	^self name <= aGsMethod name.
!

asUpdatedVersion: stringOop
	"Answer <aGsMethod2> of the new method based on the receiver."
	| stringToGetNewMethod |

	stringToGetNewMethod := stringOop, Character tab asString, 
						name, Character tab asString, 
						category, Character tab asString, 
						gsClass oopType lowPart printString, Character tab asString, 
						gsClass name, Character tab asString, 
						gsClass category, Character tab asString, 
						gsClass dictionary , Character tab asString,
						isTestCase printString.

	^GsMethod2 fromString: stringToGetNewMethod session: gciSession.
!

category
	^category!

classCategory

	^gsClass category.
!

clearBreakAtStepPoint: anInteger

	gciSession
		send: #'clearBreakAtStepPoint:'
		to: oopType	
		with: anInteger.
!

gsClass
	^gsClass!

initialize: aList 
	"See JadeServer>>_addMethod:toStream:"

	| string |
	category := aList at: 3.
	string := (aList at: 4) , Character tab asString , (aList at: 5) , Character tab asString , (aList at: 6) , Character tab asString , (aList at: 7).
	gsClass := GsClass 
		fromString: string 
		session: gciSession.
	isTestCase := (aList at: 8) = 'true'.
!

isTestCase

	^isTestCase.
!

printOn: aStream

	gsClass printOn: aStream.
	aStream nextPutAll: '>>'.
	super printOn: aStream.
!

setBreakAtStepPoint: anInteger

	gciSession
		send: #'setBreakAtStepPoint:'
		to: oopType	
		with: anInteger.
! !
!GsMethod2 categoriesForMethods!
<=!public! !
asUpdatedVersion:!public! !
category!public! !
classCategory!public! !
clearBreakAtStepPoint:!Breakpoints!public! !
gsClass!public! !
initialize:!public! !
isTestCase!public! !
printOn:!public! !
setBreakAtStepPoint:!Breakpoints!public! !
!

