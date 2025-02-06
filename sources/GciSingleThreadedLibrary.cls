"Filed out from Dolphin Smalltalk"!

GciLibrary subclass: #GciSingleThreadedLibrary
	instanceVariableNames: 'semaphore'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GciSingleThreadedLibrary guid: (GUID fromString: '{afffafeb-5777-4d4b-a7d0-931922158468}')!

GciSingleThreadedLibrary comment: 'JadeLoginShell show.
GciLibrary current gciCommit.
GciLibrary current nbCallResult.
GciLibrary current nbCallResultOop.


| library |
library := GciLibrary current.
Array 
	with: library nbCallDone
	with: library gciNbCommit
	with: library nbCallDone
	with: library nbCallResult.
'!

!GciSingleThreadedLibrary categoriesForClass!Unclassified! !

!GciSingleThreadedLibrary methodsFor!

_releaseOops: anArray

	| array |
	array := self oopTypeArrayClass new: anArray size.
	1 to: anArray size do: [:i | 
		array at: i put: (anArray at: i).
	].
	self gciReleaseOops: array _: array size.
!

_semaphore

	^semaphore.
!

abortSession: anInteger

	self 
		session: anInteger 
		activity: 'abortTransaction'
		critical: [
			self 
				gciAbort;
				signalIfError;
				yourself.
		].
!

beginSession: anInteger

	self 
		session: anInteger 
		activity: 'beginTransaction'
		critical: [
			self 
				gciBegin;
				signalIfError;
				yourself.
		].
!

close

	[
		self gciShutdown.
	] on: Error do: [:ex | 
		ex return.
	].
	^super close.
!

commitSession: anInteger

	self 
		session: anInteger 
		activity: 'commitTransaction' 
		critical: [
			self gciCommit ifTrue: [^self].
			self signalIfError.
			GciCommitFailure signal.
		].
!

fetchBytes: anOopType

	^self
		fetchBytes: anOopType
		classOop: (self fetchClass: anOopType)
!

fetchBytes: anOopType class: aClass

	| size bytes result |
	size := self gciFetchSize: anOopType.
	bytes := aClass new: size.
	result := self 
		gciFetchBytes: anOopType
		_: 1
		_: bytes
		_: size.
	result = size ifTrue: [^bytes].
	self signalLastError.
!

fetchBytes: anOopType classOop: oopClass

	oopClass = self oopClassString 			ifTrue: [^self fetchOneByteString: anOopType].
	oopClass = self oopClassSymbol 			ifTrue: [^(self fetchOneByteString: anOopType) asSymbol].
	oopClass = self oopClassByteArray 		ifTrue: [^self fetchBytes: anOopType class: ByteArray].
	oopClass = self oopClassUnicode7 		ifTrue: [^self fetchOneByteString: anOopType].
	oopClass = self oopClassUnicode16 		ifTrue: [^self fetchTwoByteString: anOopType].
	oopClass = self oopClassUnicode32 		ifTrue: [^self fetchBytes: anOopType class: Unicode32].
	oopClass = self oopClassDoubleByteString 	ifTrue: [^self fetchTwoByteString: anOopType].
	oopClass = self oopClassQuadByteString	ifTrue: [^self fetchBytes: anOopType class: QuadByteString].
	^anOopType.
!

fetchClass: anOopType

	| result |
	result := self gciFetchClass: anOopType.
	result = self oopNil ifTrue: [self signalLastError].
	^result.
!

fetchObjImpl: anOopType
	"0=pointer, 1=byte, 2=NSC, or 3=special
	If object is special, then we know on the client; otherwise we need to go to the server."

	| result |
	result := self gciFetchObjImpl: anOopType.
	result ~~ 3 ifTrue: [self signalIfError].
	^result.
!

fetchOneByteString: anOopType

	| size string result |
	size := self gciFetchSize: anOopType.
	string := AnsiString new: size.
	result := self 
		gciFetchBytes: anOopType
		_: 1
		_: string
		_: size.
	result = size ifTrue: [^string].
	self signalLastError.
!

fetchTwoByteString: anOopType

	| bytes result size stream |
	size := self gciFetchSize: anOopType.
	bytes := ByteArray new: size.
	result := self 
		gciFetchBytes: anOopType
		_: 1
		_: bytes
		_: size.
	result ~= size ifTrue: [self signalLastError].
	stream := WriteStream on: Utf8String new.
	1 to: result by: 2 do: [:i | 
		stream nextPut: (Character codePoint: (bytes at: i + 1) * 256 + (bytes at: i)).
	].
	^stream contents!

gciAbort

	<cdecl: void GciAbort>
	^self invalidCall: _failureCode!

gciBegin

	<cdecl: void GciBegin>
	^self invalidCall: _failureCode!

gciCallInProgress

	<cdecl: bool GciCallInProgress>
	^self invalidCall: _failureCode!

gciClearStack: processOop

	self subclassResponsibility.
!

gciCommit

	<cdecl: bool GciCommit>
	^self invalidCall: _failureCode!

gciContinueWith: process _: replaceTopOfStack _: flags _: error

	self subclassResponsibility!

gciErr: errorReport

	self subclassResponsibility.!

gciExecuteStrFromContext: string _: context _: symbolList

	self subclassResponsibility!

gciFetchBytes: anOopType _: startIndex _: cString _: maxSize

	self subclassResponsibility.!

gciFetchChars: anOopType _: startIndex _: cString _: maxSize

	self subclassResponsibility!

gciFetchClass: oop

	self subclassResponsibility!

gciFetchObjImpl: anObject

	self subclassResponsibility!

gciFetchSize: anObject

	self subclassResponsibility!

gciFetchVaryingOops: anObject _: startIndex _: theOops _: numOops

	self subclassResponsibility!

gciGemTrace: anInteger
"$GEMSTONE/include/gci.hf line 5098

/* GciGemTrace
    For use in debugging the implementation or client code.
    level = 0 none, 1 commands, 2 commands+args , 3 even more
    Function result is previous value of the tracing state.
    Also enabled by  export GS_LGC_DEBUG=<level>
    such as   export GS_LGC_DEBUG=2 
    in enviroments of libgcirpc.so and of netldi .
    The when level > 0 the gem process will write trace information to
    it's log file; the libgcirpc.so will write trace information
    to a gci<pid>trace.log file in the current directory of the client process.
 */
  EXTERN_GCI_DEC(int) 
GciGemTrace(int level);"

	"Interpreted as #int32 from #( #'int32' )"

	<cdecl: sdword GciGemTrace sdword>
	^self invalidCall: _failureCode!

gciGetSessionId

	<cdecl: sdword GciGetSessionId>
	^self invalidCall: _failureCode!

gciHardBreak

	<cdecl: void GciHardBreak>
	^self invalidCall: _failureCode!

gciInit

	<cdecl: bool GciInit>
	^self invalidCall: _failureCode!

gciLogin: userName _: password

	<cdecl: bool GciLogin lpstr lpstr>
	^self invalidCall: _failureCode!

gciLogout

	<cdecl: void GciLogout>
	^self invalidCall: _failureCode!

gciNbContinueWith: process _: replaceTopOfStack _: flags _: error

	self subclassResponsibility!

gciNbEnd: result
	"GciNbProgressEType GciNbEnd(void ** result);"

	<cdecl: sdword GciNbEnd lppvoid>
	^self invalidCall: _failureCode
"
/* Nonblocking support */
typedef enum {
  GCI_RESULT_NOT_READY,		/* nothing happened */
  GCI_RESULT_PROGRESSED,	/* a packet was received */
  GCI_RESULT_READY		/* your result is now ready */
  } GciNbProgressEType;

result	The address at which GciNbEnd should place a pointer to the result of the nonblocking call when it is complete.

	lppvoid	Pointer to pointer. Used for functions which take a parameter into which they write
		an address. The corresponding argument must be an ExternalAddress (or other indirection
		object), or an object whose first instance variable is such (e.g. an ExternalStructure).
		The address of the ExternalAddress itself is passed, so that on return it contains the
		address written back by the external function. nil is not a valid argument value.
		As a return type answers a pointer instance of LPVOID (i.e. LPVOID* = void**).
"

!

gciNbExecuteStrFromContext: string _: context _: symbolList

	self subclassResponsibility!

gciNbExecuteStrFromContext_: string _: context _: symbolList _: anInteger

	self subclassResponsibility!

gciNbPerform: receiver _: selector _: args _: numArgs

	self subclassResponsibility!

gciNbPerformNoDebug: receiver _: selector _: args _: numArgs

	self subclassResponsibility!

gciNewString: string

	self subclassResponsibility!

gciOopToChr: anObject

	self subclassResponsibility!

gciPerform: receiver _: selector _: args _: numArgs

	self subclassResponsibility!

gciPollForSignal

	<cdecl: bool GciPollForSignal>
	^self invalidCall: _failureCode!

gciReleaseOops: args _: numArgs

	self subclassResponsibility!

gciResolveSymbol: aString _: symbolList

	self subclassResponsibility!

gciSetNet: stoneName _: hostUserID _: hostPassword _: gemService

	<cdecl: void GciSetNet lpstr lpstr lpstr lpstr>
	^self invalidCall: _failureCode!

gciSetNet__: stoneName _: hostUserID _: hostPassword _: gemService _: passwordIsEncrypted _: errString _: maxErrSize _: netldiName
	"GciSetNetEx__(const char *StoneName, const char *HostUserId,
           const char *HostPassword, const char *GemService,
           BoolType passwordIsEncrypted,
           char *errString, size_t maxErrSize, const char* netldiName);"

	<cdecl: bool GciSetNetEx__ lpstr lpstr lpstr lpstr bool lpvoid qword lpstr>
	^self invalidCall: _failureCode!

gciSetSessionId: anInteger

	<cdecl: void GciSetSessionId sdword >
	^self invalidCall: _failureCode
!

gciShutdown

	<cdecl: void GciShutdown>
	^self invalidCall: _failureCode!

gciSoftBreak

	<cdecl: void GciSoftBreak>
	^self invalidCall: _failureCode!

gciVersion

	<cdecl: lpstr GciVersion>
	^self invalidCall: _failureCode!

gemTrace: anInteger

	^self gciGemTrace: anInteger.
!

hardBreakSession: anInteger

	| priorSession |
	priorSession := self gciGetSessionId.
	[
		self gciSetSessionId: anInteger.
		self gciHardBreak.
	] ensure: [
		self gciSetSessionId: priorSession.
	].
!

initialize

	(ActiveLibrary isNil or: [ActiveLibrary == self]) ifFalse: [self error: 'GemStone allows only one library per process!!'].
	ActiveLibrary := self.
	super initialize.
	semaphore := Semaphore forMutualExclusion.
	self gciInit ifFalse: [self error: 'GciInit() failed!!'].
!

lastError

	| errorReport result |
	errorReport := self errorStructureClass new.
	result := self gciErr: errorReport.
	^result
		ifTrue: [errorReport]
		ifFalse: [nil].
!

loginAs: userName password: password

	self 
		session: nil 
		activity: 'loginAs: ' , userName printString
		critical: [
			| success error |
			success := self
				gciLogin: userName
				_: password.
			success ifTrue: [^self gciGetSessionId].
			error := self lastError.
			GciLoginFailed 
				signal: error message
				with: error.
		].

!

loginHostUser: hostUser hostPassword: hostPassword gsUser: gsUser gsPassword: gsPassword gemNRS: gemString stoneNRS: stoneString

	^self
		gciSetNet: stoneString _: hostUser _: hostPassword _: gemString;
		loginAs: gsUser password: gsPassword
!

logoutSession: anInteger

	self 
		session: anInteger 
		activity: 'logout' 
		critical: [
			[
				self 
					gciLogout;
					signalIfError;
					yourself.
			] on: GciError do: [:ex | 
				ex tag number == 4100 ifTrue: [ex return].
				ex pass.
			].
		].!

nbResult

	| address delay |
	address := ExternalAddress new.
	delay := 1.
	[true] whileTrue: [
		| result |
		result := self gciNbEnd: address.
		(result isKindOf: SmallInteger ) ifFalse: [self error: 'Result of GciNbEnd() should be a SmallInteger but is ' , result printString , '!!?'].
		result = 2 ifTrue: [
			result := self oopAt: address.
			self signalIfError.
			^self valueOfOop: result.
		].
		Keyboard default isCancelPressed ifTrue: [self gciSoftBreak].
		Processor sleep: delay.
		delay := delay + 1 min: 100.
	].
!

pollForSignalSession: anInteger

	self 
		session: anInteger 
		activity: 'pollForSignal' 
		critical: [
			self gciPollForSignal ifFalse: [^self].
			self signalLastError.
		].
!

session: anInteger activity: aString critical: aBlock

	| activityEntry result |
	activityEntry := GciActivity newWithSessionId: anInteger description: aString window: View active.
	semaphore critical: [
		activityEntry gotSemaphore.
		anInteger ifNotNil: [self gciSetSessionId: anInteger].
		[[
			result := aBlock value.
			activityEntry result: (result == self ifTrue: [''] ifFalse: [result printString]).
		] ifCurtailed: [
			activityEntry result: ''.
		]
		] on: Error do: [:ex | 
			activityEntry result: ex description.
			ex pass.
		]
	].
	^result

!

session: anInteger clearStack: processOop

	self 
		session: anInteger 
		activity: 'clearStack: ' , processOop printString 
		critical: [
			self gciClearStack: processOop.
		].
!

session: anInteger continue: gsProcessOop withObject: anOop

	self 
		session: anInteger 
		activity: 'continueWith: ' , anOop printString 
		critical: [
			self useNonBlocking ifTrue: [
				self
					gciNbContinueWith: gsProcessOop
					_: anOop
					_: 1 "GCI_PERFORM_FLAG_ENABLE_DEBUG"
					_: nil.
				^self nbResult.
			] ifFalse: [
				| result |
				result := self
					gciContinueWith: gsProcessOop
					_: anOop
					_: 1 "GCI_PERFORM_FLAG_ENABLE_DEBUG"
					_: nil.
				self signalIfError.
				^self valueOfOop: result
			].
		].
!

session: session execute: aString context: contextOop environment: anInteger

	anInteger == 0 ifFalse: [self error: 'Only environment 0 is supported in this version!!'].
	self 
		session: session 
		activity: 'executeString: ' , aString printString 
		critical: [
			self useNonBlocking ifTrue: [
				self
					gciNbExecuteStrFromContext: aString
					_: contextOop
					_: self oopNil.
				^self nbResult.
			] ifFalse: [
				| result |
				result := self
					gciExecuteStrFromContext: aString
					_: contextOop
					_: self oopNil.
				self signalIfError.
				^self valueOfOop: result
			].
		].
!

session: anInteger fetchBytes: anOopType 

	self 
		session: anInteger 
		activity: 'fetchBytes: ' , anOopType printString 
		critical: [
			^self fetchBytes: anOopType.
		].
!

session: anInteger fetchObjects: anOopType 

	anOopType isSpecial ifTrue: [^self specialFromOop: anOopType].
	self 
		session: anInteger 
		activity: 'fetchObjects: ' , anOopType printString 
		critical: [
			| type size array result |
			(type := self fetchObjImpl: anOopType) = 0 ifFalse: [self error: 'Expected 0 but got ' , type printString].
			size := self gciFetchSize: anOopType.
			array := self oopTypeArrayClass new: size.
			result := self 
				gciFetchVaryingOops: anOopType
				_: 1
				_: array
				_: size.
			result = size ifTrue: [^array].
			self signalLastError.
		].
!

session: session oopForInteger: anInteger

	(anInteger isKindOf: SmallInteger) ifTrue: [^self oopForInteger: anInteger].
	self 
		session: anInteger 
		activity: 'oopForInteger: ' , anInteger printString 
		critical: [
			^self oopForInteger: anInteger.
		].
!

session: anInteger oopForString: aString

	self 
		session: anInteger 
		activity: 'oopForString: ' , aString printString 
		critical: [
			^self gciNewString: aString.
		].
!

session: anInteger releaseOops: anArray

	self 
		session: anInteger 
		activity: 'releaseOops ' , anArray printString 
		critical: [
			self _releaseOops: anArray.
		].
!

session: anInteger resolveSymbol: aString

	self 
		session: anInteger 
		activity: 'resolveSymbol: ' , aString printString 
		critical: [
			^self gciResolveSymbol: aString _: self oopNil.
		].
!

session: anInteger send: aString to: anOopType with: anArray 

	self 
		session: anInteger 
		activity: 'send: ' , aString printString , ' to: ' , anOopType printString , ' with: ' , anArray printString
		critical: [
			self useNonBlocking ifTrue: [
				self
					gciNbPerform: anOopType 
					_: aString 
					_: anArray 
					_: anArray size.
				^self nbResult.
			] ifFalse: [
				| result |
				result := self
					gciPerform: anOopType 
					_: aString 
					_: anArray 
					_: anArray size.
				self signalIfError.
				^self valueOfOop: result
			].
		].
!

session: session valueOfOop: anOopType

	self 
		session: session 
		activity: 'valueOfOop: ' , anOopType printString 
		critical: [
			^self valueOfOop: anOopType.
		].
!

signalIfError

	| error |
	(error := self lastError) notNil ifTrue: [GciError signalWith: error].
!

signalLastError

	GciError signalWith: self lastError.
!

signalSemaphoreIfNeeded: anArray
	"If the semaphore was acquired, then anArray will have a non-nil value"

	(anArray basicAt: 1) == nil ifTrue: [^self].
	anArray basicAt: 1 put: nil.
	semaphore signal.
!

softBreakSession: anInteger

	| priorSession |
	priorSession := self gciGetSessionId.
	[
		self gciSetSessionId: anInteger.
		self gciSoftBreak.
	] ensure: [
		self gciSetSessionId: priorSession.
	].
!

specialFromOop: anOopType

	self subclassResponsibility!

valueOfOop: anOopType

	| type |
	type := self fetchObjImpl: anOopType.
	type = 1 ifTrue: [^self fetchBytes: anOopType].
	type = 3 ifTrue: [^self specialFromOop: anOopType].
	^anOopType.
!

version

	^self gciVersion.
! !

!GciSingleThreadedLibrary categoriesForMethods!
_releaseOops:!public!required! !
_semaphore!private! !
abortSession:!public!required! !
beginSession:!public!required! !
close!public! !
commitSession:!public!required! !
fetchBytes:!not subclassResponsibility!private! !
fetchBytes:class:!private! !
fetchBytes:classOop:!not subclassResponsibility!private! !
fetchClass:!private! !
fetchObjImpl:!private! !
fetchOneByteString:!private! !
fetchTwoByteString:!private! !
gciAbort!private! !
gciBegin!private! !
gciCallInProgress!private! !
gciClearStack:!private! !
gciCommit!private! !
gciContinueWith:_:_:_:!private! !
gciErr:!private! !
gciExecuteStrFromContext:_:_:!private! !
gciFetchBytes:_:_:_:!private! !
gciFetchChars:_:_:_:!private! !
gciFetchClass:!private! !
gciFetchObjImpl:!private! !
gciFetchSize:!private! !
gciFetchVaryingOops:_:_:_:!private! !
gciGemTrace:!private! !
gciGetSessionId!private! !
gciHardBreak!private! !
gciInit!private! !
gciLogin:_:!private! !
gciLogout!private! !
gciNbContinueWith:_:_:_:!private! !
gciNbEnd:!private! !
gciNbExecuteStrFromContext:_:_:!private! !
gciNbExecuteStrFromContext_:_:_:_:!private! !
gciNbPerform:_:_:_:!private! !
gciNbPerformNoDebug:_:_:_:!private! !
gciNewString:!private! !
gciOopToChr:!private! !
gciPerform:_:_:_:!private! !
gciPollForSignal!private! !
gciReleaseOops:_:!private! !
gciResolveSymbol:_:!private! !
gciSetNet:_:_:_:!private! !
gciSetNet__:_:_:_:_:_:_:_:!private! !
gciSetSessionId:!private! !
gciShutdown!private! !
gciSoftBreak!private! !
gciVersion!private! !
gemTrace:!public!to investigate! !
hardBreakSession:!public!required! !
initialize!private! !
lastError!private! !
loginAs:password:!public!to investigate! !
loginHostUser:hostPassword:gsUser:gsPassword:gemNRS:stoneNRS:!public!required! !
logoutSession:!public!required! !
nbResult!public!to investigate! !
pollForSignalSession:!public! !
session:activity:critical:!public! !
session:clearStack:!public!required! !
session:continue:withObject:!public! !
session:execute:context:environment:!public!required! !
session:fetchBytes:!public!required! !
session:fetchObjects:!public!required! !
session:oopForInteger:!public!required! !
session:oopForString:!public!required! !
session:releaseOops:!public!required! !
session:resolveSymbol:!public!subclassResponsibility! !
session:send:to:with:!public!required! !
session:valueOfOop:!public!required! !
signalIfError!private! !
signalLastError!private! !
signalSemaphoreIfNeeded:!private! !
softBreakSession:!public!required! !
specialFromOop:!private! !
valueOfOop:!private! !
version!public! !
!

