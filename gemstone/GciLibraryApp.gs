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
category: 'REST API'
method: GciLibraryApp
callInProgress_gs: args

	self setSessionFromArgs: args.
	^Dictionary new
		at: 'result' put: self library GciCallInProgress == 1;
		yourself
%
category: 'REST API'
method: GciLibraryApp
getError_gs: args

	| dict flag gciError |
	gciError := GciErrSType new.
	dict := Dictionary new.
	(self library GciErr_: gciError) == 0 ifTrue: [^dict].
	^dict
		at: 'category' put: gciError category;
		at: 'context' put: gciError context;
		at: 'exceptionObj' put: gciError exceptionObj;
		at: 'args' put: gciError args;
		at: 'number' put: gciError number;
		at: 'argCount' put: gciError argCount;
		at: 'fatal' put: gciError fatal;
		at: 'message' put: gciError message;
		at: 'reason' put: gciError reason;
		yourself.
%
category: 'REST API'
method: GciLibraryApp
getSessionId_gs: args

	^Dictionary new
		at: 'result' put: (self library GciGetSessionId);
		yourself.
%
category: 'REST API'
method: GciLibraryApp
logout_gs: args

	GsFile stdoutServer nextPutAll: 'logout - ' , args printString; cr.
	self setSessionFromArgs: args.
	self library GciLogout.
	^Dictionary new
%
category: 'REST API'
method: GciLibraryApp
nbEnd_gs: args

	| progress result |
	result := CByteArray gcMalloc: 8.
	self setSessionFromArgs: args.
	progress := self library GciNbEnd__: result.
	^Dictionary new
		at: 'progress' put: progress;
		at: 'result' put: (result int64At: 0);
		yourself
%
category: 'REST API'
method: GciLibraryApp
nbExecuteStr_gs: args

	self library
		GciNbExecuteStr_: (args at: 'source' ifAbsent: [''])
		_: 16r14. 	"OOP_NIL"
	^Dictionary new
%
category: 'REST API'
method: GciLibraryApp
setSessionFromArgs: args

	(args at: 'session' ifAbsent: [nil]) ifNotNil: [:session |
		self library GciSetSessionId_: session.
	].
%

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
		int64At: 0 put: (args at: 'session');
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
commit: args

	| error result session |
	error := GciErrSType new.
	session := self sessionFrom: args.
	result := self library GciTsCommit_: session _: error.
	^self resultFrom: result error: error
%
set compile_env: 0
category: 'GciTs API'
method: GciLibraryApp
getGciVersion: aDict

	| buffer index product version |
	buffer := CByteArray gcMalloc: 128.
	product := self library GciTsVersion_: buffer _: buffer size.
	version := buffer stringFrom: 0 to: 127.
	index := version indexOf: (Character codePoint: 0).
	version := version copyFrom: 1 to: index - 1.
	^Dictionary new
		at: 'product' put: product;
		at: 'version' put: version;
		yourself
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

! -- WebSocket
category: 'WebSockets'
method: GciLibraryApp
handleRequest: aDict

	| command |
	command := aDict at: 'request'.
	command = 'abort' ifTrue: [^self abort: aDict].
	command = 'begin' ifTrue: [^self begin: aDict].
	command = 'break' ifTrue: [^self break: aDict].
	command = 'commit' ifTrue: [^self commit: aDict].
	command = 'getGciVersion' ifTrue: [^self getGciVersion: aDict].
	command = 'login' ifTrue: [^self login: aDict].
	command = 'logout' ifTrue: [^self logout: aDict].
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
