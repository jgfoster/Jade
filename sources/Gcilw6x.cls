"Filed out from Dolphin Smallalk"!

GciSingleThreadedLibrary subclass: #Gcilw6x
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Gcilw6x guid: (GUID fromString: '{903182ee-3a32-4868-8468-77731d1b2fd5}')!
Gcilw6x comment: ''!
!Gcilw6x categoriesForClass!Unclassified! !
!Gcilw6x methodsFor!

errorStructureClass

	^GciErrSType32.
!

gciClearStack: anOopType

	<cdecl: void GciClearStack OopType32>
	^self invalidCall: _failureCode
!

gciContinueWith: process _: replaceTopOfStack _: flags _: error

	<cdecl: void GciContinueWith OopType32 OopType32 sdword GciErrSType32*>
	^self invalidCall: _failureCode
!

gciErr: errorReport

	<cdecl: bool GciErr GciErrSType32*>
	^self invalidCall: _failureCode

!

gciExecuteStrFromContext: string _: context _: symbolList

	<cdecl: OopType32 GciExecuteStrFromContext lpstr OopType32 OopType32>
	^self invalidCall: _failureCode
!

gciFetchBytes: anOopType _: startIndex _: cString _: maxSize

	<cdecl: sdword GciFetchBytes OopType32 sdword lpvoid dword>
	^self invalidCall: _failureCode
!

gciFetchChars: anOopType _: startIndex _: cString _: maxSize

	<cdecl: sdword GciFetchChars OopType32 sdword lpstr dword>
	^self invalidCall: _failureCode
!

gciFetchClass: oop

	<cdecl: OopType32 GciFetchClass OopType32>
	^self invalidCall: _failureCode
!

gciFetchObjImpl: anObject

	<cdecl: sdword GciFetchObjImpl OopType32>
	^self invalidCall: _failureCode
!

gciFetchSize: anObject

	<cdecl: sdword GciFetchSize OopType32>
	^self invalidCall: _failureCode
!

gciFetchVaryingOops: anObject _: startIndex _: theOops _: numOops

	<cdecl: sdword GciFetchVaryingOops OopType32 sdword OopType32Array* sdword>
	^self invalidCall: _failureCode
!

gciLongToOop: anInteger

	<cdecl: OopType32 GciLongToOop sdword>
	^self invalidCall: _failureCode
!

gciNbContinueWith: process _: replaceTopOfStack _: flags _: error

	<cdecl: void GciNbContinueWith OopType32 OopType32 sdword GciErrSType32*>
	^self invalidCall: _failureCode
!

gciNbExecuteStrFromContext: string _: context _: symbolList

	<cdecl: OopType32 GciNbExecuteStrFromContext lpstr OopType32 OopType32>
	^self invalidCall: _failureCode
!

gciNbPerform: receiver _: selector _: args _: numArgs

	<cdecl: void GciNbPerform OopType32 lpstr OopType32* dword>
	^self invalidCall: _failureCode
!

gciNewString: aString

	<cdecl: OopType32 GciNewString lpstr >
	^self invalidCall: _failureCode
!

gciOopToChr: anObject

	<cdecl: sdword GciOopToChr OopType32>
	^self invalidCall: _failureCode
!

gciPerform: receiver _: selector _: args _: numArgs

	<cdecl: void GciPerform OopType32 lpstr OopType32* dword>
	^self invalidCall: _failureCode
!

gciReleaseOops: args _: numArgs

	<cdecl: void GciReleaseOops OopType32* dword>
	^self invalidCall: _failureCode
!

gciResolveSymbol: aString _: symbolList

	<cdecl: OopType32 GciResolveSymbol lpstr OopType32>
	^self invalidCall: _failureCode
!

oopAsciiNul

	^OopType32 fromInteger: 14.!

oopAt: anExternalAddress

	^OopType32 fromInteger: (anExternalAddress sdwordAtOffset: 0).
!

oopClassArray

	^OopType32 fromInteger: 1045.
!

oopClassByteArray

	^OopType32 fromInteger: 1617.!

oopClassDoubleByteString

	^OopType32 fromInteger: 0.!

oopClassQuadByteString

	^OopType32 fromInteger: 0.!

oopClassString

	^OopType32 fromInteger: 1169.!

oopClassSymbol

	^OopType32 fromInteger: 1733.
!

oopClassSystem

	^OopType32 fromInteger: 1189.!

oopClassUnicode16

	^OopType32 fromInteger: 0.!

oopClassUnicode32

	^OopType32 fromInteger: 0.!

oopClassUnicode7

	^OopType32 fromInteger: 0.!

oopFalse

	^OopType32 fromInteger: 6.!

oopForInteger: anInteger

	| int bytes |
	bytes := ByteArray new: 4.
	bytes 
		dwordAtOffset: 0 
		put: anInteger.
	int := bytes sdwordAtOffset: 0.
	^self gciLongToOop: int.
!

oopGemStoneError

	^OopType32 fromInteger: 3613.!

oopIllegal

	^OopType32 fromInteger: 1.!

oopMaxSmallInteger

	^OopType32 fromInteger: 16r7FFFFFFF.!

oopMinSmallInteger

	^OopType32 fromInteger: -16r7FFFFFFF.!

oopMinusOne

	^OopType32 fromInteger: -1.!

oopNil

	^OopType32 fromInteger: 10.	"0xA"!

oopOne

	^OopType32 fromInteger: 7.!

oopRemoteNil

	^OopType32 fromInteger: 42.!

oopTrue

	^OopType32 fromInteger: 38.!

oopTwo

	^OopType32 fromInteger: 11.!

oopTypeArrayClass

	^OopType32Array.!

oopTypeClass

	^OopType32.!

oopTypeWithOop: anInteger

	| int bytes |
	bytes := ByteArray new: 4.
	bytes 
		dwordAtOffset: 0 
		put: anInteger.
	int := bytes sdwordAtOffset: 0.
	^OopType32 fromInteger: int.
!

oopZero

	^OopType32 fromInteger: 3.!

specialFromOop: anOop

	anOop is6xBoolean ifTrue: [
		^anOop = self oopTrue.
	].
	anOop is6xCharacter ifTrue: [
		^Character value: (self gciOopToChr: anOop).
	].
	anOop is6xSmallInteger ifTrue: [
		^anOop value // 4.
	].
	^nil.
! !
!Gcilw6x categoriesForMethods!
errorStructureClass!private! !
gciClearStack:!private! !
gciContinueWith:_:_:_:!private! !
gciErr:!private! !
gciExecuteStrFromContext:_:_:!private! !
gciFetchBytes:_:_:_:!private! !
gciFetchChars:_:_:_:!private! !
gciFetchClass:!private! !
gciFetchObjImpl:!private! !
gciFetchSize:!private! !
gciFetchVaryingOops:_:_:_:!private! !
gciLongToOop:!private! !
gciNbContinueWith:_:_:_:!private! !
gciNbExecuteStrFromContext:_:_:!private! !
gciNbPerform:_:_:_:!private! !
gciNewString:!private! !
gciOopToChr:!private! !
gciPerform:_:_:_:!private! !
gciReleaseOops:_:!private! !
gciResolveSymbol:_:!private! !
oopAsciiNul!public!Reserved OOPs! !
oopAt:!public! !
oopClassArray!public! !
oopClassByteArray!public! !
oopClassDoubleByteString!public! !
oopClassQuadByteString!public! !
oopClassString!public!Reserved OOPs! !
oopClassSymbol!public! !
oopClassSystem!public!Reserved OOPs! !
oopClassUnicode16!public! !
oopClassUnicode32!public! !
oopClassUnicode7!public! !
oopFalse!public!Reserved OOPs! !
oopForInteger:!public! !
oopGemStoneError!public!Reserved OOPs! !
oopIllegal!public!Reserved OOPs! !
oopMaxSmallInteger!public!Reserved OOPs! !
oopMinSmallInteger!public!Reserved OOPs! !
oopMinusOne!public!Reserved OOPs! !
oopNil!public!Reserved OOPs! !
oopOne!public!Reserved OOPs! !
oopRemoteNil!public!Reserved OOPs! !
oopTrue!public!Reserved OOPs! !
oopTwo!public!Reserved OOPs! !
oopTypeArrayClass!public! !
oopTypeClass!public! !
oopTypeWithOop:!public! !
oopZero!public!Reserved OOPs! !
specialFromOop:!public! !
!

!Gcilw6x class methodsFor!

fileNameSearch

	^self name , '.dll'
! !
!Gcilw6x class categoriesForMethods!
fileNameSearch!public! !
!

