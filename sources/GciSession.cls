﻿"Filed out from Dolphin Smalltalk"!

Object subclass: #GciSession
	instanceVariableNames: 'briefDescription clientForwarders eventCount gciSessionId gemHost gemNRS heartbeatProcess isAutoCommit isAutoMigrate isHandlingClientForwarderSend isNativeCode isPackagePolicyEnabled isShowUnimplementedMessages library netPort netTask oopsToRelease server serverClass stoneHost stoneName stoneNRS stoneSerial stoneSessionID userID'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GciSession guid: (GUID fromString: '{c52a3e3c-b7f3-4c3c-ab3d-a925ecb8b114}')!

GciSession comment: 'Permitted calls from within a non-blocking call:

GciCallInProgress
GciErr
GciGetSessionId
GciHardBreak
GciNbEnd
GciSetSessionId
GciShutdown
GciSoftBreak'!

!GciSession categoriesForClass!Unclassified! !

!GciSession methodsFor!

_executeString: aString fromContextOop: anOopType environment: anInteger

	^library 
		session: gciSessionId
		execute: (self encode: aString)
		context: anOopType
		environment: anInteger
!

_send: aSymbol to: anObject withAll: anArray

	| arguments oops result |
	oops := OrderedCollection new.
	arguments := anArray collect: [:each | 
		(each isKindOf: Integer) ifTrue: [self oopForInteger: each] ifFalse: [
		(each isKindOf: String) ifTrue: [oops add: (self oopForString: each)] ifFalse: [
		each]].
	].
	[
		[
			result := library 
				session: gciSessionId
				send: aSymbol 
				to: (self oopTypeFor: anObject)
				with: (self serverArrayFor: arguments).
		] on: GsRuntimeError do: [:ex | 
			ex errorReport number == 2106 ifTrue: [
				Error signal: oops printString , '; ' , ex description.
			] ifFalse: [
				ex pass.
			].
		].
	] ensure: [
		self releaseOops: oops.
	].
	^result.
!

_server

	^server.
!

abort

	self serverPerform: #'abort'.
!

addRangeStopTo: stepPoints withSource: source

	GsMethod addRangeStopTo: stepPoints withSource: source.!

attemptSocket
	"default is to do nothing"!

begin

	self serverPerform: #'beginTransaction'.
!

beInvalidSession

	gciSessionId := nil.
	library := nil.
!

briefDescription

	briefDescription ifNil: [
		| stream |
		stream := WriteStream on: String new.
		stream 
			nextPutAll: userID;
			nextPutAll: ' as session ';
			yourself.
		stoneSessionID printOn: stream.
		stream 
			nextPutAll: ' in ';
			nextPutAll: stoneName;
			nextPutAll: ' on ';
			nextPutAll: stoneHost;
			yourself.
		self isRemoteGem ifTrue: [
			stream
				nextPutAll: ' with remote gem on ';
				nextPutAll: gemHost;
				yourself.
		] ifFalse: [
			stream nextPutAll: ' with linked gem'. 
		].
		briefDescription := stream contents.
	].
	^briefDescription.
!

clearStack: anOopType

	library
		session: gciSessionId
		clearStack: anOopType.

!

clientForwardError: gciErrSType

	[
		| receiver selector args |
		isHandlingClientForwarderSend := true.
		receiver := self valueOfOop: (gciErrSType args at: 2).
		selector := self valueOfOop: (gciErrSType args at: 3).
		args := self valueOfArrayOop: (gciErrSType args at: 4).
		(receiver isNil or: [self clientForwarders size < receiver]) ifTrue: [^self oopNil].
		receiver := self clientForwarders at: receiver.
		SessionManager inputState pumpMessages.	"This seems to be necessary to allow #withExplanation:doA: to properly keep in synch."
		^receiver
			perform: selector
			withArguments: args.
	] ensure: [
		isHandlingClientForwarderSend := false.
	].
!

clientForwarders

	clientForwarders isNil ifTrue: [clientForwarders := OrderedCollection with: self].
	^clientForwarders.
!

commit

	^self serverPerform: #'commit'.
!

debugString: aString fromContext: anObject environment: anInteger
	"https://github.com/jgfoster/Jade/issues/122"

	^self
		serverPerformInterpreted: #'debugString:fromContext:environment:' 
		with: (self encode: aString)
		with: anObject 
		with: anInteger.
!

debugToFilePath: aString

	^library gciDbgEstablishToFile: aString
!

decode: aString
	"asAnsiString before 3.3.0; asUtf8String from 3.3.0 on."

	^aString asAnsiString!

encode: aString
	"asAnsiString before 3.3.0; asUtf8String from 3.3.0 on."

	^aString asAnsiString!

evaluate: aBlock
	"Here we make the call and handle any error."

	| result error |
	result := self evaluateA: aBlock.
	self incrementEventCount.
	(result isKindOf: GsError) ifFalse: [^result].

	error := result.
	JadeLog log: error description.
	result := error signal.
	result = #'resume' ifFalse: [self error: 'Unrecognized response of ' , result printString].
	^self evaluate: [
		library
			session: gciSessionId
			continue: error errorReport contextOop.
	]
!

evaluateA: aBlock

	| result shell waitFlag |
	shell := View active.
	shell disable.
	waitFlag := true.
	[
		[
			[
				result := self handlingClientForwarderSendDo: aBlock.
			] ensure: [
				waitFlag := false.
			].
		] on: Error do: [:ex | 
			result := ex.
			ex return: nil.
		].
	] newProcess name: 'GciSession>>withExplanation:doB: - 1'; resume.
	"waiting would be better done with a Semaphore, but we need to run the input loop anyway"
	SessionManager inputState loopWhile: [waitFlag].
	shell enable.
	((result isKindOf: Error) and: [(result isKindOf: GciError) not and: [(result isKindOf: GsError) not]]) ifTrue: [
		self error: result description.	"We want the error to be in the active process"
	].
	^result.
!

eventCount

	^eventCount.
!

executeString: aString

	^self
		executeString: aString
		fromContext: nil
		environment: 0.
!

executeString: aString fromContext: anObject environment: anInteger

	^server ifNil: [
		self evaluate: [
			self
				_executeString: aString
				fromContextOop: (self oopTypeFor: anObject)
				environment: anInteger.
		].
	] ifNotNil: [
		self
			serverPerform: #'executeString:fromContext:environment:'
			with: aString
			with: (self oopTypeFor: anObject)
			with: anInteger.
	].
!

fetchBytes: anOopType

	^library 
		session: gciSessionId
		fetchBytes: anOopType 
!

forceLogout

	self
		stopHeartbeat;
		hardBreak;
		logout;
		yourself.

!

gciSessionId

	^gciSessionId
!

gciVersion

	library ifNil: [^nil].
	^library version.
!

gemHost
	^gemHost!

gsHasPragmas

	^false!

handlingClientForwarderSendDo: aBlock

	| block result continueWith |
	block := aBlock.
	[
		result := self returningResultOrErrorDo: block.
		result isKindOf: GsClientForwarderSend.
	] whileTrue: [
		continueWith := self oopTypeFor: result signal.
		block := [
			library
				session: gciSessionId
				continue: result errorReport contextOop
				withObject: continueWith.
		].
	].
	^result.
!

hardBreak

	library ifNil: [^self].
	library hardBreakSession: gciSessionId.
!

hasHeartbeat

	^heartbeatProcess notNil!

hasServer

	^server notNil.
!

heartbeat: receiver arguments: arguments

	| result |
	(Delay forSeconds: 60) wait.
	self isValidSession ifFalse: [^self].
	result := self returningResultOrErrorDo: [
		library 
			session: gciSessionId
			send: #'heartbeat' 
			to: receiver
			with: arguments.
	].
	[
		result isKindOf: GciError.
	] whileTrue: [
		| error |
		error := result.
		result := GsError 
			signalGCI: self
			gciErrSType: error tag.
		result = #'resume' ifFalse: [self error: 'Unrecognized response of ' , result printString].
		result := self returningResultOrErrorDo: [
			library
				session: gciSessionId
				continue: error tag contextOop.
		].
	].
	(result isKindOf: Error) ifTrue: [^self].	"We are just going to ignore any errors!!"
	(result isKindOf: OopType64) ifTrue: [^self].
	0 < result ifTrue: [self idleWarning].

!

idleWarning

	| response |
	response := ProgressDialog
		showModalWhile: [:progress | 
			1 to: 300 do: [:i | 
				progress 
					caption: 'Idle Session Warning';
					value: i / 3; 
					text: 'To avoid an excessive commit record backlog, ' , 
						'this session will abort in ' , (300 - i) displayString, ' seconds...';
					yourself.
				Processor sleep: 1000.
			].
			true.
		].
	response ifNil: [		"cancel"
		(Delay forSeconds: 60) wait.
	] ifNotNil: [		"timeo0ut"
		self abort.
		[MessageBox warning: 'To avoid an excessive commit record backlog your session has been aborted.' caption: 'Idle session lost data!!'] fork.
	].
!

incrementEventCount
	"Without a GC, we get a very strange stack corruption!!"

	(eventCount := eventCount + 1) \\ 1000 == 0 ifTrue: [MemoryManager current collectGarbage; compact].

"
MemoryManager current collectGarbage; compact.
1 to: 10000 do: [:i |
	| semaphore |
	semaphore := Semaphore new.
	[
		(Delay forMilliseconds: 1) wait.
		semaphore signal.
	] fork.
	semaphore wait.
	i \\ 1000 == 0 ifTrue: [MemoryManager current collectGarbage; compact].
].
"
!

indexOfClientForwarder: anObject
	"Each server ClientForwarder instance has a 'clientObject' instance variable that is a SmallInteger 
	representing the receiver of the server's message. Some hard-coded values:
		1 - self (to handle OBConfirmationRequest)
		2 - Transcript
		3 - GsProfStef
	"

	^self clientForwarders 
		indexOf: anObject
		ifAbsent: [clientForwarders add: anObject. clientForwarders size].
!

initializeLibrary: libraryClass 
stoneNRS: stoneString 
gemNRS: gemString 
userID: gsUserID 
password: gsPassword 
hostUserID: hostUserID 
password: hostPassword 
initials: initials
debugPath: debugPath

	| list |
	isAutoCommit := false.
	isAutoMigrate := false.
	isHandlingClientForwarderSend := false.
	isNativeCode := true.
	isShowUnimplementedMessages := true.
	eventCount := 0.
	stoneNRS := stoneString.
	gemNRS := gemString.
	userID := gsUserID.
	list := stoneNRS subStrings: $!!.
	stoneName := list at: 3.
	list := (list at: 2) subStrings: $#.
	list := (list at: 1) subStrings: $@.
	stoneHost := list at: 2.
	self isLinkedGem ifFalse: [
		list := gemNRS subStrings: $#.
		netPort := ((list at: 2) subStrings: $:) at: 2.
		netTask := ((list at: 3) subStrings: $!!) at: 2.
		gemHost := ((list at: 1) subStrings: $@) at: 2.
	].
	oopsToRelease := IdentitySet new.
	self 
		loadLibrary: libraryClass 
		debugPath: debugPath.
	gciSessionId := library
		loginHostUser: hostUserID 
		hostPassword: hostPassword 
		gsUser: gsUserID 
		gsPassword: gsPassword 
		gemNRS: gemNRS 
		stoneNRS: stoneNRS.
	self postLoginAs: initials.
!

initializeServer
"
	GciSession allInstances first initializeServer.
"
	| crlf jadeServerClassOop |
	crlf := Character cr asString , Character lf asString.
	library ifNil: [^self].
	[
		jadeServerClassOop := library session: gciSessionId resolveSymbol: serverClass name.
		jadeServerClassOop isOopIllegal ifFalse: [
			| version |
			server := self send: #'new' to: jadeServerClassOop.
			self send: #'initialize' to: server.
			version := self send: #'version' to: server.
			version = self jadeSessionManagerClass version ifTrue: [^self].
			(MessageBox confirm: 'Use built-in JadeServer version ' , version , '?') ifTrue: [^self].
		].
	] on: Error do: [:ex | 
		MessageBox notify: 'Unable to use built-in JadeServer due to error:' , crlf , ex description.
	].
	[
		| string |
		string := self encode: serverClass gsString.
		server := self executeString: string.
	] on: GsRuntimeError do: [:ex | 
		| number notes |
		number := ex errorReport number.
		notes := ''.
		number = 2151 ifTrue: [notes := ' (code modification?)'].
		self logout.
		GciLoginFailed
			signal: 'JadeServer could not be installed:
' , ex description , notes
			with: self.
	].

	((server isKindOf: String) or: [server isKindOf: ByteArray]) ifTrue: [
		self logout.
		GciLoginFailed
			signal: 'JadeServer compile error:
' , server asAnsiString
			with: self.
	].
	self send: #'initialize' to: server.
	1 ~~ 1 ifTrue: [		"messasges that are sent by a ClientForwarderSend should not be stripped"
		self 
			signalConfirmationRequestUsing: nil;
			signalInformRequestUsing: nil;
			signalMultiLineTextRequestUsing: nil;
			signalTextRequestUsing: nil;
			message: 'messageString' caption: 'captionString' icon: 'alertSymbol' buttons: 'buttonsSymbol';
			prompt: 'promptString' caption: 'captionString';
			yourself.
	].
!

isAutoCommit

	^isAutoCommit
!

isAutoCommit: aBoolean

	isAutoCommit == aBoolean ifTrue: [^self].
	self error: 'Auto-commit is not yet supported (see https://github.com/jgfoster/Jade/issues/8)'.
	isAutoCommit := aBoolean.
!

isAutoMigrate

	^isAutoMigrate
!

isAutoMigrate: aBoolean

	isAutoMigrate == aBoolean ifTrue: [^self].
	self executeString: 'McPlatformSupport autoMigrate: ' , aBoolean printString.
	isAutoMigrate := true.
!

isLinkedGem

	^gemNRS isEmpty.
!

isNativeCode

	^isNativeCode!

isNativeCode: aBoolean

	isNativeCode == aBoolean ifTrue: [^self].
	self executeString: 'System configurationAt: #GemNativeCodeEnabled put: ' , aBoolean printString.
	isNativeCode := aBoolean.
!

isOopType: anObject

	^anObject isKindOf: library oopTypeClass.
!

isPackagePolicyEnabled

	^isPackagePolicyEnabled!

isRemoteGem

	^self isLinkedGem not.
!

isShowUnimplementedMessages

	^isShowUnimplementedMessages
!

isShowUnimplementedMessages: aBoolean

	isShowUnimplementedMessages == aBoolean ifTrue: [^self].
	self serverPerform: #'showUnimplementedMessages:' with: aBoolean.
	isShowUnimplementedMessages := aBoolean.
!

isValidSession

	^gciSessionId notNil
!

libraryVersion

	^library 
		ifNil: [nil]
		ifNotNil: [library class displayName].
!

loadLibrary: aClass debugPath: debugPath

	| others |
	others := self class allInstances collect: [:each | each libraryVersion].
	others := others asSet reject: [:each | each = aClass displayName].
	others isEmpty ifFalse: [self error: 'Unable to login to another version!!'].
	library := aClass open: aClass fileName.
	serverClass := library jadeServerClass.
	debugPath notEmpty ifTrue: [
		(self debugToFilePath: debugPath) ifFalse: [self error: 'Unable to open ' , debugPath printString , ' for GCI debugging'].
		library gciGemTrace: 3.
	].!

logout

	self stopHeartbeat.
	self trigger: #'logoutPending'.
	library ifNotNil: [
		library logoutSession: gciSessionId.
		library := nil.
	].
	[self trigger: #'logout'] on: Error do: [:ex | ex return].
	gciSessionId := nil.
!

logoutRequested

	| valueHolder |
	valueHolder := Association key: self value: true.
	self trigger: #'logoutRequested:' with: valueHolder.
	^valueHolder value.
!

message: messageString caption: captionString icon: alertSymbol buttons: buttonsSymbol

	^MessageBox new
		text: messageString;
		caption: captionString;
		iconStyle: alertSymbol asSymbol;
		buttonStyle: buttonsSymbol asSymbol;
		open
!

netPort
	^netPort!

netTask
	^netTask!

oopFalse

	^library oopFalse!

oopForInteger: anInteger 
	"Client-side for SmallInteger but server-side for LargeInteger"

	^library 
		session: gciSessionId 
		oopForInteger: anInteger
!

oopForString: aString

	| log oop |
	aString isNil ifTrue: [^self oopNil].
	oop := library session: gciSessionId oopForString: aString.
	log := 'Allocated oop ' , oop printString , ' for ' , (aString copyFrom: 1 to: (aString size min: 40)) printString.
	log := log copyReplacing: Character lf withObject: $\.
	JadeLog log: log.
	^oop!

oopGemStoneError

	^library oopGemStoneError.
!

oopIllegal

	^library oopIllegal.
!

oopNil

	^library oopNil!

oopTrue

	^library oopTrue!

oopTypeFor: anObject 

	anObject isNil 					ifTrue: [^self oopNil].
	(anObject isKindOf: ExternalInteger) 	ifTrue: [^anObject].
	(anObject isKindOf: Boolean) 			ifTrue: [^anObject ifTrue: [self oopTrue] ifFalse: [self oopFalse]].
	(anObject isKindOf: SmallInteger) 		ifTrue: [^self oopForInteger: anObject].
	(anObject isKindOf: GsObject) 		ifTrue: [^anObject oopType].
	(anObject isKindOf: String)			ifTrue: [^self oopForString: anObject].
	MessageBox notify: 'Sorry, we are not yet prepared to convert ' , anObject printString , ' to an OOP!!'.
	SessionManager current pause.
!

oopTypeWithOop: anInteger

	^library oopTypeWithOop: anInteger.
!

postLoginAs: aString 

	self 
		initializeServer;
		attemptSocket;
		setInitials: aString;		"This gets back the session and serial number and some preferences"
		startHeartbeat;
		yourself.!

printString: anOopType

	^self
		serverPerform: #'printStringOf:'
		with: anOopType.
!

prompt: promptString caption: captionString

	^Prompter 
		prompt: promptString
		caption: captionString
!

releaseOop: anOopType

	oopsToRelease add: anOopType.
	self releaseOopsInBackground.!

releaseOops: anArray

	oopsToRelease addAll: anArray.
	self releaseOopsInBackground.!

releaseOopsInBackground

	[
		| array |
		(Delay forSeconds: 5) wait.
		(library notNil and: [(array := oopsToRelease asArray) notEmpty]) ifTrue: [
			oopsToRelease removeAll.
			library session: gciSessionId releaseOops: array.
		].
	] forkAt: Processor userBackgroundPriority.
!

returningResultOrErrorDo: aBlock
	"Here we isolate the error handling so we can unwind the stack.
	We should never return/resume the exception, but instead make
	a new call such as GciContinue()"

	^[
		aBlock value.
	] on: GciError do: [:ex | 
		(SessionManager current class == DevelopmentSessionManager and: [ex tag number == 2106]) ifTrue: [self halt].
		ex return: (GsError forSession: self gciErrSType: ex tag).
	].
!

send: aSymbol to: anObject

	^self
		send: aSymbol
		to: anObject
		withAll: #().
!

send: aSymbol to: anObject withAll: anArray

	^self evaluate: [
		self
			_send: aSymbol 
			to: anObject 
			withAll: anArray.
	]
!

sendInterpreted: aSymbol to: anObject withAll: anArray

	| arguments |
	arguments := self serverArrayFor: anArray.
	^self evaluate: [
		library 
			session: gciSessionId
			send: aSymbol 
			to: (self oopTypeFor: anObject) 
			with: arguments.
	]
!

serverArrayFor: anArray

	| array |
	library ifNil: [GsInvalidSessionError signal].
	array := library oopTypeArrayClass new: anArray size.
	1 to: anArray size do: [:i | 
		array at: i put: (self oopTypeFor: (anArray at: i)).
	].
	^array.
!

serverClass

	^serverClass
!

serverPerform: aSymbol

	^self
		send: aSymbol
		to: server.
!

serverPerform: aSymbol with: anObject

	^self
		serverPerform: aSymbol 
		withArguments: (Array with: anObject).
!

serverPerform: aSymbol with: arg1 with: arg2

	^self
		serverPerform: aSymbol 
		withArguments: (Array
			with: arg1
			with: arg2).
!

serverPerform: aSymbol with: arg1 with: arg2 with: arg3

	^self
		serverPerform: aSymbol 
		withArguments: (Array
			with: arg1
			with: arg2
			with: arg3).
!

serverPerform: aSymbol with: arg1 with: arg2 with: arg3 with: arg4

	^self
		serverPerform: aSymbol 
		withArguments: (Array
			with: arg1
			with: arg2
			with: arg3
			with: arg4).
!

serverPerform: aSymbol withArguments: anArray

	| answer |
	server isNil ifTrue: [
		MessageBox notify: 'Unable to perform action due to server initialization failure.'.
		^self.
	].
	answer := self
		send: aSymbol
		to: server
		withAll: anArray.
	^answer.
!

serverPerformInterpreted: aSymbol with: arg1 with: arg2

	^self
		serverPerformInterpreted: aSymbol 
		withArguments: (Array
			with: arg1
			with: arg2).
!

serverPerformInterpreted: aSymbol with: arg1 with: arg2 with: arg3

	^self
		serverPerformInterpreted: aSymbol 
		withArguments: (Array
			with: arg1
			with: arg2
			with: arg3).
!

serverPerformInterpreted: aSymbol withArguments: anArray

	| answer |
	server isNil ifTrue: [
		MessageBox notify: 'Unable to perform action due to server initialization failure.'.
		^self.
	].
	answer := self
		sendInterpreted: aSymbol
		to: server
		withAll: anArray.
	^answer.
!

setInitials: initials

	| string |
	server isNil ifTrue: [^self].
	string := self
		serverPerform: #'mcInitials:' 
		with: (self encode: initials).
	self updatePreferencesFrom: string.
!

signalConfirmationRequestUsing: anOopType64 

	| string pieces answer |
	string := self 
		serverPerform: #'obConfirmationRequest:' 
		with: anOopType64.
	pieces := string subStrings: Character lf.
	string := (pieces at: 3) , ' (Yes = ' , (pieces at: 2) , '; No = ' , (pieces at: 1) , ')'.
	answer := MessageBox
		confirm: string 
		caption: 'Server Confirmation Request'.
	^answer ifTrue: [self oopTrue] ifFalse: [self oopFalse].
!

signalInformRequestUsing: anOopType64 

	| string |
	string := self 
		serverPerform: #'obInformRequest:' 
		with: anOopType64.
	MessageBox
		notify: string 
		caption: 'Server Inform Request'.
	^self oopNil
!

signalMultiLineTextRequestUsing: anOopType64 

	| string stream size prompt template answer oop |
	string := self 
		serverPerform: #'obTextRequest:' 
		with: anOopType64.
	stream := ReadStream on: string.
	size := stream nextLine asNumber.
	prompt := stream next: size.
	template := stream upToEnd.
	answer := Prompter
		on: template 
		prompt: prompt 
		caption: 'Server Text Request'.
	answer ifNil: [^self oopNil].
	oop := self oopForString: answer.
	[
		self releaseOop: oop.
	] forkAt: Processor userBackgroundPriority.
	^oop.
!

signalTextRequestUsing: anOopType64 

	| string stream size prompt template answer oop |
	string := self 
		serverPerform: #'obTextRequest:' 
		with: anOopType64.
	stream := ReadStream on: string.
	size := stream nextLine asNumber.
	prompt := stream next: size.
	template := stream upToEnd.
	answer := Prompter
		on: template 
		prompt: prompt 
		caption: 'Server Text Request'.
	answer ifNil: [^self oopNil].
	oop := self oopForString: answer.
	[
		self releaseOop: oop.
	] forkAt: Processor userBackgroundPriority.
	^oop.
!

softBreak

	library softBreakSession: gciSessionId.
!

startHeartbeat
		"Private - Every second execute something inexpensive on the server (a Delay) 
		so that background processes on the server get a chance to run."

	heartbeatProcess := [
		| receiver arguments |
		receiver := self oopTypeFor: server.
		arguments := self serverArrayFor: #().
		[self isValidSession] whileTrue: [self heartbeat: receiver arguments: arguments].
		heartbeatProcess := nil.
	] forkAt: Processor userBackgroundPriority.
!

stepInto: aGsProcess inFrame: anInteger

	self
		serverPerformInterpreted: #'step:inFrame:'
		with: aGsProcess
		with: 0.
!

stepOut: aGsProcess inFrame: anInteger

	self
		serverPerformInterpreted: #'step:inFrame:'
		with: aGsProcess
		with: anInteger.
!

stepOver: aGsProcess inFrame: anInteger

	self
		serverPerformInterpreted: #'step:inFrame:'
		with: aGsProcess
		with: anInteger.
!

stoneHost
	^stoneHost!

stoneName
	^stoneName!

stoneSerial

	^stoneSerial.
!

stoneSessionID

	^stoneSessionID.
!

stopHeartbeat

	heartbeatProcess notNil ifTrue: [
		heartbeatProcess terminate.
		heartbeatProcess := nil.
	].
!

terminate: anOopType

	[
		self serverPerform: #'terminate:' with: anOopType.
	] on: Error do: [:ex | ].
	TerminateProcess signal.!

titleBarFor: aString
"'Jade ' , gciSession gciSessionID printString , ' (' , gciSession userID , ') - "
	| stream list |
	list := stoneNRS subStrings: $!!.
	stoneName := list at: 3.
	list := (list at: 2) subStrings: $#.
	list := (list at: 1) subStrings: $@.
	stoneHost := list at: 2.
	stream := WriteStream on: String new.
	stream 
		nextPutAll: 'Jade ';
		print: gciSessionId;
		nextPutAll: ' (';
		nextPutAll: userID asAnsiString;
		nextPutAll: ') - ';
		nextPutAll: aString asAnsiString;
		nextPutAll: ' on ';
		nextPutAll: stoneName asAnsiString;
		nextPutAll: ' session ';
		print: stoneSessionID;
		nextPutAll: ' on ';
		nextPutAll: stoneHost asAnsiString;
		yourself.
	self isRemoteGem ifTrue: [
		list := gemNRS subStrings: $#.
		netPort := ((list at: 2) subStrings: $:) at: 2.
		netTask := ((list at: 3) subStrings: $!!) at: 2.
		gemHost := ((list at: 1) subStrings: $@) at: 2.
		stream
			nextPutAll: ' with remote gem on ';
			nextPutAll: gemHost asAnsiString;
			yourself.
	] ifFalse: [
		stream nextPutAll: ' with linked gem'. 
	].
	^stream contents.
!

updatePreferences

	| string |
	string := self serverPerform: #'preferences'.
	self updatePreferencesFrom: string.
!

updatePreferencesFrom: aString
	"See JadeServer>>_preferences for the generation of this string"

	| pieces x |
	pieces := (self decode: aString) subStrings: Character tab.
	stoneSessionID := (pieces at: 1) asNumber.
	stoneSerial := (pieces at: 2) asNumber.
	isPackagePolicyEnabled 			:= (pieces at: 3) = 'true'.
	isNativeCode				 	:= (x := pieces at: 4) = 'nil' ifTrue: [nil] ifFalse: [x = 'true'].
	isAutoMigrate					:= (x := pieces at: 5) = 'nil' ifTrue: [nil] ifFalse: [x = 'true'].
	isAutoCommit 					:= (x := pieces at: 6) = 'nil' ifTrue: [nil] ifFalse: [x = 'true'].
	isShowUnimplementedMessages	:= (x := pieces at: 7) = 'nil' ifTrue: [nil] ifFalse: [x = 'true'].!

userID

	^userID.
!

valueOfArrayOop: anOopType

	| array |
	anOopType isGsNil ifTrue: [^#()].
	array := library session: gciSessionId fetchObjects: anOopType.
	array := array collect: [:each | self valueOfOop: each].
	^array.
!

valueOfOop: anOopType

	^library session: gciSessionId valueOfOop: anOopType.
! !

!GciSession categoriesForMethods!
_executeString:fromContextOop:environment:!library-server!private! !
_send:to:withAll:!library-server!private! !
_server!private! !
abort!Jade convenience!public! !
addRangeStopTo:withSource:!accessing!public! !
attemptSocket!private! !
begin!Jade convenience!public! !
beInvalidSession!library-client!public! !
briefDescription!public! !
clearStack:!Jade!library-server!public! !
clientForwardError:!public! !
clientForwarders!public! !
commit!Jade convenience!public! !
debugString:fromContext:environment:!long running!public! !
debugToFilePath:!Jade convenience!library-client!public! !
decode:!public! !
encode:!public! !
evaluate:!library-server!long running!private! !
evaluateA:!long running!private! !
eventCount!public! !
executeString:!Jade convenience!public! !
executeString:fromContext:environment:!long running!public! !
fetchBytes:!library-server!private! !
forceLogout!Jade!public! !
gciSessionId!public! !
gciVersion!library-client!public! !
gemHost!accessing!public! !
gsHasPragmas!public! !
handlingClientForwarderSendDo:!library-server!long running!private! !
hardBreak!Jade!library-server!public! !
hasHeartbeat!heartbeat!public! !
hasServer!public! !
heartbeat:arguments:!heartbeat!library-server!private! !
idleWarning!heartbeat!private! !
incrementEventCount!long running!private! !
indexOfClientForwarder:!public! !
initializeLibrary:stoneNRS:gemNRS:userID:password:hostUserID:password:initials:debugPath:!library-server!private! !
initializeServer!library-server!private! !
isAutoCommit!accessing!public! !
isAutoCommit:!accessing!public! !
isAutoMigrate!accessing!public! !
isAutoMigrate:!accessing!public! !
isLinkedGem!public! !
isNativeCode!accessing!public! !
isNativeCode:!accessing!public! !
isOopType:!library-client!public! !
isPackagePolicyEnabled!public! !
isRemoteGem!public! !
isShowUnimplementedMessages!accessing!public! !
isShowUnimplementedMessages:!accessing!public! !
isValidSession!public! !
libraryVersion!library-client!public! !
loadLibrary:debugPath:!library-client!public! !
logout!Jade!library-server!public! !
logoutRequested!Jade!public! !
message:caption:icon:buttons:!OmniBrowser!public! !
netPort!accessing!public! !
netTask!accessing!public! !
oopFalse!library-oops!public! !
oopForInteger:!library-server!public! !
oopForString:!library-server!public! !
oopGemStoneError!library-client!public! !
oopIllegal!library-client!public! !
oopNil!library-oops!public! !
oopTrue!library-oops!public! !
oopTypeFor:!library-client!public! !
oopTypeWithOop:!library-client!public! !
postLoginAs:!private! !
printString:!Jade convenience!public! !
prompt:caption:!OmniBrowser!public! !
releaseOop:!Jade convenience!public! !
releaseOops:!Jade!library-server!public! !
releaseOopsInBackground!Jade!library-server!public! !
returningResultOrErrorDo:!long running!private! !
send:to:!Jade convenience!public! !
send:to:withAll:!Jade convenience!long running!public! !
sendInterpreted:to:withAll:!Jade convenience!library-server!long running!public! !
serverArrayFor:!Jade convenience!library-oops!public! !
serverClass!accessing!public! !
serverPerform:!Jade convenience!public! !
serverPerform:with:!Jade convenience!public! !
serverPerform:with:with:!Jade convenience!public! !
serverPerform:with:with:with:!Jade convenience!public! !
serverPerform:with:with:with:with:!Jade convenience!public! !
serverPerform:withArguments:!Jade convenience!public! !
serverPerformInterpreted:with:with:!Jade convenience!public! !
serverPerformInterpreted:with:with:with:!Jade convenience!public! !
serverPerformInterpreted:withArguments:!Jade convenience!public! !
setInitials:!private! !
signalConfirmationRequestUsing:!OmniBrowser!public! !
signalInformRequestUsing:!OmniBrowser!public! !
signalMultiLineTextRequestUsing:!OmniBrowser!public! !
signalTextRequestUsing:!OmniBrowser!public! !
softBreak!Jade!library-server!public! !
startHeartbeat!heartbeat!private! !
stepInto:inFrame:!public! !
stepOut:inFrame:!public! !
stepOver:inFrame:!public! !
stoneHost!accessing!public! !
stoneName!accessing!public! !
stoneSerial!private! !
stoneSessionID!public! !
stopHeartbeat!heartbeat!private! !
terminate:!public! !
titleBarFor:!public! !
updatePreferences!private! !
updatePreferencesFrom:!private! !
userID!public! !
valueOfArrayOop:!Jade convenience!library-server!public! !
valueOfOop:!Jade convenience!library-server!public! !
!

!GciSession class methodsFor!

libraryClass: libraryClass 
stoneNRS: stoneNRS 
gemNRS: gemNRS 
userID: gsUserID 
password: gsPassword 
hostUserID: hostUserID 
password: hostPassword 
initials: initials
debugPath: debugPath

	^super new
		initializeLibrary: libraryClass
		stoneNRS: stoneNRS 
		gemNRS: gemNRS 
		userID: gsUserID 
		password: gsPassword
		hostUserID: hostUserID 
		password: hostPassword
		initials: initials
		debugPath: debugPath

!

new

	self error: 'use other instance creation protocol'.
!

publishedEventsOfInstances
    	"Answer a Set of Symbols that describe the published events triggered
    	by instances of the receiver."
    
    	^super publishedEventsOfInstances
		add: #'logoutPending';
		add: #'logoutRequested:';
    		add: #'logout';
    		yourself.
    
! !

!GciSession class categoriesForMethods!
libraryClass:stoneNRS:gemNRS:userID:password:hostUserID:password:initials:debugPath:!public! !
new!public! !
publishedEventsOfInstances!public! !
!

