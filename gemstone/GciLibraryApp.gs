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
oopIn: args at: aString

	^Integer fromHexString: (args at: aString).
%
category: 'Utilities'
method: GciLibraryApp
oopResultFrom: result error: error

	^self resultFrom: (result printStringRadix: 16 showRadix: false) error: error
%
category: 'Utilities'
method: GciLibraryApp
resultFrom: result error: error

	error number ~~ 0 ifTrue: [
		^Dictionary new
			at: 'error' put: error number;
			at: 'message' put: error message;
			yourself
	].
	^Dictionary new
		at: 'result' put: result;
		yourself
%
category: 'Utilities'
method: GciLibraryApp
sessionFrom: args

	| bytes |
	bytes := (CByteArray gcMalloc: 8)
		int64At: 0 put: (Integer fromHexString: (args at: 'session'));
		yourself.
	^bytes pointerAt: 0 resultClass: CPointer.
%

! -- GciTs API
category: 'GciTs API'
method: GciLibraryApp
abort: args

	| error result session |
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library GciTsAbort_: session _: error.
	^self resultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
begin: args

	| error result session |
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library GciTsBegin_: session _: error.
	^self resultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
break: args

	| error hardBreakFlag result session |
	error := GciErrSType new.
	hardBreakFlag := (args at: 'isHard') ifTrue: [1] ifFalse: [0].
	session := self sessionFrom: args.
	result := self library GciTsBreak_: session _: hardBreakFlag _: error.
	^self resultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
charToOop: args

	| result |
	result := self library GciTsCharToOop_: (args at: 'char').
	result := result printStringRadix: 16 showRadix: false.
	^self resultFrom: result error: GciErrSType new
%
category: 'GciTs API'
method: GciLibraryApp
commit: args

	| error result session |
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library GciTsCommit_: session _: error.
	^self resultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
doubleToOop: args

	| error result session |
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library GciTsDoubleToOop_: session _: (args at: 'double') _: error.
	result := result printStringRadix: 16 showRadix: false.
	^self resultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
doubleToSmallDouble: args

	| result |
	result := self library GciTsDoubleToSmallDouble_: (args at: 'double').
	result := result printStringRadix: 16 showRadix: false.
	^self resultFrom: result error: GciErrSType new
%
category: 'GciTs API'
method: GciLibraryApp
encrypt: args

	| buffer index result |
	buffer := CByteArray gcMalloc: 64.
	result := self library GciTsEncrypt_: (args at: 'password') _: buffer _: buffer size.
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
fetchSpecialClass: args

	| result |
	result := self library GciTsFetchSpecialClass_: (Integer fromHexString: (args at: 'oop')).
	result := result printStringRadix: 16 showRadix: false.
	^self resultFrom: result error: GciErrSType new
%
set compile_env: 0
category: 'GciTs API'
method: GciLibraryApp
getGciVersion: aDict

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
i32ToOop: args

	| result |
	result := self library GciI32ToOop_: (args at: 'int').
	result := result printStringRadix: 16 showRadix: false.
	^self resultFrom: result error: GciErrSType new
%
category: 'GciTs API'
method: GciLibraryApp
i64ToOop: args

	| error result session |
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library
		GciTsI64ToOop_: session
		_: (Integer fromHexString: (args at: 'i64'))
		_: error.
	result := result printStringRadix: 16 showRadix: false.
	^self resultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
login: args
	"GciTsLogin_: StoneNameNrs _: HostUserId _: HostPassword _: hostPwIsEncrypted _: GemServiceNrs
		_: gemstoneUsername _: gemstonePassword _: loginFlags _: haltOnErrNum _: executedSessionInit _: err
	$GEMSTONE/include/gcits.hf line 72
		GciSession GciTsLogin(  const char *StoneNameNrs,  const char *HostUserId,  const char *HostPassword,
			BoolType hostPwIsEncrypted,  const char *GemServiceNrs,  const char *gemstoneUsername,
			const char *gemstonePassword,  unsigned int loginFlags ,  int haltOnErrNum,  BoolType *executedSessionInit,
			GciErrSType *err) ;

	Interpreted as #ptr from #( #'const char*' #'const char*' #'const char*' #'int32' #'const char*' #'const char*' #'const char*' #'uint32' #'int32' #'ptr' #'ptr' )	"
	| error initFlag result |
	error := GciErrSType new.
	initFlag := CByteArray gcMalloc: 8.
	result := self library
		GciTsLogin_: GsNetworkResourceString defaultStoneNRSFromCurrent printString
		_: nil "HostUserId"
		_: nil "HostPassword"
		_: 0 "hostPwIsEncrypted"
		_: GsNetworkResourceString defaultGemNRSFromCurrent printString
		_: (args at: 'username' ifAbsent: ['username'])
		_: (args at: 'password' ifAbsent: ['password'])
		_: 0	"flags"
		_: 0	"haltOnErrNum"
		_: initFlag
		_: error.
	result := result ifNil: [nil] ifNotNil: [result memoryAddress].
	result := result printStringRadix: 16 showRadix: false.
	^self resultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
logout: args

	| error result session |
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library GciTsLogout_: session _: error.
	^self resultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
nbResult: args

	| error flag requestSocket result session timeout |
	error := GciErrSType new.
	session := self sessionFrom: args.
	requestSocket := GsSocket fromFileHandle: (args at: 'socket').
	timeout := args at: 'timeout' ifAbsent: [0].
	flag := requestSocket readWillNotBlockWithin: timeout.
	GsFile stdout lf; nextPutAll: 'readWillNotBlock = ' , flag printString; lf.
	flag ifTrue: [
		result := self library GciTsNbResult_: session _: error.
	].
	GsFile stdout nextPutAll: 'result = ' , result printString; lf.
	^self resultFrom: result error: GciErrSType new
%
category: 'GciTs API'
method: GciLibraryApp
oopIsSpecial: args

	| result |
	result := self library GciTsOopIsSpecial_: (Integer fromHexString: (args at: 'oop')).
	^self resultFrom: result == 1 error: GciErrSType new
%
category: 'GciTs API'
method: GciLibraryApp
oopToChar: args

	| result |
	result := self library GciTsOopToChar_: (Integer fromHexString: (args at: 'oop')).
	^self resultFrom: result error: GciErrSType new
%
category: 'GciTs API'
method: GciLibraryApp
oopToDouble: args

	| buffer error result session |
	buffer := CByteArray gcMalloc: 8.
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library
		GciTsOopToDouble_: session
		_: (Integer fromHexString: (args at: 'oop'))
		_: buffer
		_: error.
	result == 1 ifTrue: [
		result := buffer doubleAt: 0.
	].
	^self resultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
oopToI64: args
	"https://kermit.gemtalksystems.com/bug?bug=49654"

	| buffer error result session |
	buffer := CByteArray gcMalloc: 8.
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library
		GciTsOopToDouble_: session
		_: (Integer fromHexString: (args at: 'oop'))
		_: buffer
		_: error.
	result == 1 ifTrue: [
		result := buffer int64At: 0.
	].
	^self oopResultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
resolveSymbol: args

	| error result session |
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library
		GciTsResolveSymbol_: session
		_: (args at: 'symbol')
		_: (Integer fromHexString: (args at: 'symbolList' ifAbsent: '14'))
		_: error.
	^self oopResultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
resolveSymbolObj: args

	| error result session |
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library
		GciTsResolveSymbolObj_: session
		_: 117394689 "(Integer fromHexString: (args at: 'oop'))"
		_: (Integer fromHexString: (args at: 'symbolList' ifAbsent: '14'))
		_: error.
	^self oopResultFrom: result error: error
%
category: 'GciTs API'
method: GciLibraryApp
sessionIsRemote: args

	| result session |
	session := self sessionFrom: args.
	result := self library GciTsSessionIsRemote_: session.
	^self resultFrom: result error: GciErrSType new
%
category: 'GciTs API'
method: GciLibraryApp
socket: args

	| error result session |
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library GciTsSocket_: session _: error.
	^self resultFrom: result error: GciErrSType new
%

! -- WebSocket
category: 'WebSockets'
method: GciLibraryApp
handleRequest: aDict

	| command |
	command := aDict at: 'request'.
	command = 'abort' ifTrue: [^self abort: aDict].
	command = 'begin' ifTrue: [^self begin: aDict].
	command = 'break' ifTrue: [^self break: aDict].
	command = 'charToOop' ifTrue: [^self charToOop: aDict].
	command = 'commit' ifTrue: [^self commit: aDict].
	command = 'doubleToOop' ifTrue: [^self doubleToOop: aDict].
	command = 'doubleToSmallDouble' ifTrue: [^self doubleToSmallDouble: aDict].
	command = 'encrypt' ifTrue: [^self encrypt: aDict].
	command = 'fetchSpecialClass' ifTrue: [^self fetchSpecialClass: aDict].
	command = 'getGciVersion' ifTrue: [^self getGciVersion: aDict].
	command = 'i32ToOop' ifTrue: [^self i32ToOop: aDict].
	command = 'i64ToOop' ifTrue: [^self i64ToOop: aDict].
	command = 'login' ifTrue: [^self login: aDict].
	command = 'logout' ifTrue: [^self logout: aDict].
	command = 'nbResult' ifTrue: [^self nbResult: aDict].
	command = 'oopIsSpecial' ifTrue: [^self oopIsSpecial: aDict].
	command = 'oopToChar' ifTrue: [^self oopToChar: aDict].
	command = 'oopToDouble' ifTrue: [^self oopToDouble: aDict].
	command = 'oopToI64' ifTrue: [^self oopToI64: aDict].
	command = 'resolveSymbol' ifTrue: [^self resolveSymbol: aDict].
	command = 'resolveSymbolObj' ifTrue: [^self resolveSymbolObj: aDict].
	command = 'sessionIsRemote' ifTrue: [^self sessionIsRemote: aDict].
	command = 'socket' ifTrue: [^self socket: aDict].
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
