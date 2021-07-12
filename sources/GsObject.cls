"Filed out from Dolphin Smallalk"!

Object subclass: #GsObject
	instanceVariableNames: 'gciSession name oopType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsObject guid: (GUID fromString: '{86a78fbd-348d-46b8-9a1b-e4c91d698eeb}')!
GsObject comment: ''!
!GsObject categoriesForClass!Unclassified! !
!GsObject methodsFor!

<= aGsObject2

	^self name <= aGsObject2 name.
!

= aGsObject2

	^self class = aGsObject2 class and: [self oopType = aGsObject2 oopType].
!

finalize

	oopType ifNotNil: [
		gciSession releaseOop: oopType.
	].
!

gciSession

	^gciSession.
!

gciSession: aGciSession

	gciSession := aGciSession.
!

hash

	^oopType hash.
!

initialize: aList
	"override if you have something beyond OOP and name"!

initialize: aString session: aGciSession

	| list |
	gciSession := aGciSession.
	list := aString subStrings: Character tab.
	oopType := gciSession oopTypeWithOop: (list at: 1) asNumber.
	name := list at: 2.
	self initialize: list.
!

initializeXML: xmlElement 

	name := xmlElement getAttribute: 'name'.
!

isGsNil

	^oopType isGsNil.
!

name

	^name.
!

oopType

	^oopType.

!

oopType: anOopType

	(anOopType isKindOf: ExternalInteger) ifFalse: [self error: 'Expected an OopType but got ' , anOopType printString].
	oopType := anOopType.
!

printOn: aStream

	name isNil ifTrue: [^super printOn: aStream].
	aStream nextPutAll: name.
! !
!GsObject categoriesForMethods!
<=!public! !
=!public! !
finalize!public! !
gciSession!public! !
gciSession:!public! !
hash!public! !
initialize:!public! !
initialize:session:!public! !
initializeXML:!public! !
isGsNil!public! !
name!public! !
oopType!public! !
oopType:!public! !
printOn:!public! !
!

!GsObject class methodsFor!

fromStream: aStream session: aGciSession

	^self new 
		initialize: aStream session:  aGciSession;
		yourself

!

fromString: aString session: aGciSession

	^self new 
		initialize: aString session:  aGciSession;
		yourself
!

fromStringXML: aString session: gciSession

	[
		| xmlElement |
		xmlElement := (IXMLDOMDocument new loadText: aString) documentElement.
		xmlElement baseName = self xmlBaseName ifFalse: [self error: ''].
		^self fromXML: xmlElement session: gciSession.
	] on: DOMParseError do: [:ex | 
		MessageBox notify: ex description.
		SessionManager current pause.
		SessionManager current logError: ex.
		^nil
	].
!

fromXML: xmlElement session: gciSession 

	^self new
		gciSession: gciSession;
		initializeXML: xmlElement; 
		yourself.
!

listFromString: aString session: aGciSession
	| list |
	list := aString subStringsTrimmingTrailingEmptyElement: Character lf.
	list := list collect: [:each | self fromString: each session: aGciSession].
	^list!

new

	^self basicNew
		beFinalizable;
		yourself!

xmlBaseName

	^self subclassResponsibility.
! !
!GsObject class categoriesForMethods!
fromStream:session:!public! !
fromString:session:!public! !
fromStringXML:session:!public! !
fromXML:session:!public! !
listFromString:session:!public! !
new!public! !
xmlBaseName!public! !
!

