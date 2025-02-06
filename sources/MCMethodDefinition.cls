"Filed out from Dolphin Smalltalk"!

MCDefinition subclass: #MCMethodDefinition
	instanceVariableNames: 'classIsMeta source category selector className timeStamp'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MCMethodDefinition guid: (GUID fromString: '{2fc81943-2846-4631-abf1-f40bd2da0274}')!

MCMethodDefinition comment: ''!

!MCMethodDefinition categoriesForClass!Unclassified! !

!MCMethodDefinition methodsFor!

category
	^category!

classIsMeta
	^classIsMeta!

className

	^className , (classIsMeta ifTrue: [' class'] ifFalse: ['']).
!

detailsString

	^category , ' - ' , timeStamp.
!

displayMemo

	^source.
!

displayText

	^category, ' - ' , timeStamp.
!

initialize: aStream

	| size |
	timeStamp:= aStream upTo: Character tab.
	className := aStream upTo: Character tab.
	classIsMeta := (aStream upTo: Character tab) = 'true'.
	category := aStream upTo: Character tab.
	selector := aStream upTo: Character tab.
	size := (aStream upTo: Character tab) asNumber + 1.
	source := (aStream next: size) copyReplacing: Character cr withObject: Character lf.
!

selector
	^selector!

source
	^source!

timeStamp
	^timeStamp! !

!MCMethodDefinition categoriesForMethods!
category!accessing!public! !
classIsMeta!accessing!public! !
className!accessing!public! !
detailsString!public! !
displayMemo!public! !
displayText!public! !
initialize:!private! !
selector!accessing!public! !
source!accessing!public! !
timeStamp!accessing!public! !
!

