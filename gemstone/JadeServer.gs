! ------------------- Remove existing behavior from JadeServer
removeAllMethods JadeServer
removeAllClassMethods JadeServer
! ------------------- Class methods for JadeServer
set compile_env: 0
category: 'other'
classmethod: JadeServer
listenOnPort: anInteger

	^self basicNew
		listenOnPort: anInteger;
		yourself
%
category: 'other'
classmethod: JadeServer
new

	self error: 'call #listenOnPort: or #serveOnSocket: instead'.
%
category: 'other'
classmethod: JadeServer
serveOnSocket: aSocket

	^self basicNew
		serveOnSocket: aSocket;
		yourself
%
! ------------------- Instance methods for JadeServer
set compile_env: 0
category: 'listen'
method: JadeServer
initializeSecureSocket

	| password |
	password := GsSecureSocket getPasswordFromFile: '$GEMSTONE/examples/openssl/private/server_1_server_passwd.txt'.
	GsSecureSocket
		useServerCertificateFile: '$GEMSTONE/examples/openssl/certs/server_1_servercert.pem'
		withPrivateKeyFile: '$GEMSTONE/examples/openssl/private/server_1_serverkey.pem'
		privateKeyPassphrase: password.

	"Don't request a certificate from the client. This is typical."
	GsSecureSocket disableCertificateVerificationOnServer.

	"Use all ciphers except NULL ciphers and anonymous Diffie-Hellman and sort by strength."
	GsSecureSocket setServerCipherListFromString: 'ALL:!ADH:@STRENGTH'.

	GsSocket closeAll.	"debugging could have left some open sockets"
%
category: 'listen'
method: JadeServer
initializeStackCapture

	System 		"some extra overhead, but we want to get exception stacks"
		gemConfigurationAt: #GemExceptionSignalCapturesStack
		put: true.
%
category: 'listen'
method: JadeServer
listenOnPort: anInteger

	self 
		initializeSecureSocket;
		initializeStackCapture;
		yourself.
	socket := GsSecureSocket newServer.
	(socket makeServerAtPort: anInteger) ~~ socket ifTrue: [
		| string |
		string := socket lastErrorString.
		socket close.
		self error: string.
	].
	socket port == anInteger ifFalse: [self error: 'Asked for port ' , anInteger printString , ' but got ' , socket port printString].
	self mainLoop.
%
category: 'listen'
method: JadeServer
mainLoop

	| string |
	[true] whileTrue: [
		(socket readWillNotBlockWithin: 60000) ifTrue: [
			socket accept ifNil: [
				string := socket lastErrorString.
				socket close.
				SocketError signal: 'Accept failed: ' , string.
			] ifNotNil: [:newSocket |
				[
					newSocket secureAccept.
					newSocket isConnected 
						ifTrue: [self class serveOnSocket: newSocket]
						ifFalse: [newSocket close].
				] on: SocketError do: [:ex |
					string := ex description.
					newSocket close.
					socket close.
					SocketError signal: 'Accept failed: ' , string.
				].
			].
		].
		System commitTransaction.
	].
%
set compile_env: 0
category: 'other'
method: JadeServer
handleRequest

	response at: 'foo' put: 'bar'.
%
category: 'other'
method: JadeServer
read: anInteger as: aClass

	| bytes index |
	bytes := aClass new: anInteger.
	index := 1.
	[index <= anInteger] whileTrue: [
		(socket readWillNotBlockWithin: 1000) ifFalse: [
			self error: 'Unable to read ' , anInteger printString , ' bytes!'.
		].
		index := index + (socket read: 1 into: bytes startingAt: index).
	].
	^bytes
%
category: 'other'
method: JadeServer
readRequest

	| bytes size |
	bytes := self read: 1 as: ByteArray.
	(bytes at: 1) == 1 ifFalse: [self error: 'Expected first byte to be "1" to designate version!'].
	bytes := self read: 4 as: ByteArray.
	size := bytes unsigned32At: 1.
	size == 0 ifTrue: [self error: 'Expected a non-zero payload size!'].
	bytes := self read: size as: Utf8.
	request := JsonParser parse: bytes decodeToString.
%
category: 'other'
method: JadeServer
serveOnSocket

	response := Dictionary new.
	self 
		readRequest;
		handleRequest;
		writeResponse;
		yourself.
%
category: 'other'
method: JadeServer
serveOnSocket: aSocket

	socket := aSocket.
	[self serveOnSocketWithErrorHandling] value.
%
category: 'other'
method: JadeServer
serveOnSocketWithErrorHandling

	[
		[
			self serveOnSocket.
		] on: Error do: [:ex1 | 
			| string |
self halt.
			string := DateAndTime now printStringWithRoundedSeconds ,
				' - ' , ex1 printString , Character lf , 
				(GsProcess stackReportToLevel: 50).
			GsFile gciLogServer: string.	"stdout for linked topaz"
			[
				socket writeWillNotBlock ifTrue: [
					socket write: (ByteArray new: 1).		" '\0' indicates an error message followed by a disconnect "
					socket write: string.
				].
			] on: Error do: [:ex2 | ex2 return].
		].
	] ensure: [
		socket close.
	].
%
category: 'other'
method: JadeServer
writeResponse

	| bytes |
	response := response asJson encodeAsUTF8.
	bytes := (ByteArray new: 5)
		at: 1 put: 1;
		unsigned32At: 2 put: response size;
		yourself.
	socket 
		write: bytes;
		write: response;
		yourself.
%
