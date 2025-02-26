﻿"Filed out from Dolphin Smalltalk"!

ExternalArray subclass: #OopType64Array
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

OopType64Array guid: (GUID fromString: '{729f7c08-e907-4b03-a8fa-562774423bba}')!

OopType64Array comment: ''!

!OopType64Array categoriesForClass!Unclassified! !

!OopType64Array methodsFor!

elementClass

	^OopType64.
!

size: anInteger

	bytes := bytes copyFrom: 1 to: self class elementSize * anInteger.
!

uncheckedAt: index 

	^OopType64 fromInteger: (bytes qwordAtOffset: (index - 1) * 8)!

uncheckedAt: index  put: anOopType64

	bytes 
		qwordAtOffset: (index - 1) * 8
		put: anOopType64 value.

! !

!OopType64Array categoriesForMethods!
elementClass!constants!public! !
size:!public! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!OopType64Array class methodsFor!

elementSize

	^8.
!

fromBytes: aByteArray

	^(self new: aByteArray size / self elementSize)
		bytes: aByteArray;
		yourself.
! !

!OopType64Array class categoriesForMethods!
elementSize!instance creation!private! !
fromBytes:!public! !
!

