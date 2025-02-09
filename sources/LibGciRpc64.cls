﻿"Filed out from Dolphin Smalltalk"!

GciSingleThreadedLibrary subclass: #LibGciRpc64
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LibGciRpc64 guid: (GUID fromString: '{ce7fe05a-c8ee-4a13-b4aa-7c8aef295620}')!

LibGciRpc64 comment: ''!

!LibGciRpc64 categoriesForClass!Unclassified! !

!LibGciRpc64 methodsFor!

errorStructureClass

	^GciErrSType64.
!

gciClearStack: processOop

	<cdecl: void GciClearStack OopType64>
	^self invalidCall: _failureCode
!

gciContinueWith: process _: replaceTopOfStack _: flags _: error

	<cdecl: void GciContinueWith OopType64 OopType64 sdword GciErrSType64*>
	^self invalidCall: _failureCode
!

gciDbgEstablishToFile: aString
	"BoolType GciDbgEstablishToFile( const char * fileName );"

	<cdecl: bool GciDbgEstablishToFile lpstr>
	^self invalidCall: _failureCode
!

gciErr: errorReport

	<cdecl: bool GciErr GciErrSType64*>
	^self invalidCall: _failureCode
!

gciExecuteStr: string _: symbolList

	<cdecl: OopType64 GciExecuteStr lpstr OopType64>
	^self invalidCall: _failureCode
!

gciExecuteStr_: string _: symbolList _: environmentId
"/* =============================================================================
 * GciExecuteStrFromContext, GciExecuteStrFromContext_ functions
 *   Execute a Smalltalk expression contained in a C string as if it were a
 *   message sent to an object.
 *
 * Input Arguments:
 *   source	A null-terminated string containing a sequence of one or more
 *              statements to be executed.
 *   contextObject
 *		The OOP of any GemStone object.  The code to be executed is
 *              compiled as if it were an instance method in the class of
 *              contextObject.
 *              A value of OOP_NO_CONTEXT means no context.
 *   symbolList	The OOP of a GemStone symbol list (that is, an Array of
 *              instances of SymbolDictionary).  The compiler uses the
 *              symbolList to resolve symbolic references in the code in source.
 *              A value of OOP_NIL means to use the default symbol list for the
 *              current GemStone session (that is, System myUserProfile
 *              symbolList).
 *
 *   environmentId specifies a compilation environment for the execution
 *
 * Return Value:
 *   Returns the OOP of the execution result.  In case of error, this function
 *   returns OOP_NIL.
 *==============================================================================
"
	<cdecl: OopType64 GciExecuteStr_ lpstr OopType64 word>
	^self invalidCall: _failureCode
!

gciExecuteStrFromContext: string _: context _: symbolList

	<cdecl: OopType64 GciExecuteStrFromContext lpstr OopType64 OopType64>
	^self invalidCall: _failureCode
!

gciFetchBytes: anOopType _: startIndex _: cString _: maxSize

	<cdecl: sdword GciFetchBytes_ OopType64 sqword lpvoid qword>
	^self invalidCall: _failureCode
!

gciFetchChars: anOopType _: startIndex _: cString _: maxSize

	<cdecl: sdword GciFetchChars_ OopType64 sqword lpstr qword>
	^self invalidCall: _failureCode
!

gciFetchClass: oop

	<cdecl: OopType64 GciFetchClass OopType64>
	^self invalidCall: _failureCode
!

gciFetchObjImpl: anObject

	<cdecl: sdword GciFetchObjImpl OopType64>
	^self invalidCall: _failureCode
!

gciFetchSize: anObject

	<cdecl: sdword GciFetchSize_ OopType64>
	^self invalidCall: _failureCode
!

gciFetchVaryingOops: anObject _: startIndex _: theOops _: numOops

	<cdecl: sdword GciFetchVaryingOops OopType64 sqword OopType64Array* sdword>
	^self invalidCall: _failureCode
!

gciFltToOop: aFloat

	<cdecl: OopType64 GciFltToOop double>
	^self invalidCall: _failureCode
!

gciI64ToOop: anInteger

	<cdecl: OopType64 GciI64ToOop sdword>
	^self invalidCall: _failureCode
!

gciNbContinueWith: process _: replaceTopOfStack _: flags _: error

	<cdecl: void GciNbContinueWith OopType64 OopType64 sdword GciErrSType64*>
	^self invalidCall: _failureCode
!

gciNbExecuteStrFromContext: string _: context _: symbolList

	<cdecl: OopType64 GciNbExecuteStrFromContext lpstr OopType64 OopType64>
	^self invalidCall: _failureCode
!

gciNbExecuteStrFromContext_: string _: context _: symbolList _: anInteger

	<cdecl: OopType64 GciNbExecuteStrFromContext_ lpstr OopType64 OopType64 word>
	^self invalidCall: _failureCode
!

gciNbPerform: receiver _: selector _: args _: numArgs

	<cdecl: void GciNbPerform OopType64 lpstr OopType64* dword>
	^self invalidCall: _failureCode
!

gciNbPerformNoDebug: receiver _: selector _: args _: numArgs

	self error: 'Function takes five arguments in 64-bit'.

!

gciNbPerformNoDebug: receiver _: selector _: args _: numArgs _: flags
"	/* bits in flags argument to GciPerformNoDebug.  */
enum { 
  GCI_PERFORM_FLAG_ENABLE_DEBUG = 1,  
   /* make like GciPerform() with respect to debugging. default is debugger is
    * disabled until GciPerformNoDebug returns */

  GCI_PERFORM_FLAG_DISABLE_ASYNC_EVENTS = 2  ,
   /* disable async events.  Used for GSI to be able to execute an exception
    * block or method to service RT_ERR_SIGNAL_ABORT, 
    *  RT_ERR_SIGNAL_GEMSTONE_SESSION, or ABORT_ERR_LOST_OT_ROOT */

  GCI_PERFORM_FLAG_SINGLE_STEP = 4, 
   /* place a single step break-point at the start of the method to be
    * performed, and then execute to hit that breakpoint.
    * if true, also implies GCI_PERFORM_FLAG_INTERPRETED
    */

  GCI_PERFORM_MAP_SYMBOLS = 8, // obsolete, not used

  GCI_PERFORM_FLAG_INTERPRETED = 0x20, /* disable native code for the execution*/

  GCI_PERFORM_RUBY = 0x40  /* for use by GciExecuteFromContextDbg*
                            *   for implementing Ruby doit in ruby topaz */
 };"

	<cdecl: void GciNbPerformNoDebug OopType64 lpstr OopType64* dword dword>
	^self invalidCall: _failureCode
!

gciNewString: string

	<cdecl: OopType64 GciNewString lpstr >
	^self invalidCall: _failureCode
!

gciOopToChr: anObject
	"http://kermit.gemtalksystems.com/bug?bug=47915

	<cdecl: byte GciOopToChr OopType64>
	^self invalidCall"

	^anObject asInteger bitShift: -8
!

gciOopToChr32: anObject
	"http://kermit.gemtalksystems.com/bug?bug=47915"

	<cdecl: sdword GciOopToChr OopType64>
	^self invalidCall: _failureCode
!

gciPerform: receiver _: selector _: args _: numArgs

	<cdecl: OopType64 GciPerform OopType64 lpvoid OopType64* sdword>
	^self invalidCall: _failureCode
!

gciPerformNoDebug: receiver _: selector _: args _: numArgs _: flags
"	/* bits in flags argument to GciPerformNoDebug.  */
enum { 
  GCI_PERFORM_FLAG_ENABLE_DEBUG = 1,  
   /* make like GciPerform() with respect to debugging. default is debugger is
    * disabled until GciPerformNoDebug returns */

  GCI_PERFORM_FLAG_DISABLE_ASYNC_EVENTS = 2  ,
   /* disable async events.  Used for GSI to be able to execute an exception
    * block or method to service RT_ERR_SIGNAL_ABORT, 
    *  RT_ERR_SIGNAL_GEMSTONE_SESSION, or ABORT_ERR_LOST_OT_ROOT */

  GCI_PERFORM_FLAG_SINGLE_STEP = 4, 
   /* place a single step break-point at the start of the method to be
    * performed, and then execute to hit that breakpoint.
    * if true, also implies GCI_PERFORM_FLAG_INTERPRETED
    */

  GCI_PERFORM_MAP_SYMBOLS = 8, // obsolete, not used

  GCI_PERFORM_FLAG_INTERPRETED = 0x20, /* disable native code for the execution*/

  GCI_PERFORM_RUBY = 0x40  /* for use by GciExecuteFromContextDbg*
                            *   for implementing Ruby doit in ruby topaz */
 };"

	<cdecl: void GciPerformNoDebug OopType64 lpstr OopType64* dword dword>
	^self invalidCall: _failureCode
!

gciReleaseOops: args _: numArgs

	<cdecl: void GciReleaseOops OopType64* dword>
	^self invalidCall: _failureCode
!

gciResolveSymbol: aString _: symbolList

	<cdecl: OopType64 GciResolveSymbol lpstr OopType64>
	^self invalidCall: _failureCode
!

oopAsciiNul

	^OopType64 fromInteger: 28. "16r1C"
!

oopAt: anExternalAddress

	^OopType64 fromInteger: (anExternalAddress sqwordAtOffset: 0).
!

oopClassArray

	^OopType64 fromInteger: 66817.
!

oopClassByteArray

	^OopType64 fromInteger: 103425.!

oopClassDoubleByteString

	^OopType64 fromInteger: 143873.
!

oopClassQuadByteString

	^OopType64 fromInteger: 144385.
!

oopClassString

	^OopType64 fromInteger: 74753.
!

oopClassSymbol

	^OopType64 fromInteger: 110849.
!

oopClassSystem

	^OopType64 fromInteger: 76033.
!

oopClassUnicode16

	^OopType64 fromInteger: 154625.
!

oopClassUnicode32

	^OopType64 fromInteger: 154881.
!

oopClassUnicode7

	^OopType64 fromInteger: 154369.
!

oopFalse

	^OopType64 fromInteger: 12. "16r0C"
!

oopForInteger: anInteger

	| int bytes |
	bytes := ByteArray new: 8.
	bytes 
		qwordAtOffset: 0 
		put: anInteger.
	int := bytes sdwordAtOffset: 0.
	^self gciI64ToOop: int.
!

oopGemStoneError

	^OopType64 fromInteger:  231169.!

oopIllegal

	^OopType64 fromInteger: 1. "16r01"
!

oopMaxSmallInteger

	^OopType64 fromInteger: 9223372036854775802.	"'16r7FFFFFFFFFFFFFFA'"
!

oopMinSmallInteger

	^OopType64 fromInteger: -9223372036854775806.	"'-16r7FFFFFFFFFFFFFFE'"
!

oopMinusOne

	^OopType64 fromInteger: -6.
!

oopNil

	^OopType64 fromInteger: 20. "16r14"
!

oopOne

	^OopType64 fromInteger: 10.
!

oopRemoteNil

	^OopType64 fromInteger: 276. "16r114"
!

oopTrue

	^OopType64 fromInteger: 268.	"16r10C"
!

oopTwo

	^OopType64 fromInteger: 18.
!

oopTypeArrayClass

	^OopType64Array.!

oopTypeClass

	^OopType64.
!

oopTypeWithOop: anInteger

	| int bytes |
	bytes := ByteArray new: 8.
	bytes 
		qwordAtOffset: 0 
		put: anInteger.
	int := bytes sqwordAtOffset: 0.
	^OopType64 fromInteger: int.
!

oopZero

	^OopType64 fromInteger: 2.
!

specialFromOop: anOop

	anOop isBoolean 		ifTrue: [^anOop = self oopTrue].
	anOop isCharacter 		ifTrue: [^Character value: (self gciOopToChr: anOop)].
	anOop isSmallInteger 	ifTrue: [^anOop asSmallInteger].
	anOop isSmallDouble 	ifTrue: [^anOop smallDoubleAsFloat].
	^nil.
! !

!LibGciRpc64 categoriesForMethods!
errorStructureClass!private! !
gciClearStack:!private! !
gciContinueWith:_:_:_:!private! !
gciDbgEstablishToFile:!private! !
gciErr:!private! !
gciExecuteStr:_:!private! !
gciExecuteStr_:_:_:!private! !
gciExecuteStrFromContext:_:_:!private! !
gciFetchBytes:_:_:_:!private! !
gciFetchChars:_:_:_:!private! !
gciFetchClass:!private! !
gciFetchObjImpl:!private! !
gciFetchSize:!private! !
gciFetchVaryingOops:_:_:_:!private! !
gciFltToOop:!private! !
gciI64ToOop:!private! !
gciNbContinueWith:_:_:_:!private! !
gciNbExecuteStrFromContext:_:_:!private! !
gciNbExecuteStrFromContext_:_:_:_:!private! !
gciNbPerform:_:_:_:!private! !
gciNbPerformNoDebug:_:_:_:!private! !
gciNbPerformNoDebug:_:_:_:_:!private! !
gciNewString:!private! !
gciOopToChr:!private! !
gciOopToChr32:!private! !
gciPerform:_:_:_:!private! !
gciPerformNoDebug:_:_:_:_:!private! !
gciReleaseOops:_:!private! !
gciResolveSymbol:_:!private! !
oopAsciiNul!public!Reserved OOPs! !
oopAt:!private! !
oopClassArray!public!Reserved OOPs! !
oopClassByteArray!public!Reserved OOPs! !
oopClassDoubleByteString!public!Reserved OOPs! !
oopClassQuadByteString!public!Reserved OOPs! !
oopClassString!public!Reserved OOPs! !
oopClassSymbol!public!Reserved OOPs! !
oopClassSystem!public!Reserved OOPs! !
oopClassUnicode16!public!Reserved OOPs! !
oopClassUnicode32!public!Reserved OOPs! !
oopClassUnicode7!public!Reserved OOPs! !
oopFalse!public!Reserved OOPs! !
oopForInteger:!public!Reserved OOPs! !
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
oopTypeArrayClass!public!Reserved OOPs! !
oopTypeClass!public!Reserved OOPs! !
oopTypeWithOop:!public!Reserved OOPs! !
oopZero!public!Reserved OOPs! !
specialFromOop:!public! !
!

