! ------------------- Remove existing behavior from GciLibraryApp
removeAllMethods GciLibraryApp
removeAllClassMethods GciLibraryApp
! ------------------- Class methods for GciLibraryApp
set compile_env: 0
category: 'required'
classmethod: GciLibraryApp
run
"
	GciLibraryApp run.
"
	HttpListener new
		listenBacklog: 100;
		port: 8888;
		webApp: self;
		run.
%
! ------------------- Instance methods for GciLibraryApp

! -- Utilities
category: 'WebSockets'
method: GciLibraryApp
library
	"
	SessionTemps current removeKey: #'library'.
	"
	^SessionTemps current
		at: #'library'
		ifAbsentPut: [(GciApp at: #'GciTsLibraryFull') new]
%
category: 'Utilities'
method: GciLibraryApp
oopAt: aString

	^Integer fromHexString: (requestDict at: aString ifAbsent: [^nil]).
%
category: 'Utilities'
method: GciLibraryApp
return: anObject

	error number ~~ 0 ifTrue: [
		^Dictionary new
			at: 'error' put: error number;
			at: 'message' put: error message;
			yourself
	].
	^Dictionary new
		at: 'result' put: anObject;
		yourself
%
category: 'Utilities'
method: GciLibraryApp
returnOop: anInteger

	^self return: (anInteger printStringRadix: 16 showRadix: false)
%
category: 'Utilities'
method: GciLibraryApp
session

	| bytes integer |
	(integer := self oopAt: 'session') ifNil: [^nil].
	bytes := (CByteArray gcMalloc: 8)
		int64At: 0 put: integer;
		yourself.
	^bytes pointerAt: 0 resultClass: CPointer.
%

! -- GciTs API
category: 'GciTs API'
method: GciLibraryApp
abort

	^self return: (self library GciTsAbort_: session _: error)
%
category: 'GciTs API'
method: GciLibraryApp
begin

	^self return: (self library GciTsBegin_: session _: error)
%
category: 'GciTs API'
method: GciLibraryApp
break

	| hardBreakFlag |
	hardBreakFlag := (requestDict at: 'isHard') ifTrue: [1] ifFalse: [0].
	^self return: (self library GciTsBreak_: session _: hardBreakFlag _: error)
%
category: 'GciTs API'
method: GciLibraryApp
charToOop

	^self returnOop: (self library GciTsCharToOop_: (requestDict at: 'char'))
%
category: 'GciTs API'
method: GciLibraryApp
commit

	^self return: (self library GciTsCommit_: session _: error)
%
category: 'GciTs API'
method: GciLibraryApp
doubleToOop

	^self returnOop: (self library
		GciTsDoubleToOop_: session
		_: (requestDict at: 'double') _: error)
%
category: 'GciTs API'
method: GciLibraryApp
doubleToSmallDouble

	^self returnOop: (self library
		GciTsDoubleToSmallDouble_: (requestDict at: 'double'))
%
category: 'GciTs API'
method: GciLibraryApp
encrypt

	| buffer index |
	buffer := CByteArray gcMalloc: 64.
	result := self library GciTsEncrypt_: (requestDict at: 'password') _: buffer _: buffer size.
	result ifNil: [
		^Dictionary new
			error: 1;
			message: 'Unable to encrypt password (too long?)';
			yourself.
	].
	result := buffer stringFrom: 0 to: buffer size - 1.
	index := result indexOf: (Character codePoint: 0).
	result := result copyFrom: 1 to: index - 1.
	^Dictionary new
		at: 'result' put: result;
		yourself
%
category: 'GciTs API'
method: GciLibraryApp
fetchSpecialClass

	^self returnOop: (self library
		GciTsFetchSpecialClass_: (self oopAt: 'oop'))
%
category: 'GciTs API'
method: GciLibraryApp
fetchUnicode

	| buffer destSize requiredSize |
	requiredSize := CByteArray gcMalloc: 8.
	requiredSize int64At: 0 put: 1024.
	destSize := 0.
	[destSize < (requiredSize int64At: 0)] whileTrue: [
		destSize := requiredSize int64At: 0.
		buffer := CByteArray gcMalloc: destSize * 2.
		result := self library
			GciTsFetchUnicode_: session
			_: (self oopAt: 'oop')
			_: buffer
			_: destSize
			_: requiredSize
			_: error.
	].
	result == -1 ifTrue: [
		^self return: nil
	].
	buffer := buffer byteArrayFrom: 1 to: result * 2 - 1.
	^self return: buffer asBase64String
%
category: 'GciTs API'
method: GciLibraryApp
getFreeOops

	| array buffer count |
	count := requestDict at: 'count' ifAbsent: 0.
	buffer := CByteArray gcMalloc: count * 8.
	result := self library
		GciTsGetFreeOops_: session
		_: buffer
		_: count
		_: error.
	result == -1 ifTrue: [
		^self return: nil
	].
	array := Array new: result.
	1 to: result do: [:i |
		| oop |
		oop := buffer uint64At: i - 1 * 8.
		array at: i put: (oop printStringRadix: 16 showRadix: false).
	].
	^self return: array
%
set compile_env: 0
category: 'GciTs API'
method: GciLibraryApp
getGciVersion

	| buffer index product version |
	buffer := CByteArray gcMalloc: 128.
	product := self library GciTsVersion_: buffer _: buffer size.
	version := buffer stringFrom: 0 to: buffer size - 1.
	index := version indexOf: (Character codePoint: 0).
	version := version copyFrom: 1 to: index - 1.
	^Dictionary new
		at: 'product' put: product;
		at: 'version' put: version;
		yourself
%
category: 'GciTs API'
method: GciLibraryApp
i32ToOop

	^self returnOop: (self library GciI32ToOop_: (requestDict at: 'int'))
%
category: 'GciTs API'
method: GciLibraryApp
i64ToOop

	^self returnOop: (self library
		GciTsI64ToOop_: session
		_: (self oopAt: 'i64')
		_: error)
%
category: 'GciTs API'
method: GciLibraryApp
login
	"GciTsLogin_: StoneNameNrs _: HostUserId _: HostPassword _: hostPwIsEncrypted _: GemServiceNrs
		_: gemstoneUsername _: gemstonePassword _: loginFlags _: haltOnErrNum _: executedSessionInit _: err
	$GEMSTONE/include/gcits.hf line 72
		GciSession GciTsLogin(  const char *StoneNameNrs,  const char *HostUserId,  const char *HostPassword,
			BoolType hostPwIsEncrypted,  const char *GemServiceNrs,  const char *gemstoneUsername,
			const char *gemstonePassword,  unsigned int loginFlags ,  int haltOnErrNum,  BoolType *executedSessionInit,
			GciErrSType *err) ;

	Interpreted as #ptr from #( #'const char*' #'const char*' #'const char*' #'int32' #'const char*' #'const char*' #'const char*' #'uint32' #'int32' #'ptr' #'ptr' )	"
	| initFlag |
	initFlag := CByteArray gcMalloc: 8.
	result := self library
		GciTsLogin_: GsNetworkResourceString defaultStoneNRSFromCurrent printString
		_: nil "HostUserId"
		_: nil "HostPassword"
		_: 0 "hostPwIsEncrypted"
		_: GsNetworkResourceString defaultGemNRSFromCurrent printString
		_: (requestDict at: 'username' ifAbsent: ['username'])
		_: (requestDict at: 'password' ifAbsent: ['password'])
		_: 0	"flags"
		_: 0	"haltOnErrNum"
		_: initFlag
		_: error.
	^self returnOop: (result ifNil: [nil] ifNotNil: [result memoryAddress])
%
category: 'GciTs API'
method: GciLibraryApp
logout

	^self return: (self library GciTsLogout_: session _: error)
%
category: 'GciTs API'
method: GciLibraryApp
nbResult

	| flag requestSocket timeout |
	requestSocket := GsSocket fromFileHandle: (requestDict at: 'socket').
	timeout := requestDict at: 'timeout' ifAbsent: [0].
	(requestSocket readWillNotBlockWithin: timeout) ifTrue: [
		^self return: (self library GciTsNbResult_: session _: error)
	].
	^self return: nil
%
category: 'GciTs API'
method: GciLibraryApp
newByteArray

	| bytes |
	bytes := requestDict at: 'bytes' ifAbsent: [''].
	bytes := ByteArray fromBase64String: bytes.
	bytes := CByteArray withAll: bytes.
	bytes := self library
		GciTsNewByteArray_: session
		_: bytes
		_: bytes size
		_: error.
	^self returnOop: bytes.
%
category: 'GciTs API'
method: GciLibraryApp
newObj

	^self returnOop: (self library
		GciTsNewObj_: session
		_: (self oopAt: 'class')
		_: error)
%
category: 'GciTs API'
method: GciLibraryApp
newString

	^self returnOop: (self library
		GciTsNewString_: session
		_: (requestDict at: 'string' ifAbsent: [''])
		_: error)
%
category: 'GciTs API'
method: GciLibraryApp
newSymbol

	^self returnOop: (self library
		GciTsNewSymbol_: session
		_: (requestDict at: 'string' ifAbsent: [''])
		_: error)
%
category: 'GciTs API'
method: GciLibraryApp
newUnicodeString

	| bytes |
	bytes := requestDict at: 'bytes' ifAbsent: [''].
	^self returnOop: (self library
		GciTsNewUtf8String__: session
		_: (Utf8 fromBase64String: bytes)
		_: bytes size
		_: 1 "convertToUnicode is true"
		_: error)
%
category: 'GciTs API'
method: GciLibraryApp
newUtf8String

	| bytes |
	bytes := requestDict at: 'bytes' ifAbsent: [''].
	^self returnOop: (self library
		GciTsNewUtf8String__: session
		_: (Utf8 fromBase64String: bytes)
		_: bytes size
		_: 0 "convertToUnicode is false"
		_: error)
%
category: 'GciTs API'
method: GciLibraryApp
oopIsSpecial

	^self return: (self library GciTsOopIsSpecial_: (self oopAt: 'oop')) == 1
%
category: 'GciTs API'
method: GciLibraryApp
oopToChar

	^self return: (self library GciTsOopToChar_: (self oopAt: 'oop'))
%
category: 'GciTs API'
method: GciLibraryApp
oopToDouble

	| buffer |
	buffer := CByteArray gcMalloc: 8.
	result := self library
		GciTsOopToDouble_: session
		_: (self oopAt: 'oop')
		_: buffer
		_: error.
	result == 1 ifTrue: [
		^self return: (buffer doubleAt: 0)
	].
	^self return: nil
%
category: 'GciTs API'
method: GciLibraryApp
oopToI64

	| buffer |
	buffer := CByteArray gcMalloc: 8.
	result := self library
		GciTsOopToI64_: session
		_: (self oopAt: 'oop')
		_: buffer
		_: error.
	result == 1 ifTrue: [
		^self returnOop: (buffer int64At: 0)
	].
	^self return: nil
%
category: 'GciTs API'
method: GciLibraryApp
resolveSymbol

	^self returnOop: (self library
		GciTsResolveSymbol_: session
		_: (requestDict at: 'symbol')
		_: (self oopAt: 'symbolList')
		_: error)
%
category: 'GciTs API'
method: GciLibraryApp
resolveSymbolObj

	^self returnOop: (self library
		GciTsResolveSymbolObj_: session
		_: (self oopAt: 'oop')
		_: (self oopAt: 'symbolList')
		_: error)
%
category: 'GciTs API'
method: GciLibraryApp
sessionIsRemote

	^self return: (self library GciTsSessionIsRemote_: session)
%
category: 'GciTs API'
method: GciLibraryApp
socket

	^self return: (self library GciTsSocket_: session _: error)
%

! -- WebSocket
category: 'WebSockets'
method: GciLibraryApp
handleRequest: aDict

	| command |
	error := GciErrSType new.
	requestDict := aDict.
	result := nil.
	session := self session.
	command := requestDict at: 'request'.
	command = 'abort' ifTrue: [^self abort].
	command = 'begin' ifTrue: [^self begin].
	command = 'break' ifTrue: [^self break].
	command = 'charToOop' ifTrue: [^self charToOop].
	command = 'commit' ifTrue: [^self commit].
	command = 'doubleToOop' ifTrue: [^self doubleToOop].
	command = 'doubleToSmallDouble' ifTrue: [^self doubleToSmallDouble].
	command = 'encrypt' ifTrue: [^self encrypt].
	command = 'fetchSpecialClass' ifTrue: [^self fetchSpecialClass].
	command = 'getFreeOops' ifTrue: [^self getFreeOops].
	command = 'fetchUnicode' ifTrue: [^self fetchUnicode].
	command = 'getGciVersion' ifTrue: [^self getGciVersion].
	command = 'i32ToOop' ifTrue: [^self i32ToOop].
	command = 'i64ToOop' ifTrue: [^self i64ToOop].
	command = 'login' ifTrue: [^self login].
	command = 'logout' ifTrue: [^self logout].
	command = 'nbResult' ifTrue: [^self nbResult].
	command = 'newByteArray' ifTrue: [^self newByteArray].
	command = 'newObj' ifTrue: [^self newObj].
	command = 'newString' ifTrue: [^self newString].
	command = 'newSymbol' ifTrue: [^self newSymbol].
	command = 'newUnicodeString' ifTrue: [^self newUnicodeString].
	command = 'newUtf8String' ifTrue: [^self newUtf8String].
	command = 'oopIsSpecial' ifTrue: [^self oopIsSpecial].
	command = 'oopToChar' ifTrue: [^self oopToChar].
	command = 'oopToDouble' ifTrue: [^self oopToDouble].
	command = 'oopToI64' ifTrue: [^self oopToI64].
	command = 'resolveSymbol' ifTrue: [^self resolveSymbol].
	command = 'resolveSymbolObj' ifTrue: [^self resolveSymbolObj].
	command = 'sessionIsRemote' ifTrue: [^self sessionIsRemote].
	command = 'socket' ifTrue: [^self socket].
	self error: 'Unrecognized command: ' , command printString.
%
category: 'WebSockets'
method: GciLibraryApp
handleRequestString: aString

	| dictIn dictOut time |
	Log instance log: #'debug' string: 'GciApp>>handleRequest: - ' , aString printString.
	time := Time millisecondsElapsedTime: [
		[
			dictIn := JsonParser parse: aString.
			dictOut := self handleRequest: dictIn.
		] on: Error do: [:ex |
			dictOut := Dictionary new
				at: 'error' put: ex number;
				at: 'message' put: ex description;
				yourself.
		].
	].
	dictOut at: 'time' put: time.
	WebSocketDataFrame sendText: dictOut asJson onSocket: socket.
%
category: 'WebSockets'
method: GciLibraryApp
webSocket_gs

	request isWebSocketUpgrade ifFalse: [self error: 'Expected a WebSocket protocol!'].
	Log instance log: #'debug' string: 'GciApp>>webSocket_gs'.
	self
		wsWithBinaryDo: [:aByteArray | ]
		withTextDo: [:unicode |
			self handleRequestString: unicode.
		].
%
