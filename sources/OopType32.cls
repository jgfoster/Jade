"Filed out from Dolphin Smalltalk"!

DWORD subclass: #OopType32
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OopType32 guid: (GUID fromString: '{5e753c2a-33e0-438c-8b48-549e19ccc28e}')!
OopType32 comment: ''!
!OopType32 categoriesForClass!Unclassified! !
!OopType32 methodsFor!

is64BitBoolean

	^(self value bitAnd: 16r3F) = 16r0C.
!

is64BitCharacter

	^(self value bitAnd: 16rFFFFC01F) = 16r1C.

!

is64BitSmallInteger

	^(self value bitAnd: 3) = 2.

!

is6xBoolean

	^(self value bitAnd: 16r1F) = 16r06.
!

is6xCharacter

	^(self value bitAnd: (16rFFFFE000 bitOr: 16r1F)) = 16r0E.

!

is6xSmallInteger

	^(self value bitAnd: 3) = 3.

!

isGsNil

	^self  value = 10.
!

isSmallDouble

	^false.
!

printOn: aStream

	aStream nextPutAll: 'Oop(' , self value printString , ')'.
! !
!OopType32 categoriesForMethods!
is64BitBoolean!public! !
is64BitCharacter!public! !
is64BitSmallInteger!public! !
is6xBoolean!public! !
is6xCharacter!public! !
is6xSmallInteger!public! !
isGsNil!public! !
isSmallDouble!public! !
printOn:!public! !
!

!OopType32 class methodsFor!

elementSize

	^4.
! !
!OopType32 class categoriesForMethods!
elementSize!public! !
!

