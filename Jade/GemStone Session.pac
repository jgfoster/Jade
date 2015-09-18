| package |
package := Package name: 'GemStone Session'.
package paxVersion: 1;
	basicComment: ''.

package basicPackageVersion: '0.237'.

package basicScriptAt: #postinstall put: '''Loaded: GemStone Session'' yourself.'.

package classNames
	add: #GciSession;
	add: #GciSessionWithSocket;
	add: #GsAnsiError;
	add: #GsApplicationError;
	add: #GsBreakDialog;
	add: #GsClientForwarderSend;
	add: #GsCompileError;
	add: #GsDoesNotUnderstand;
	add: #GsError;
	add: #GsEventError;
	add: #GsFatalError;
	add: #GsHaltError;
	add: #GsHardBreak;
	add: #GsInvalidSessionError;
	add: #GsPause;
	add: #GsRuntimeError;
	add: #GsSoftBreak;
	add: #GsStackBreakpoint;
	add: #GsTestFailure;
	add: #JadeServer;
	add: #JadeServer32bit;
	add: #JadeServer64bit;
	add: #JadeServer64bit24;
	add: #JadeServer64bit32;
	add: #JadeServer64bit33;
	add: #JadeServer64bit3x;
	add: #JadeServerTestCase;
	add: #TerminateProcess;
	yourself.

package methodNames
	add: #Gcilw6x -> #jadeServerClass;
	add: #LibGciRpc64 -> #jadeServerClass;
	add: #LibGciRpc64_30 -> #jadeServerClass;
	add: #LibGciRpc64_32 -> #jadeServerClass;
	add: #LibGciRpc64_33 -> #jadeServerClass;
	yourself.

package binaryGlobalNames: (Set new
	yourself).

package globalAliases: (Set new
	yourself).

package setPrerequisites: (IdentitySet new
	add: '..\Object Arts\Dolphin\Base\Dolphin';
	add: '..\Object Arts\Dolphin\MVP\Base\Dolphin MVP Base';
	add: '..\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Prompter';
	add: '..\Object Arts\Dolphin\MVP\Type Converters\Dolphin Type Converters';
	add: 'GemStone C Interface';
	add: 'GemStone Objects';
	add: '..\Object Arts\Dolphin\Sockets\Sockets Connection';
	add: '..\Camp Smalltalk\SUnit\SUnit';
	yourself).

package!

"Class Definitions"!

Object subclass: #GciSession
	instanceVariableNames: 'briefDescription clientForwarders eventCount gciSessionID gemHost gemNRS heartbeatProcess isHandlingClientForwarderSend library netPort netTask server stoneHost stoneName stoneNRS stoneSerial stoneSessionID userID'
	classVariableNames: 'GemCursor'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #JadeServer
	instanceVariableNames: 'classList classOrganizer readStream writeStream selectedClass methodFilterType methodFilters selections'
	classVariableNames: 'AllGroups AllUsers ClassOrganizer ClientForwarder GemStoneError Globals GsMethodDictionary ProcessorScheduler SymbolDictionary System UserGlobals UserProfile'
	poolDictionaries: ''
	classInstanceVariableNames: 'gsString'!
Error subclass: #GsError
	instanceVariableNames: 'gciErrSType gsProcess'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsError subclass: #GsAnsiError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsError subclass: #GsCompileError
	instanceVariableNames: 'list'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsError subclass: #GsEventError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsError subclass: #GsFatalError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsError subclass: #GsRuntimeError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsAnsiError subclass: #GsTestFailure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsEventError subclass: #GsClientForwarderSend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsEventError subclass: #GsHardBreak
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsEventError subclass: #GsPause
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsEventError subclass: #GsSoftBreak
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsEventError subclass: #GsStackBreakpoint
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsFatalError subclass: #GsInvalidSessionError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsRuntimeError subclass: #GsApplicationError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsRuntimeError subclass: #GsDoesNotUnderstand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GsApplicationError subclass: #GsHaltError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Notification subclass: #TerminateProcess
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GciSession subclass: #GciSessionWithSocket
	instanceVariableNames: 'socket'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeServer subclass: #JadeServer32bit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeServer subclass: #JadeServer64bit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeServer64bit subclass: #JadeServer64bit24
	instanceVariableNames: ''
	classVariableNames: 'Reflection'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeServer64bit24 subclass: #JadeServer64bit3x
	instanceVariableNames: 'environment'
	classVariableNames: 'Admonition ClientForwarderSend CompileError CompileWarning RubyHash SessionTemps Transcript'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeServer64bit3x subclass: #JadeServer64bit32
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeServer64bit32 subclass: #JadeServer64bit33
	instanceVariableNames: 'socket'
	classVariableNames: 'Breakpoint GsNMethod GsSocket'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ValueDialog subclass: #GsBreakDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestCase subclass: #JadeServerTestCase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

"Global Aliases"!


"Loose Methods"!

!Gcilw6x methodsFor!

jadeServerClass

	^JadeServer32bit
! !
!Gcilw6x categoriesFor: #jadeServerClass!public!Testing! !

!LibGciRpc64 methodsFor!

jadeServerClass

	^JadeServer64bit
! !
!LibGciRpc64 categoriesFor: #jadeServerClass!public!Testing! !

!LibGciRpc64_30 methodsFor!

jadeServerClass

	^JadeServer64bit3x
! !
!LibGciRpc64_30 categoriesFor: #jadeServerClass!public!Testing! !

!LibGciRpc64_32 methodsFor!

jadeServerClass

	^JadeServer64bit32
! !
!LibGciRpc64_32 categoriesFor: #jadeServerClass!public!Testing! !

!LibGciRpc64_33 methodsFor!

jadeServerClass

	^JadeServer64bit33
! !
!LibGciRpc64_33 categoriesFor: #jadeServerClass!public!Testing! !

"End of package definition"!

"Source Globals"!

"Classes"!

GciSession guid: (GUID fromString: '{C52A3E3C-B7F3-4C3C-AB3D-A925ECB8B114}')!
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

_continueProcess: aContextOop

	^library
		continue: aContextOop
		session: gciSessionID.
!

_executeString: aString fromContextOop: anOopType
	^library 
		executeString: aString
		fromContext: anOopType
		session: gciSessionID.
!

_library

	^library.
!

_send: aSymbol to: anObject withAll: anArray

	| arguments oops result time1 time2 |
	oops := OrderedCollection new.
	arguments := anArray collect: [:each | 
		(each isKindOf: Integer) ifTrue: [self oopForInteger: each] ifFalse: [
		(each isKindOf: String) ifTrue: [oops add: (self oopForString: each)] ifFalse: [
		each]].
	].
	result := library 
		send: aSymbol 
		to: (self oopTypeFor: anObject) 
		with: (self serverArrayFor: arguments)
		session: gciSessionID.
	self releaseOops: oops.
	^result.
!

_server

	^server.
!

abort

	self serverPerform: #'abort'.
!

attemptSocket

	| host port tempSocket time |
	host := ((gemNRS subStrings: $#) first subStrings: $@) at: 2.
	(port := self serverPerform: #'makeListener') ifNil: [^self].
	tempSocket := Socket port: port host: host.
	tempSocket connectNoWait.
	time := self serverPerform: #'acceptConnection'.
	time ifNil: [
		tempSocket close.
		^self.
	].
	^self become: (GciSessionWithSocket from: self withSocket: tempSocket).!

begin

	self serverPerform: #'beginTransaction'.
!

briefDescription

	briefDescription ifNil: [
		| stream list |
		stream := WriteStream on: String new.
		stream 
			nextPutAll: userID;
			nextPutAll: ' as session ';
			yourself.
		stoneSessionID printOn: stream.
		list := stoneNRS subStrings: $!!.
		stoneName := list at: 3.
		stream 
			nextPutAll: ' in ';
			nextPutAll: stoneName;
			yourself.
		list := (list at: 2) subStrings: $#.
		list := (list at: 1) subStrings: $@.
		stoneHost := list at: 2.
		stream
			nextPutAll: ' on ';
			nextPutAll: stoneHost;
			yourself.
		self isRemoteGem ifTrue: [
			list := gemNRS subStrings: $#.
			netPort := ((list at: 2) subStrings: $:) at: 2.
			netTask := ((list at: 3) subStrings: $!!) at: 2.
			gemHost := ((list at: 1) subStrings: $@) at: 2.
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
		clearStack: anOopType 
		session: gciSessionID.
!

clientForwardError: gciErrSType

	[
		| receiver selector args |
		isHandlingClientForwarderSend := true.
		receiver := self valueOfOop: (gciErrSType args at: 2).
		receiver := (receiver notNil and: [receiver <= self clientForwarders size])
			ifTrue: [self clientForwarders at: receiver]
			ifFalse: [Transcript].
		selector := self valueOfOop: (gciErrSType args at: 3).
		args := self valueOfArrayOop: (gciErrSType args at: 4).
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

debugToFilePath: aString

	^library gciDbgEstablishToFile: aString
!

eventCount

	^eventCount.
!

executeString: aString

	^self
		executeString: aString 
		fromContext: nil.
!

executeString: aString fromContext: anObject

	^self
		withExplanation: aString 
		do: [
			self
				_executeString: aString
				fromContextOop: (self oopTypeFor: anObject).
		].
!

fetchBytes: anOopType

	| result |
	result := library 
		fetchBytes: anOopType 
		session: gciSessionID.
	^result.
!

forceLogout

	self
		stopHeartbeat;
		hardBreak;
		logout;
		yourself.

!

gciSessionId

	^gciSessionID.
!

gciVersion

	^library gciVersion.
!

gemHost
	^gemHost!

handlingClientForwarderSendDo: aBlock

	| block result continueWith |
	block := aBlock.
	[
		result := self returningResultOrErrorDo: block.
		result isKindOf: GsClientForwarderSend.
	] whileTrue: [
		continueWith := result signal.
		block := [
			library
				continue: result errorReport contextOop
				with: continueWith
				session: gciSessionID.
		].
	].
	^result.
!

hardBreak

	library hardBreakSession: gciSessionID.
!

hasServer

	^server notNil.
!

heartbeat: receiver arguments: arguments

	| result |
	(Delay forSeconds: 1) wait.
	result := self returningResultOrErrorDo: [
		library 
			send: 'delay' 
			to: receiver
			with: arguments
			session: gciSessionID.
	].
	[
		result isKindOf: GciError.
	] whileTrue: [
		| error |
		error := result.
		result := GsError 
			signalGCI: self
			gciErrSType: error tag.
		result = #'resume' ifFalse: [self halt].
		result := self returningResultOrErrorDo: [
			library
				continue: error tag contextOop
				session: gciSessionID.
		].
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
useSocket: useSocket
debugPath: debugPath

	isHandlingClientForwarderSend := false.
	eventCount := 0.
	stoneNRS := stoneString.
	gemNRS := gemString.
	userID := gsUserID.
	self 
		loadLibrary: libraryClass 
		debugPath: debugPath.
	gciSessionID := library
		gciSetNet: stoneNRS _: hostUserID _: hostPassword _: gemNRS;
		loginAs: gsUserID password: gsPassword.
	self 
		postLoginAs: initials
		useSocket: useSocket.

!

initializeServer
"
	GciSession allInstances first initializeServer.
"
	library ifNil: [^self].
	[
		server := self executeString: library jadeServerClass gsString.
	] on: GsRuntimeError do: [:ex | 
		| number notes |
		number := ex errorReport number.
		notes := ''.
		number = 2151 ifTrue: [notes := ' (code modification?)'].
		MessageBox warning: ex description , notes , '
Server initialization failed. Most functionality will be broken!!'.
		Keyboard default isShiftDown ifTrue: [ex halt].
		ex return: nil.
	].

	(server isKindOf: String) ifTrue: [
		self logout.
		GciLoginFailed
			signal: 'JadeServer compile error:
' , server
			with: self.
	].

	1 ~~ 1 ifTrue: [		"messasges that are sent by a ClientForwarderSend should not be stripped"
		self 
			signalConfirmationRequestUsing: nil;
			signalTextRequestUsing: nil;
			yourself.
	].
!

isLinkedGem

	^gemNRS isEmpty.
!

isOopType: anObject

	^anObject isKindOf: library oopTypeClass.
!

isRemoteGem

	^self isLinkedGem not.
!

isValidSession

	^gciSessionID notNil.
!

libraryVersion

	^library class displayName.
!

loadLibrary: aClass debugPath: debugPath

	library := aClass open: aClass fileName.
	debugPath isNilOrEmpty ifFalse: [
		(self debugToFilePath: debugPath) ifFalse: [self error: 'Unable to open ' , debugPath printString , ' for GCI debugging'].
		library gemTrace: 2.
	].!

logout

	self stopHeartbeat.
	self trigger: #'logoutPending'.
	library ifNotNil: [
		library logoutSession: gciSessionID.
		library := nil.
	].
	self trigger: #'logout'.
	gciSessionID := nil.
!

logoutRequested

	| valueHolder |
	valueHolder := Association key: self value: true.
	self trigger: #'logoutRequested:' with: valueHolder.
	^valueHolder value.
!

netPort
	^netPort!

netTask
	^netTask!

oopForInteger: anInteger

	^library oopForInteger: anInteger.
!

oopForString: aString

	aString isNil ifTrue: [^library oopNil].
	^library newString: aString session: gciSessionID.
!

oopGemStoneError

	^library oopGemStoneError.
!

oopIllegal

	^library oopIllegal.
!

oopTypeFor: anObject 

	anObject isNil 										ifTrue: [^library oopNil].
	(anObject isKindOf: ExternalInteger) 	ifTrue: [^anObject].
	(anObject isKindOf: Boolean) 				ifTrue: [^anObject ifTrue: [library oopTrue] ifFalse: [library oopFalse]].
	(anObject isKindOf: SmallInteger) 			ifTrue: [^self oopForInteger: anObject].
	(anObject isKindOf: GsObject) 				ifTrue: [^anObject oopType].
	MessageBox notify: 'Sorry, we are not yet prepared to convert ' , anObject printString , ' to an OOP!!'.
	Keyboard default isShiftDown ifTrue: [self halt].
!

oopTypeWithOop: anInteger

	^library oopTypeWithOop: anInteger.
!

postLoginAs: aString useSocket: aBoolean

	self initializeServer.
	aBoolean ifTrue: [self attemptSocket].
	self setInitials: aString.		"This gets back the session and serial number"
!

printString: anOopType

	^self
		serverPerform: 'printStringOf:'
		with: anOopType.
!

releaseOop: anOopType

	self releaseOops: (Array with: anOopType).
!

releaseOops: anArray

	library ifNil: [^self].
	anArray isEmpty ifTrue: [^self].
	library releaseOops: anArray session: gciSessionID.
!

returningResultOrErrorDo: aBlock
	"Here we isolate the error handling so we can unwind the stack.
	We should never return/resume the exception, but instead make
	a new call such as GciContinue()"

	^[
		aBlock value.
	] on: GciError do: [:ex | 
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

	| stream |
	stream := WriteStream on: String new.
	stream 
		nextPutAll: (anObject == server ifTrue: ['jadeServer'] ifFalse: [anObject printString]); cr;
		nextPutAll: '	perform: #''';
		nextPutAll: aSymbol;
		nextPut: $'; cr;
		nextPutAll: '	withAll: (Array';
		yourself.
	anArray do: [:each | 
		stream lf; nextPutAll: '		with: '; print: each.
	].
	stream nextPut: $).
	^self
		withExplanation: stream contents 
		do: [
			self
				_send: aSymbol 
				to: anObject 
				withAll: anArray.
		].
!

sendInterpreted: aString to: anObject withAll: anArray

	| stream arguments |
	stream := WriteStream on: String new.
	stream 
		nextPutAll: (anObject == server ifTrue: ['jadeServer'] ifFalse: [anObject printString]); cr;
		nextPutAll: '	performInterpreted: #''';
		nextPutAll: aString;
		nextPut: $'; cr;
		nextPutAll: '	withAll: (Array';
		yourself.
	anArray do: [:each | 
		stream lf; nextPutAll: '		with: '; print: each.
	].
	stream nextPut: $).
	arguments := self serverArrayFor: anArray.
	^self
		withExplanation: stream contents 
		do: [
			library 
				sendInterpreted: aString 
				to: (self oopTypeFor: anObject) 
				with: arguments
				session: gciSessionID.
		].
!

serverArrayFor: anArray

	| array |
	array := library oopTypeArrayClass new: anArray size.
	1 to: anArray size do: [:i | 
		array at: i put: (self oopTypeFor: (anArray at: i)).
	].
	^array.
!

serverPerform: aSymbol

	^self
		send: aSymbol
		to: server.
!

serverPerform: aSymbol with: arg1

	^self
		serverPerform: aSymbol 
		withArguments: (Array with: arg1).
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

	| pieces string |
	server isNil ifTrue: [^self].
	string := self
		serverPerform: #'mcInitials:' 
		with: initials.
	pieces := string subStrings collect: [:each | each asNumber].
	stoneSessionID := pieces at: 1.
	stoneSerial := pieces at: 2.
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
	^answer ifTrue: [library oopTrue] ifFalse: [library oopFalse].
!

signalInformRequestUsing: anOopType64 

	| string |
	string := self 
		serverPerform: #'obInformRequest:' 
		with: anOopType64.
	MessageBox
		notify: string 
		caption: 'Server Inform Request'.
	^library oopNil!

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
	answer ifNil: [^library oopNil].
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
	answer ifNil: [^library oopNil].
	oop := self oopForString: answer.
	[
		self releaseOop: oop.
	] forkAt: Processor userBackgroundPriority.
	^oop.
!

softBreak

	library softBreakSession: gciSessionID.
!

startHeartbeat
		"Private - Every second execute something inexpensive on the server (a Delay) 
		so that background processes on the server get a chance to run.

		Could be called from #'postLogin'"

	1 = 1 ifTrue: [^self].
	heartbeatProcess := [
		| receiver arguments |
		receiver := self oopTypeFor: server.
		arguments := self serverArrayFor: #().
		[true] whileTrue: [self heartbeat: receiver arguments: arguments].
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

	self serverPerform: #'terminate:' with: anOopType.
	TerminateProcess signal.
!

titleBarFor: aString
"'Jade ' , gciSession gciSessionId printString , ' (' , gciSession userID , ') - "
	| stream list |
	list := stoneNRS subStrings: $!!.
	stoneName := list at: 3.
	list := (list at: 2) subStrings: $#.
	list := (list at: 1) subStrings: $@.
	stoneHost := list at: 2.
	stream := WriteStream on: String new.
	stream 
		nextPutAll: 'Jade ';
		print: gciSessionID;
		nextPutAll: ' (';
		nextPutAll: userID;
		nextPutAll: ') - ';
		nextPutAll: aString;
		nextPutAll: ' on ';
		nextPutAll: stoneName;
		nextPutAll: ' session ';
		print: stoneSessionID;
		nextPutAll: ' on ';
		nextPutAll: stoneHost;
		yourself.
	self isRemoteGem ifTrue: [
		list := gemNRS subStrings: $#.
		netPort := ((list at: 2) subStrings: $:) at: 2.
		netTask := ((list at: 3) subStrings: $!!) at: 2.
		gemHost := ((list at: 1) subStrings: $@) at: 2.
		stream
			nextPutAll: ' with remote gem on ';
			nextPutAll: gemHost;
			yourself.
	] ifFalse: [
		stream nextPutAll: ' with linked gem'. 
	].
	^stream contents.
!

userID

	^userID.
!

value: aString

	^self
		value: aString
		withArguments: #().
!

value: aString with: anOopType

	^self
		value: aString
		withArguments: (Array with: anOopType).
!

value: aString with: anOopType1 with: anOopType2

	^self
		value: aString
		withArguments: (Array with: anOopType1 with: anOopType2).
!

value: aString withArguments: anArray

	self error: 'We should be using JadeServer'.
!

valueOfArrayOop: anOopType

	| array |
	(array := library fetchOops: anOopType session: gciSessionID) ifNil: [^nil].
	array := array collect: [:each | self valueOfOop: each].
	^array.
!

valueOfOop: anOopType

	| type |
	type := library fetchObjImpl: anOopType session: gciSessionID.
	type = 1 ifTrue: [^self fetchBytes: anOopType].
	type = 3 ifTrue: [^library specialFromOop: anOopType].
	^anOopType.
!

withExplanation: aString do: aBlock
	"Here we make the call and handle any error."

	| result error |
	result := self
		withExplanation: aString 
		doA: aBlock.
	self incrementEventCount.
	(result isKindOf: GsError) ifFalse: [^result].

	error := result.
	result := error signal.
	result = #'resume' ifFalse: [self halt].
	^self
		withExplanation: aString 
		do: [self _continueProcess: error errorReport contextOop].
!

withExplanation: aString doA: aBlock
	"Here we manage the UI feedback"

	| result haveResult shouldRunEventLoop dialog proc |
	shouldRunEventLoop := true.
	haveResult := false.
	[
		result := self handlingClientForwarderSendDo: aBlock.
		haveResult := true.
		shouldRunEventLoop := false.
		SessionManager inputState prod.
	] fork.
	[
		proc := [
			(Delay forSeconds: 1) wait.
			shouldRunEventLoop := false.
			SessionManager inputState prod.
		] fork.
		isHandlingClientForwarderSend ifTrue: [
			SessionManager inputState loopWhile: [shouldRunEventLoop].
			shouldRunEventLoop := true.
		] ifFalse: [
			self class cursor showWhile: [
				SessionManager inputState loopWhile: [shouldRunEventLoop].
				shouldRunEventLoop := true.
			].
		].
		haveResult ifTrue: [
			proc terminate.
			^result
		].
		isHandlingClientForwarderSend.
	] whileTrue: [].
	dialog := (Smalltalk at: #'WaitOnGemStoneDialog')
		gciSession: self 
		message: aString
		havingWaited: 1.
	[
		SessionManager inputState loopWhile: [shouldRunEventLoop].
		shouldRunEventLoop := true.
		dialog view close.
	] fork.
	dialog showModal.
	SessionManager inputState pumpMessages.
	^result.
! !
!GciSession categoriesFor: #_continueProcess:!long running!private! !
!GciSession categoriesFor: #_executeString:fromContextOop:!private! !
!GciSession categoriesFor: #_library!accessing!public! !
!GciSession categoriesFor: #_send:to:withAll:!private! !
!GciSession categoriesFor: #_server!private! !
!GciSession categoriesFor: #abort!Jade convenience!public! !
!GciSession categoriesFor: #attemptSocket!private! !
!GciSession categoriesFor: #begin!Jade convenience!public! !
!GciSession categoriesFor: #briefDescription!public! !
!GciSession categoriesFor: #clearStack:!Jade!public! !
!GciSession categoriesFor: #clientForwardError:!public! !
!GciSession categoriesFor: #clientForwarders!public! !
!GciSession categoriesFor: #commit!Jade convenience!public! !
!GciSession categoriesFor: #debugToFilePath:!Jade convenience!public! !
!GciSession categoriesFor: #eventCount!public! !
!GciSession categoriesFor: #executeString:!Jade convenience!public! !
!GciSession categoriesFor: #executeString:fromContext:!long running!public! !
!GciSession categoriesFor: #fetchBytes:!private! !
!GciSession categoriesFor: #forceLogout!Jade!public! !
!GciSession categoriesFor: #gciSessionId!public! !
!GciSession categoriesFor: #gciVersion!public! !
!GciSession categoriesFor: #gemHost!accessing!public! !
!GciSession categoriesFor: #handlingClientForwarderSendDo:!long running!private! !
!GciSession categoriesFor: #hardBreak!Jade!public! !
!GciSession categoriesFor: #hasServer!public! !
!GciSession categoriesFor: #heartbeat:arguments:!heartbeat!private! !
!GciSession categoriesFor: #incrementEventCount!long running!private! !
!GciSession categoriesFor: #indexOfClientForwarder:!public! !
!GciSession categoriesFor: #initializeLibrary:stoneNRS:gemNRS:userID:password:hostUserID:password:initials:useSocket:debugPath:!private! !
!GciSession categoriesFor: #initializeServer!private! !
!GciSession categoriesFor: #isLinkedGem!public! !
!GciSession categoriesFor: #isOopType:!public! !
!GciSession categoriesFor: #isRemoteGem!public! !
!GciSession categoriesFor: #isValidSession!public! !
!GciSession categoriesFor: #libraryVersion!public! !
!GciSession categoriesFor: #loadLibrary:debugPath:!public! !
!GciSession categoriesFor: #logout!Jade!public! !
!GciSession categoriesFor: #logoutRequested!Jade!public! !
!GciSession categoriesFor: #netPort!accessing!public! !
!GciSession categoriesFor: #netTask!accessing!public! !
!GciSession categoriesFor: #oopForInteger:!public! !
!GciSession categoriesFor: #oopForString:!public! !
!GciSession categoriesFor: #oopGemStoneError!public! !
!GciSession categoriesFor: #oopIllegal!public! !
!GciSession categoriesFor: #oopTypeFor:!public! !
!GciSession categoriesFor: #oopTypeWithOop:!public! !
!GciSession categoriesFor: #postLoginAs:useSocket:!private! !
!GciSession categoriesFor: #printString:!Jade convenience!public! !
!GciSession categoriesFor: #releaseOop:!Jade convenience!public! !
!GciSession categoriesFor: #releaseOops:!Jade!public! !
!GciSession categoriesFor: #returningResultOrErrorDo:!long running!private! !
!GciSession categoriesFor: #send:to:!Jade convenience!public! !
!GciSession categoriesFor: #send:to:withAll:!Jade convenience!long running!public! !
!GciSession categoriesFor: #sendInterpreted:to:withAll:!Jade convenience!long running!public! !
!GciSession categoriesFor: #serverArrayFor:!Jade convenience!public! !
!GciSession categoriesFor: #serverPerform:!Jade convenience!public! !
!GciSession categoriesFor: #serverPerform:with:!Jade convenience!public! !
!GciSession categoriesFor: #serverPerform:with:with:!Jade convenience!public! !
!GciSession categoriesFor: #serverPerform:with:with:with:!Jade convenience!public! !
!GciSession categoriesFor: #serverPerform:with:with:with:with:!Jade convenience!public! !
!GciSession categoriesFor: #serverPerform:withArguments:!Jade convenience!public! !
!GciSession categoriesFor: #serverPerformInterpreted:with:with:!Jade convenience!public! !
!GciSession categoriesFor: #serverPerformInterpreted:withArguments:!Jade convenience!public! !
!GciSession categoriesFor: #setInitials:!private! !
!GciSession categoriesFor: #signalConfirmationRequestUsing:!OmniBrowser!public! !
!GciSession categoriesFor: #signalInformRequestUsing:!OmniBrowser!public! !
!GciSession categoriesFor: #signalMultiLineTextRequestUsing:!OmniBrowser!public! !
!GciSession categoriesFor: #signalTextRequestUsing:!OmniBrowser!public! !
!GciSession categoriesFor: #softBreak!Jade!public! !
!GciSession categoriesFor: #startHeartbeat!heartbeat!private! !
!GciSession categoriesFor: #stepInto:inFrame:!public! !
!GciSession categoriesFor: #stepOut:inFrame:!public! !
!GciSession categoriesFor: #stepOver:inFrame:!public! !
!GciSession categoriesFor: #stoneHost!accessing!public! !
!GciSession categoriesFor: #stoneName!accessing!public! !
!GciSession categoriesFor: #stoneSerial!private! !
!GciSession categoriesFor: #stoneSessionID!public! !
!GciSession categoriesFor: #stopHeartbeat!Jade!public! !
!GciSession categoriesFor: #terminate:!public! !
!GciSession categoriesFor: #titleBarFor:!public! !
!GciSession categoriesFor: #userID!public! !
!GciSession categoriesFor: #value:!Jade convenience!public! !
!GciSession categoriesFor: #value:with:!Jade convenience!public! !
!GciSession categoriesFor: #value:with:with:!Jade convenience!public! !
!GciSession categoriesFor: #value:withArguments:!Jade!public! !
!GciSession categoriesFor: #valueOfArrayOop:!Jade convenience!public! !
!GciSession categoriesFor: #valueOfOop:!Jade convenience!public! !
!GciSession categoriesFor: #withExplanation:do:!long running!private! !
!GciSession categoriesFor: #withExplanation:doA:!long running!private! !

!GciSession class methodsFor!

cursor

	GemCursor isNil ifTrue: [
		GemCursor := Cursor fromFile: 'icons\GS32x32.ico'.
	].
	^GemCursor.
!

libraryClass: libraryClass 
stoneNRS: stoneNRS 
gemNRS: gemNRS 
userID: gsUserID 
password: gsPassword 
hostUserID: hostUserID 
password: hostPassword 
initials: initials
useSocket: useSocket
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
		useSocket: useSocket
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
!GciSession class categoriesFor: #cursor!public! !
!GciSession class categoriesFor: #libraryClass:stoneNRS:gemNRS:userID:password:hostUserID:password:initials:useSocket:debugPath:!public! !
!GciSession class categoriesFor: #new!public! !
!GciSession class categoriesFor: #publishedEventsOfInstances!public! !

JadeServer guid: (GUID fromString: '{FC038152-9707-4C5F-8977-A1F8D02EB005}')!
JadeServer comment: '(System _sessionStateAt: 3).	"pre-3.2"
(System __sessionStateAt: 3).	"3.2 and on"
GciSession allInstances , GciSessionWithSocket allInstances do: [:each | each initializeServer].
GciSession allInstances do: [:each | each logout].'!
!JadeServer categoriesForClass!Unclassified! !
!JadeServer methodsFor!

_addToPureExportSet: anObject

	System 
		_add: anObject 
		toGciSet: 39.  "PureExportSet"
!

abort

	classOrganizer := nil.
	System abortTransaction.
	self refreshSymbolList.
!

asString: anObject

	(anObject isKindOf: String) ifTrue: [^anObject].
	Exception
		category: nil
		number: nil
		do: [:ex :cat :num :args | 
			^'<<printString error: ' , ex printString , '>>'.
		].
	^anObject printString.
!

beginTransaction

	classOrganizer := nil.
	System beginTransaction.
!

commit

	classOrganizer := nil.
	^System commitTransaction.
!

contents
	"WriteStream method to identify things that have not yet been flushed to the output. We have flushed everything!!"

	^''.
!

cr

	self nextPut: Character cr.
!

delay

	(Delay forMilliseconds: 10) wait.
!

errorListFor: aCollection

	| stream |
	aCollection class name == #'ErrorDescription' ifTrue: [^''].
	stream := WriteStream on: String new.
	aCollection do: [:each | 
		stream
			nextPutAll: (each at: 1) printString; tab;
			nextPutAll: (each at: 2) printString; tab;
			nextPutAll: ((2 < each size and: [(each at: 3) notNil]) ifTrue: [(each at: 3)] ifFalse: [(GemStoneError at: #English) at: (each at: 1)]); tab;
			lf.
	].
	^stream contents.
!

executeString: aString fromContext: anObject

	^aString
		evaluateInContext: anObject 
		symbolList: GsSession currentSession symbolList. !

initialize

	self 
		installTranscript;
		registerOBNotifications;
		yourself.!

installTranscript

	| transcript |
	transcript := self objectNamed: #'Transcript'.

	"If no Transcript object, then install me!!"
	(transcript == nil or: [transcript class name == self class name]) ifTrue: [
		UserGlobals at: #'Transcript' put: self.
		System commitTransaction.
		^self.
	].
	
	"Transcript object from Seaside"
	transcript class name = 'TranscriptProxy class' ifTrue: [
		| clientForwarder |
		clientForwarder := ClientForwarder new.
		clientForwarder	clientObject: 2.
		transcript registerTranscriptClientForwarder: clientForwarder.
		^self.
	].
!

is32Bit

	^false.
!

isClientForwarder: anObject

	^anObject _class name == #'ClientForwarder'.
!

makeListener

	^nil.
!

nextPut: aCharacter

	self nextPutAll: aCharacter asString.
!

nextPutAll: anObject

	| string args |
	string := self asString: anObject.
	args := Array
		with: self
		with: 1
		with: #'nextPutAll:'
		with: (Array with: string).
	System
		signal: 2336
		args: args
		signalDictionary: GemStoneError.
!

obConfirmationRequest: anOBConfirmationRequest

	^String new 
		addAll: anOBConfirmationRequest cancelChoice;
		add: Character lf;
		addAll: anOBConfirmationRequest okChoice;
		add: Character lf;
		addAll: anOBConfirmationRequest prompt;
		yourself.
!

obInformRequest: anOBInformRequest

	^anOBInformRequest message!

objectForOop: anInteger

	self subclassResponsibility.!

objectNamed: aString

	^System myUserProfile objectNamed: aString asSymbol.
!

obTextRequest: anOBTextRequest

	| prompt template |
	prompt := anOBTextRequest prompt.
	template := anOBTextRequest template.
	^String new 
		addAll: prompt size printString;
		add: Character lf;
		addAll: prompt;
		addAll: template;
		yourself.
!

oopOf: anObject

	^anObject asOop.
!

refreshSymbolList

	GsSession currentSession symbolList replaceElementsFrom: self symbolList.	"replace the transcient one with the persistent one"
!

registerOBNotifications

	| platform clientForwarder |
	(platform := self objectNamed: #'OBGemStonePlatform') isNil ifTrue: [^self].
	clientForwarder := ClientForwarder new.
	clientForwarder	clientObject: 1.
	self
		registerOBNotificationsForPlatform: platform 
		clientForwarder: clientForwarder.
!

registerOBNotificationsForPlatform: platform clientForwarder: clientForwarder

	platform 
		registerBrowseClientForwarder: clientForwarder;
		registerChoiceClientForwarder: clientForwarder;
		registerCloseClientForwarder: clientForwarder;
		registerConfirmationClientForwarder: clientForwarder;
		registerInformClientForwarder: clientForwarder;
		registerMultiLineTextClientForwarder: clientForwarder;
		registerTextClientForwarder: clientForwarder;
		yourself.
!

reset
	"WriteStream protocol"!

show: anObject

	self nextPutAll: anObject printString.
!

stackForProcess: aGsProcess

	| array stream |
	Exception
		category: nil
		number: nil
		do: [:ex :cat :num :args | nil].
	array := aGsProcess _reportOfSize: 5000.
	stream := WriteStream on: String new.
	array do: [:each | 
		stream nextPutAll: each; lf.
	].
	^stream contents.
!

terminate: aGsProcess

	aGsProcess isNil ifTrue: [^self].
	aGsProcess terminate.
	(Delay forMilliseconds: 10) wait.	"allow forked processes to finish"
! !
!JadeServer categoriesFor: #_addToPureExportSet:!private! !
!JadeServer categoriesFor: #abort!public! !
!JadeServer categoriesFor: #asString:!public!Transcript! !
!JadeServer categoriesFor: #beginTransaction!public! !
!JadeServer categoriesFor: #commit!public! !
!JadeServer categoriesFor: #contents!public! !
!JadeServer categoriesFor: #cr!public!Transcript! !
!JadeServer categoriesFor: #delay!public! !
!JadeServer categoriesFor: #errorListFor:!public! !
!JadeServer categoriesFor: #executeString:fromContext:!public! !
!JadeServer categoriesFor: #initialize!public! !
!JadeServer categoriesFor: #installTranscript!public!Transcript! !
!JadeServer categoriesFor: #is32Bit!public! !
!JadeServer categoriesFor: #isClientForwarder:!Debugger!public! !
!JadeServer categoriesFor: #makeListener!private! !
!JadeServer categoriesFor: #nextPut:!public!Transcript! !
!JadeServer categoriesFor: #nextPutAll:!public!Transcript! !
!JadeServer categoriesFor: #obConfirmationRequest:!OmniBrowser!public! !
!JadeServer categoriesFor: #obInformRequest:!OmniBrowser!public! !
!JadeServer categoriesFor: #objectForOop:!private! !
!JadeServer categoriesFor: #objectNamed:!private! !
!JadeServer categoriesFor: #obTextRequest:!OmniBrowser!public! !
!JadeServer categoriesFor: #oopOf:!private! !
!JadeServer categoriesFor: #refreshSymbolList!public! !
!JadeServer categoriesFor: #registerOBNotifications!public! !
!JadeServer categoriesFor: #registerOBNotificationsForPlatform:clientForwarder:!public! !
!JadeServer categoriesFor: #reset!public! !
!JadeServer categoriesFor: #show:!public!Transcript! !
!JadeServer categoriesFor: #stackForProcess:!public! !
!JadeServer categoriesFor: #terminate:!Processes!public! !

!JadeServer class methodsFor!

addGsStringTo: aStream definingClassBlock: aBlock

	aStream
		nextPutAll: 'class := ', (aBlock value: self); lf;
		yourself.
	self selectors do: [:each | 
		aStream nextPutAll: 'source := '.
		((self sourceCodeAt: each) reject: [:char | char == Character cr]) printOn: aStream.
		aStream
			nextPutAll: '.'; lf;
			nextPutAll: 'result := class'; lf;
			tab; nextPutAll: 'compileMethod: source'; lf;
			tab; nextPutAll: 'dictionaries: symbolList'; lf;
			tab; nextPutAll: 'category: ''category''.'; lf;
			nextPutAll: 'result ~~ nil ifTrue: [^GsMethod _sourceWithErrors: result fromString: source].'; lf;
			yourself.
	].
!

classVarsForGemStone

	^(self == JadeServer ifTrue: ['ExternalInteger GciError GsObject OopType32 OopType64'] ifFalse: ['']).
!

gsClassDefinitionBlock

	self subclassResponsibility.
!

gsString
"
	JadeServer64bit3x gsString.
"
	| stream |
	SessionManager current isRuntime ifTrue: [^gsString].
	(stream := WriteStream on: String new)
		nextPutAll: '| class symbolList source server result mcPlatformSupport |'; lf;
		nextPutAll: 'symbolList := System myUserProfile symbolList.'; lf;
		nextPutAll: 'class := Object.'; lf;
		yourself.
	(self withAllSuperclasses remove: Object; yourself) reverseDo: [:eachClass | eachClass addGsStringTo: stream definingClassBlock: self gsClassDefinitionBlock].
	stream 
		nextPutAll: '(mcPlatformSupport := System myUserProfile objectNamed: #''MCPlatformSupport'') notNil ifTrue: ['; lf;
		nextPutAll: '	mcPlatformSupport autoCommit: false; autoMigrate: false].'; lf;
		nextPutAll: 'server := class new initialize; yourself.'; lf;
		nextPutAll: self sessionStateCode; lf;
		nextPutAll: 'server';
		yourself.
	gsString := stream contents.
	^gsString.
!

sessionStateCode

	^'System _sessionStateAt: 3 put: server.'! !
!JadeServer class categoriesFor: #addGsStringTo:definingClassBlock:!public! !
!JadeServer class categoriesFor: #classVarsForGemStone!public! !
!JadeServer class categoriesFor: #gsClassDefinitionBlock!public! !
!JadeServer class categoriesFor: #gsString!public! !
!JadeServer class categoriesFor: #sessionStateCode!public! !

GsError guid: (GUID fromString: '{7299EB14-EE00-4BEC-8A87-E9EC616FAB36}')!
GsError comment: ''!
!GsError categoriesForClass!Unclassified! !
!GsError methodsFor!

defaultAction

	^self reportError.
!

errorReport 

	^gciErrSType.
!

gatherData

	gciErrSType notNil ifTrue: [
		messageText := gciErrSType message.
	].
!

gciErrSType: anObject
	gciErrSType := anObject!

gciSession

	^tag.
!

gsProcess

	gsProcess isNil ifTrue: [
		gsProcess := GsProcess 
			session: self gciSession 
			oop: self errorReport contextOop.
	].
	^gsProcess.
!

isResumableInGem

	^tag
		serverPerform: #'isResumableCategory:number:context:'
		with: (tag oopTypeWithOop: gciErrSType category)
		with: gciErrSType number
		with: (tag oopTypeWithOop: gciErrSType context).

!

isStackBreakpoint

	^false.
!

processOop 

	^gciErrSType context.
!

reportError

	"The error can occur before code starts executing (see bug #44232)"
	gciErrSType contextOop isGsNil ifTrue: [
		self reportErrorMessage.
		Processor activeProcess terminate.
	].
	[
		^self debugError.
	] on: Error do: [:ex | 
		(ex isKindOf: GsError) ifTrue: [ex pass].
		SessionManager current logError: ex.
		MessageBox warning: 'Error while processing error: ' , ex description.
		Keyboard default isShiftDown ifTrue: [self halt].
		self reportErrorMessage.
	].
!

reportErrorMessage

	| stream  |
	(stream := WriteStream on: String new)
		nextPutAll: gciErrSType message; cr; cr;
		nextPutAll: (self gciSession printString: gciErrSType contextOop);
		yourself.
	MessageBox 
		errorMsg: stream contents
		caption: 'GemStone Error #' , gciErrSType number printString.
	Keyboard default isShiftDown ifTrue: [self halt].
	self gciSession terminate: gciErrSType contextOop.
!

signal

	self gatherData.
	^super signal.
!

terminateProcess

	self gciSession terminate: self errorReport contextOop.
	self error: 'We should never get here!!'.
! !
!GsError categoriesFor: #defaultAction!public! !
!GsError categoriesFor: #errorReport!public! !
!GsError categoriesFor: #gatherData!public! !
!GsError categoriesFor: #gciErrSType:!accessing!private! !
!GsError categoriesFor: #gciSession!accessing!public! !
!GsError categoriesFor: #gsProcess!accessing!private! !
!GsError categoriesFor: #isResumableInGem!public! !
!GsError categoriesFor: #isStackBreakpoint!public! !
!GsError categoriesFor: #processOop!public! !
!GsError categoriesFor: #reportError!public! !
!GsError categoriesFor: #reportErrorMessage!public! !
!GsError categoriesFor: #signal!public! !
!GsError categoriesFor: #terminateProcess!accessing!public! !

!GsError class methodsFor!

classToHandle: aGciErrorSType session: aGciSession

	self subclasses do: [:each | | myClass |
		(myClass := each classToHandle: aGciErrorSType session: aGciSession) notNil ifTrue: [^myClass].
	].
	(self wantsToHandle: aGciErrorSType session: aGciSession) ifTrue: [^self].
	^nil.
!

forSession: aGciSession

	self error: 'use #forSession:gciErrSType:'.!

forSession: aGciSession gciErrSType: aGciErrSType

	| aClass |
	[
		aClass := self classToHandle: aGciErrSType session: aGciSession.
	] on: Error do: [:ex | 
		self error: aGciErrSType message.
	].
	^aClass new
		tag: aGciSession;
		gciErrSType: aGciErrSType;
		yourself.
!

signal: aString

	self error: 'use #signalGCI:gciErrSType:'.
!

signal: aString with: anObject

	self error: 'use #signalGCI:gciErrSType:'.
!

signalGCI: aGciSession

	self error: 'use #signalGCI:gciErrSType:'.
!

signalGCI: aGciSession gciErrSType: aGciErrSType

	^(self 
		forSession: aGciSession
		gciErrSType: aGciErrSType)
		signal.
!

signalWith: anObject

	self error: 'use #signalGCI:gciErrSType:'.
!

wantsToHandle: aGciErrorSType session: aGciSession

	^true.
! !
!GsError class categoriesFor: #classToHandle:session:!public! !
!GsError class categoriesFor: #forSession:!public! !
!GsError class categoriesFor: #forSession:gciErrSType:!public! !
!GsError class categoriesFor: #signal:!public! !
!GsError class categoriesFor: #signal:with:!public! !
!GsError class categoriesFor: #signalGCI:!public! !
!GsError class categoriesFor: #signalGCI:gciErrSType:!public! !
!GsError class categoriesFor: #signalWith:!public! !
!GsError class categoriesFor: #wantsToHandle:session:!public! !

GsAnsiError guid: (GUID fromString: '{F7430395-3A25-4EEB-BC48-8AAE8EB0A73B}')!
GsAnsiError comment: ''!
!GsAnsiError categoriesForClass!Unclassified! !
!GsAnsiError class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^false.
! !
!GsAnsiError class categoriesFor: #wantsToHandle:session:!public! !

GsCompileError guid: (GUID fromString: '{E49BE376-E1AF-4368-A429-B691F6E547CA}')!
GsCompileError comment: ''!
!GsCompileError categoriesForClass!Unclassified! !
!GsCompileError methodsFor!

gatherData

	super gatherData.
	list := self class 
		errorListFor: gciErrSType args first 
		inSession: self gciSession.
!

list

	^list.
! !
!GsCompileError categoriesFor: #gatherData!public! !
!GsCompileError categoriesFor: #list!public! !

!GsCompileError class methodsFor!

errorListFor: anOop inSession: aGciSession
 
	| result list |
	result := aGciSession
		serverPerform: #'errorListFor:'
		with: anOop.
	list := result subStrings: Character lf.
	list := list collect: [:each | each , '	' subStrings: Character tab].
	list := list collect: [:each | 
		Array
			with: (each at: 1) asNumber
			with: (each at: 2) asNumber
			with: (each at: 3).
	].
	^list.
!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isCompileErrorInSession: aGciSession.
! !
!GsCompileError class categoriesFor: #errorListFor:inSession:!public! !
!GsCompileError class categoriesFor: #wantsToHandle:session:!public! !

GsEventError guid: (GUID fromString: '{F7917B60-1D40-4EDE-ACF3-C036F1EA7A01}')!
GsEventError comment: ''!
!GsEventError categoriesForClass!Unclassified! !
!GsEventError class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isEventErrorInSession: aGciSession.
! !
!GsEventError class categoriesFor: #wantsToHandle:session:!public! !

GsFatalError guid: (GUID fromString: '{71EABB54-3A5A-4CA2-BCA3-44B39D453586}')!
GsFatalError comment: ''!
!GsFatalError categoriesForClass!Unclassified! !
!GsFatalError methodsFor!

defaultAction

	MessageBox 
		errorMsg: gciErrSType message
		caption: 'Fatal GemStone Error'.
	Processor activeProcess terminate.
! !
!GsFatalError categoriesFor: #defaultAction!public! !

!GsFatalError class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType number // 1000 = 4.
! !
!GsFatalError class categoriesFor: #wantsToHandle:session:!public! !

GsRuntimeError guid: (GUID fromString: '{A3B64446-755D-4647-9CCA-2354531DC693}')!
GsRuntimeError comment: ''!
!GsRuntimeError categoriesForClass!Unclassified! !
!GsRuntimeError methodsFor!

isResumableInGem

	^true.
! !
!GsRuntimeError categoriesFor: #isResumableInGem!public! !

!GsRuntimeError class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isRuntimeErrorInSession: aGciSession.
! !
!GsRuntimeError class categoriesFor: #wantsToHandle:session:!public! !

GsTestFailure guid: (GUID fromString: '{BD39CA74-6D0F-4A45-A5ED-2ACF574AB10F}')!
GsTestFailure comment: ''!
!GsTestFailure categoriesForClass!Unclassified! !
!GsTestFailure class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType message = 'aTestFailure signal: ''Assertion failed'''.
! !
!GsTestFailure class categoriesFor: #wantsToHandle:session:!public! !

GsClientForwarderSend guid: (GUID fromString: '{12AB69FE-6B24-4CB4-8CFC-7782A7B028C7}')!
GsClientForwarderSend comment: '
System 
	_signalGciError: 2336
    args:#[ 
		1, "aClientForwarder"
		2 "receiver" , 
	    3 "selector" , 
        #() "arguments to selector" ,
		0 "number of arguments" ]
    signalDictionary: GemStoneError.
'!
!GsClientForwarderSend categoriesForClass!Unclassified! !
!GsClientForwarderSend methodsFor!

signal

	self gatherData.
	^tag clientForwardError: gciErrSType.
! !
!GsClientForwarderSend categoriesFor: #signal!public! !

!GsClientForwarderSend class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isClientForwarderSendInSession: aGciSession.
! !
!GsClientForwarderSend class categoriesFor: #wantsToHandle:session:!public! !

GsHardBreak guid: (GUID fromString: '{DDC5CCC6-21B0-4B56-BAD1-F688B283CA6C}')!
GsHardBreak comment: ''!
!GsHardBreak categoriesForClass!Unclassified! !
!GsHardBreak class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isHardBreakInSession: aGciSession.
! !
!GsHardBreak class categoriesFor: #wantsToHandle:session:!public! !

GsPause guid: (GUID fromString: '{2072DCC5-82C2-4AE5-8173-C6A980C0DC7D}')!
GsPause comment: ''!
!GsPause categoriesForClass!Unclassified! !
!GsPause class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isPauseInSession: aGciSession.
! !
!GsPause class categoriesFor: #wantsToHandle:session:!public! !

GsSoftBreak guid: (GUID fromString: '{1B6BA16B-E5CD-47A9-827C-4C945CED0DB8}')!
GsSoftBreak comment: ''!
!GsSoftBreak categoriesForClass!Unclassified! !
!GsSoftBreak class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isSoftBreakInSession: aGciSession.
! !
!GsSoftBreak class categoriesFor: #wantsToHandle:session:!public! !

GsStackBreakpoint guid: (GUID fromString: '{601667A8-F7D5-4FAB-97F1-C753A26EBC27}')!
GsStackBreakpoint comment: ''!
!GsStackBreakpoint categoriesForClass!Unclassified! !
!GsStackBreakpoint methodsFor!

isStackBreakpoint

	^true.
! !
!GsStackBreakpoint categoriesFor: #isStackBreakpoint!public! !

!GsStackBreakpoint class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isStackBreakpointInSession: aGciSession.
! !
!GsStackBreakpoint class categoriesFor: #wantsToHandle:session:!public! !

GsInvalidSessionError guid: (GUID fromString: '{343D0696-B2FC-405F-9E96-01929DFB6CB6}')!
GsInvalidSessionError comment: ''!
!GsInvalidSessionError categoriesForClass!Unclassified! !
!GsInvalidSessionError methodsFor!

defaultAction

	MessageBox errorMsg: 'Invalid Session!!'.
	self gciSession forceLogout.
	Processor forkMainIfMain.
	Processor activeProcess terminate.
! !
!GsInvalidSessionError categoriesFor: #defaultAction!public! !

!GsInvalidSessionError class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isInvalidSessionInSession: aGciSession.
! !
!GsInvalidSessionError class categoriesFor: #wantsToHandle:session:!public! !

GsApplicationError guid: (GUID fromString: '{D764751F-9E17-4F7E-ABC9-5BA5384631A1}')!
GsApplicationError comment: ''!
!GsApplicationError categoriesForClass!Unclassified! !
!GsApplicationError class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isApplicationErrorInSession: aGciSession.
! !
!GsApplicationError class categoriesFor: #wantsToHandle:session:!public! !

GsDoesNotUnderstand guid: (GUID fromString: '{47A598C1-9046-44F2-BDB5-954383DD1EF5}')!
GsDoesNotUnderstand comment: ''!
!GsDoesNotUnderstand categoriesForClass!Unclassified! !
!GsDoesNotUnderstand class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType isDoesNotUnderstandInSession: aGciSession.
! !
!GsDoesNotUnderstand class categoriesFor: #wantsToHandle:session:!public! !

GsHaltError guid: (GUID fromString: '{86CA4EF5-C363-4A19-820B-21230E7D7949}')!
GsHaltError comment: ''!
!GsHaltError categoriesForClass!Unclassified! !
!GsHaltError class methodsFor!

wantsToHandle: aGciErrorSType session: aGciSession

	^aGciErrorSType message = 'User defined error, ''#halt encountered''' or: [
		aGciErrorSType message = 'a Halt occurred (error 2709)'].

! !
!GsHaltError class categoriesFor: #wantsToHandle:session:!public! !

TerminateProcess guid: (GUID fromString: '{7389AE5E-CB19-4BFE-923B-860DCADADB60}')!
TerminateProcess comment: ''!
!TerminateProcess categoriesForClass!Unclassified! !
!TerminateProcess methodsFor!

defaultAction

	Processor terminateActive.
! !
!TerminateProcess categoriesFor: #defaultAction!public! !

GciSessionWithSocket guid: (GUID fromString: '{604CBF33-D6BE-45FF-B250-4654B42AA062}')!
GciSessionWithSocket comment: ''!
!GciSessionWithSocket categoriesForClass!Unclassified! !
!GciSessionWithSocket methodsFor!

_continueProcess: aContextOop

	^self
		_usingSocketSend: #'processAction:' 
		to: server
		withAll: (Array with: aContextOop with: #'resume').
!

_executeString: aString fromContextOop: anOopType
	^self
		_usingSocketSend: #'executeString:fromContext:' 
		to: server 
		withAll: (Array with: aString with: anOopType).
!

_send: aSymbol to: anObject withAll: anArray

	^self
		_usingSocketSend: aSymbol 
		to: anObject 
		withAll: anArray.
!

_usingSocketSend: aSymbol to: anObject withAll: anArray

	| stream  process resultSize result encoder |
	stream := WriteStream on: ByteArray new.
	encoder := JadeServer64bit33 new
		add: anObject toByteStream: stream;
		add: aSymbol toByteStream: stream;
		add: anArray toByteStream: stream;
		yourself.
	process := [:bytes | socket sendByteArray: bytes] newProcessWithArguments: (Array with: stream contents).
	process resume.
	[
		resultSize := library 
				send: #'readSocket:' 
				to: server
				with: (self serverArrayFor: (Array with: stream contents size))
				session: gciSessionID.
		result := socket receiveByteArray: resultSize.
	] on: Exception do: [:ex | 
	].	stream := ReadStream on: result.
	result := encoder 
		readObjectFrom: stream
		errorClass: library errorStructureClass.
	^result.
!

initializeFrom: aGciSession withSocket: aSocket

	1 to: aGciSession class allInstVarNames size do: [:i | 
		self instVarAt: i put: (aGciSession instVarAt: i).
	].
	socket := aSocket.
!

stepInto: aGsProcess inFrame: anInteger

	[
		self
			_usingSocketSend: #'processAction:' 
			to: server
			withAll: (Array with: aGsProcess with: #'stepInto' with: anInteger).
	] on: GciError do: [:ex | 
		ex tag number == 6002 ifTrue: [
			ex return.	"We were expecting a single-step breakpoint!!"
		].
		ex pass.
	].!

stepOut: aGsProcess inFrame: anInteger

	[
		self
			_usingSocketSend: #'processAction:' 
			to: server
			withAll: (Array with: aGsProcess with: #'stepOut' with: anInteger).
	] on: GciError do: [:ex | 
		ex tag number == 6002 ifTrue: [
			ex return.	"We were expecting a single-step breakpoint!!"
		].
		ex pass.
	].!

stepOver: aGsProcess inFrame: anInteger

	[
		self
			_usingSocketSend: #'processAction:' 
			to: server
			withAll: (Array with: aGsProcess with: #'stepOver' with: anInteger).
	] on: GciError do: [:ex | 
		ex tag number == 6002 ifTrue: [
			ex return.	"We were expecting a single-step breakpoint!!"
		].
		ex pass.
	].!

terminate: anOopType

	self
		_usingSocketSend: #'processAction:' 
		to: server
		withAll: (Array with: anOopType with: #'terminate').
	TerminateProcess signal.
! !
!GciSessionWithSocket categoriesFor: #_continueProcess:!long running!private! !
!GciSessionWithSocket categoriesFor: #_executeString:fromContextOop:!private! !
!GciSessionWithSocket categoriesFor: #_send:to:withAll:!private! !
!GciSessionWithSocket categoriesFor: #_usingSocketSend:to:withAll:!private! !
!GciSessionWithSocket categoriesFor: #initializeFrom:withSocket:!public! !
!GciSessionWithSocket categoriesFor: #stepInto:inFrame:!public! !
!GciSessionWithSocket categoriesFor: #stepOut:inFrame:!public! !
!GciSessionWithSocket categoriesFor: #stepOver:inFrame:!public! !
!GciSessionWithSocket categoriesFor: #terminate:!public! !

!GciSessionWithSocket class methodsFor!

from: aGciSession withSocket: aSocket

	^self basicNew
		initializeFrom: aGciSession withSocket: aSocket;
		yourself.
!

new

	self error: 'use #''from:withSocket:'''.! !
!GciSessionWithSocket class categoriesFor: #from:withSocket:!public! !
!GciSessionWithSocket class categoriesFor: #new!public! !

JadeServer32bit guid: (GUID fromString: '{6BD4AC2A-D6A4-438A-9B0B-E050DD50B3A2}')!
JadeServer32bit comment: ''!
!JadeServer32bit categoriesForClass!Unclassified! !
!JadeServer32bit methodsFor!

asString: anObject

	Exception
		category: nil 
		number: nil 
		do: [:ex :cat :num :args | ^'????'].
	^super asString: anObject.
!

installTranscript

	Exception
		category: nil
		number: nil
		do: [:ex :cat :num :args | ^self].
	super installTranscript.
!

objectForOop: anInteger

	^Object _objectForOop: anInteger
! !
!JadeServer32bit categoriesFor: #asString:!public!Transcript! !
!JadeServer32bit categoriesFor: #installTranscript!public!Transcript! !
!JadeServer32bit categoriesFor: #objectForOop:!public!System Browser! !

!JadeServer32bit class methodsFor!

gsClassDefinitionBlock
	"Some class variables exist only in Dolphin and map to globals in GemStone; others exist only in GemStone and map to globals in Dolphin!!"

	^[:aClass | 'class subclass: ''' , aClass name , '''
		instVarNames: ' , aClass instVarNames printString , '
		classVars: #(' , aClass classVarsForGemStone , ')
		classInstVars: #()
		poolDictionaries: #()
		inDictionary: SymbolDictionary new
		constraints: #()
		instancesInvariant: false
		isModifiable: false.'].
! !
!JadeServer32bit class categoriesFor: #gsClassDefinitionBlock!public! !

JadeServer64bit guid: (GUID fromString: '{36FD8C46-21B4-4852-977C-1A9889969313}')!
JadeServer64bit comment: ''!
!JadeServer64bit categoriesForClass!Unclassified! !
!JadeServer64bit methodsFor!

asString: anObject

	^[
		super asString: anObject.
	] on: Error do: [:ex | 
		ex return: '???'.
	].
!

installTranscript

	[
		super installTranscript.
	] on: Error do: [:ex | 
		ex return.
	].
!

objectForOop: anInteger

	^Object _objectForOop: anInteger.
! !
!JadeServer64bit categoriesFor: #asString:!public!Transcript! !
!JadeServer64bit categoriesFor: #installTranscript!public!Transcript! !
!JadeServer64bit categoriesFor: #objectForOop:!public!System Browser! !

!JadeServer64bit class methodsFor!

gsClassDefinitionBlock
	"Some class variables exist only in Dolphin and map to globals in GemStone; others exist only in GemStone and map to globals in Dolphin!!"

	^[:aClass | 'class subclass: ''' , aClass name , '''
		instVarNames: ' , aClass instVarNames printString , '
		classVars: #(' , aClass classVarsForGemStone , ')
		classInstVars: #()
		poolDictionaries: #()
		inDictionary: SymbolDictionary new
		instancesInvariant: false
		isModifiable: false.'].
! !
!JadeServer64bit class categoriesFor: #gsClassDefinitionBlock!public! !

JadeServer64bit24 guid: (GUID fromString: '{1AF3D6EB-C974-4E19-B3CF-46098CDD8C6D}')!
JadeServer64bit24 comment: ''!
!JadeServer64bit24 categoriesForClass!Unclassified! !
!JadeServer64bit24 methodsFor!

oopOf: anObject

	^Reflection oopOf: anObject.
!

registerOBNotificationsForPlatform: platform clientForwarder: clientForwarder

	super
		registerOBNotificationsForPlatform: platform 
		clientForwarder: clientForwarder.
	platform 
		registerMultipleChoiceClientForwarder: clientForwarder;
		yourself.
! !
!JadeServer64bit24 categoriesFor: #oopOf:!private! !
!JadeServer64bit24 categoriesFor: #registerOBNotificationsForPlatform:clientForwarder:!public! !

JadeServer64bit3x guid: (GUID fromString: '{1DC3DEBB-81EC-4B7B-872E-82229E88781B}')!
JadeServer64bit3x comment: '(System _sessionStateAt: 3).
GciSession allInstances do: [:each | each initializeServer].'!
!JadeServer64bit3x categoriesForClass!Unclassified! !
!JadeServer64bit3x methodsFor!

asString: anObject

	(anObject isKindOf: String) ifTrue: [^anObject].
	^[
		anObject printString.
	] on: Error , Admonition do: [:ex | 
		ex return: '<<printString error: ' , ex description , '>>'.
	].
!

executeString: aString fromContext: anObject

	[
		^aString
			evaluateInContext: anObject 
			symbolList: GsSession currentSession symbolList. 
	] on: CompileWarning do: [:ex | 
		ex resume.
	].
!

installTranscript

	| sessionTemps |
	Transcript class name == #'TranscriptStreamPortable' ifFalse: [^super installTranscript].
	sessionTemps := SessionTemps current.
	(sessionTemps at: #'TranscriptStream_SessionStream' ifAbsent: [nil]) notNil ifTrue: [^super installTranscript].
	sessionTemps at: #'TranscriptStream_SessionStream' put: self.
!

nextPutAll: anObject

	| exception |
	exception := ClientForwarderSend new 
		receiver: self 
		clientObj: 2
		selector:#'nextPutAll:'
		args: (Array with: (self asString: anObject)).
	exception defaultAction.  "return error direct to GCI"! !
!JadeServer64bit3x categoriesFor: #asString:!public!Transcript! !
!JadeServer64bit3x categoriesFor: #executeString:fromContext:!public! !
!JadeServer64bit3x categoriesFor: #installTranscript!public!Transcript! !
!JadeServer64bit3x categoriesFor: #nextPutAll:!public!Transcript! !

JadeServer64bit32 guid: (GUID fromString: '{B2CB5F19-4347-4B6E-922E-705E99F7CB99}')!
JadeServer64bit32 comment: ''!
!JadeServer64bit32 categoriesForClass!Unclassified! !
!JadeServer64bit32 class methodsFor!

gsClassDefinitionBlock
	"Some class variables exist only in Dolphin and map to globals in GemStone; others exist only in GemStone and map to globals in Dolphin!!"

	^[:aClass | 'class subclass: ''' , aClass name , '''
		instVarNames: ' , aClass instVarNames printString , '
		classVars: #(' , aClass classVarsForGemStone , ')
		classInstVars: #()
		poolDictionaries: #()
		inDictionary: SymbolDictionary new.'].
!

sessionStateCode
	"Avoid deprecated method and still use 'Topaz session state' (since we know Topaz isn't running!!)"

	^'System __sessionStateAt: 3 put: server.'! !
!JadeServer64bit32 class categoriesFor: #gsClassDefinitionBlock!public! !
!JadeServer64bit32 class categoriesFor: #sessionStateCode!public! !

JadeServer64bit33 guid: (GUID fromString: '{4100A18B-FBC2-4EA5-86A8-B8A8C6194269}')!
JadeServer64bit33 comment: ''!
!JadeServer64bit33 categoriesForClass!Unclassified! !
!JadeServer64bit33 methodsFor!

acceptConnection

	| listener time flag |
	listener := socket.
	socket := nil.
	time := Time millisecondsElapsedTime: [flag := listener readWillNotBlockWithin: 2000].
	flag ifFalse: [
		listener close.
		^nil
	].
	socket := listener accept.
	listener close.
	socket isNil ifTrue: [^nil].
	^time.

!

add: anObject toByteStream: aStream

	anObject == nil		ifTrue: [aStream nextPut: 0. ^self].
	anObject == true 	ifTrue: [aStream nextPut: 1. ^self].
	anObject == false 	ifTrue: [aStream nextPut: 2. ^self].
	(ExternalInteger notNil and: [anObject isKindOf: ExternalInteger]) ifTrue: [self addExternalInteger: anObject toByteStream: aStream. ^self].		"3 & 4"	(self isInDolphin and: [anObject isKindOf: GsObject]) ifTrue: [self addExternalInteger: anObject oopType toByteStream: aStream. ^self].			"3 & 4"
	(anObject isKindOf: Symbol	) ifTrue: [self addSymbol: anObject toByteStream: aStream. ^self].	"5 & 6"
	(anObject isKindOf: Integer	) ifTrue: [self addInteger: anObject toByteStream: aStream. ^self].	"7, 8, 9, & 10"
	(anObject isKindOf: String		) ifTrue: [self addString: anObject toByteStream: aStream. ^self].	"11 & 12"
	(anObject isKindOf: Array		) ifTrue: [self addArray: anObject toByteStream: aStream. ^self].	"13"
	self isInDolphin ifTrue: [self error: 'Attempt to encode an unsupported object'].
	self addPositiveInteger: anObject toByteStream: aStream.
!

addArray: anArray toByteStream: aStream

	16rFF < anArray size ifTrue: [self error: 'Array is too large!!'].
	aStream nextPut: 14; nextPut: anArray size.
	anArray do: [:each | self add: each toByteStream: aStream].
!

addExternalInteger: anObject toByteStream: aStream

	self 
		addPositiveInteger: anObject value
		toByteStream: aStream 
		code: (anObject byteSize == 4 ifTrue: [3] ifFalse: [4]) 
		size: anObject byteSize.
!

addInteger: anObject toByteStream: aStream

	| integer stream |
	(0 <= anObject and: [anObject < 16r100]) ifTrue: [
		aStream nextPut: 7; nextPut: anObject.
		^self.
	].
	(-16r100 <= anObject and: [anObject < 0]) ifTrue: [
		aStream nextPut: 8; nextPut: anObject negated - 1.
		^self.
	].
	aStream nextPut: (anObject positive ifTrue: [9] ifFalse: [10]).
	integer := anObject abs.
	stream := WriteStream on: ByteArray new.
	[
		0 < integer.
	] whileTrue: [
		stream nextPut: (integer bitAnd: 16rFF).
		integer := integer // 16r100.
	].
	aStream
		nextPut: stream contents size;
		nextPutAll: stream contents;
		yourself.
!

addPositiveInteger: anInteger toByteStream: aStream

		self
			addPositiveInteger: anInteger asOop
			toByteStream: aStream 
			code: 4 
			size: 8.
!

addPositiveInteger: anInteger toByteStream: aStream code: codeInteger size: sizeInteger

	| x |
	x := anInteger.
	aStream nextPut: codeInteger.
	sizeInteger timesRepeat: [
		aStream nextPut: (x bitAnd: 16rFF).
		x := x // 16r100.
	].
!

addString: aString toByteStream: aStream

	| size |
	(size := aString size) < 16r100 ifTrue: [
		aStream nextPut: 11; nextPut: size.
		aString do: [:each | aStream nextPut: each asciiValue].
		^self.
	].
	size < 16r1000000 ifTrue: [
		aStream nextPut: 12; nextPut: (size bitAnd: 16rFF); nextPut: (size // 16r100 bitAnd: 16rFF); nextPut: (size // 16r10000 bitAnd: 16rFF).
		aString do: [:each | aStream nextPut: each asciiValue].
		^self.
	].
	self error: 'Object cannot be encoded'.
!

addSymbol: aSymbol toByteStream: aStream

	aSymbol size <= 16rFF ifTrue: [
		aStream nextPut: 5; nextPut: aSymbol size.
		aSymbol do: [:each | aStream nextPut: each asciiValue].
		^self.
	].
	aSymbol size <= 16rFFFF ifTrue: [
		aStream nextPut: 6; nextPut: (aSymbol size bitAnd: 16rFF); nextPut: (aSymbol size // 16r100 bitAnd: 16rFF).
		aSymbol do: [:each | aStream nextPut: each asciiValue].
		^self.
	].
	self error: 'Object cannot be encoded'.
!

doSocketRequest
	"We are in a forked process.
	We provide the result or a description of an Exception on the stream."

	| arguments process receiver selector semaphore stream |
	Breakpoint trappable: true.
	process			:= Processor activeProcess.
	receiver 		:= process environmentAt: #'receiver'.
	selector 		:= process environmentAt: #'selector'.
	arguments 	:= process environmentAt: #'arguments'.
	semaphore 	:= process environmentAt: #'semaphore'.
	stream 			:= process environmentAt: #'stream'.
	[
		self add: (receiver perform: selector withArguments: arguments) toByteStream: stream.
		semaphore signal.		"we are finished and the GCI process may resume"
	] on: Exception do: [:ex | 
		GsNMethod _clearAllStepBreaks.		"We are headed into a debugger so we either hit a breakpoint or we have an unrelated error"
		stream nextPut: Character cr codePoint.
		self
			add: GemStoneError 			toByteStream: stream;
			add: ex gsNumber 			toByteStream: stream;
			add: GsProcess _current 	toByteStream: stream;
			add: ex 							toByteStream: stream;
			add: ex class name 			toByteStream: stream;
			add: ex description 			toByteStream: stream;
			add: ex gsArguments 		toByteStream: stream;
			add: (GsProcess stackReportToLevel: 100) toByteStream: stream;
			yourself.
		semaphore signal.		"GCI process may resume"
		semaphore wait.		"wait till we are told it is okay to resume"
		stream reset.
		ex resume.
	].
!

environmentAt: key

	self error: 'method included to avoid unimplemented selector warning in Dolphin'.
!

environmentAt: key put: value

	self error: 'method included to avoid unimplemented selector warning in Dolphin'.
!

isInDolphin
	"Most JadeServer code is in GemStone but the socket wire protocol encode/decode is in Dolphin as well"

	^System isNil.
!

isInGemStone
	"Most JadeServer code is in GemStone but the socket wire protocol encode/decode is in Dolphin as well"

	^System notNil.
!

makeListener

	socket := GsSocket new makeServer: 1.
	socket isNil ifTrue: [^nil].
	^socket port.
!

processAction: arguments

	| process request semaphore stream |
	process := arguments at: 1.
	semaphore := process environmentAt: #'semaphore'.
	stream := process environmentAt: #'stream'.
	stream reset.
	semaphore signal.		"okay for process to continue"
	request := arguments at: 2.
	request == #'terminate' 	ifTrue: [process terminate. self add: #'terminate' toByteStream: stream. 				^self].
	request == #'resume' 	ifTrue: [																				semaphore wait. 	^self].	"this should resume from the last line of #'doSocketRequest'."
	request == #'stepInto' 	ifTrue: [process stepIntoFromLevel: 			(arguments at: 3). 	semaphore wait. 	^self].
	request == #'stepOut' 	ifTrue: [process stepOverFromLevel: 		(arguments at: 3). 	semaphore wait. 	^self].	"1 added by JadeDebugger>>#'stepOut'"
	request == #'stepOver'	ifTrue: [process stepThroughFromLevel: 	(arguments at: 3). 	semaphore wait. 	^self].	"thru gives us more natural behavior"
	self error: 'Unrecognized command!!'.
!

readExceptionFrom: aStream errorClass: gciErrorSTypeClass

	| category number context exception name message arguments stack gciErrSType |
	category		:= self readObjectFrom: aStream.	number			:= self readObjectFrom: aStream.
	context 		:= self readObjectFrom: aStream.
	exception 		:= self readObjectFrom: aStream.
	name 			:= self readObjectFrom: aStream.	name yourself.
	message 		:= self readObjectFrom: aStream.
	arguments 	:= self readObjectFrom: aStream.
	stack 			:= self readObjectFrom: aStream.
	(gciErrSType	:= gciErrorSTypeClass new)		category: category value;
		number: number;
		context: context value;
		exceptionObj: exception value;		message: (message isNil ifTrue: [''] ifFalse: [message]);
		argCount: arguments size;
		args: arguments;
		stack: stack;
		yourself.
	GciError signalWith:  gciErrSType.
!

readObjectFrom: aStream

	^self readObjectFrom: aStream errorClass: nil.!

readObjectFrom: aStream errorClass: gciErrorSTypeClass

	| type byteSize bytes oid x |
	type := aStream next.
	type == 0 ifTrue: [^nil].
	(type == 1 or: [type == 2]) ifTrue: [
		^type == 1.
	].
	(type == 3 or: [type == 4]) ifTrue: [
		byteSize := type == 3 ifTrue: [4] ifFalse: [8].
		bytes := aStream next: byteSize.
		oid := 0.
		bytes reverseDo: [:each |
			oid := oid * 16r100 + each.
		].
		^System notNil
			ifTrue: [self objectForOop: oid]	"Usually this will execute in GemStone"
			ifFalse: [type == 3			"This can execute in Dolphin to support testing"
				ifTrue: [OopType32 fromInteger: oid]
				ifFalse: [OopType64 fromInteger: oid]
			].
	].
	type == 5 ifTrue: [		"Symbol with size < 256"
		bytes := aStream next: aStream next.
		x := String new: bytes size.
		1 to: bytes size do: [:i | 
			x at: i put: (Character codePoint: (bytes at: i)).
		].
		^x asSymbol.
	].
	type == 6 ifTrue: [		"Symbol with size >= 256"
		x := aStream next + (aStream next * 16r100).
		bytes := aStream next: x.
		x := String new: bytes size.
		1 to: bytes size do: [:i | 
			x at: i put: (Character codePoint: (bytes at: i)).
		].
		^x asSymbol.
	].
	type == 7 ifTrue: [		"SmallInteger 0 <= x < 256"
		^aStream next.
	].
	type == 8 ifTrue: [		"SmallInteger: -256 <= x < 0"
		^(aStream next + 1) negated
	].
	(type == 9 or: [type == 10]) ifTrue: [
		| integer |
		byteSize := aStream next.
		bytes := aStream next: byteSize.
		integer := 0.
		bytes reverseDo: [:each |
			integer := integer * 16r100 + each.
		].
		^integer * (type == 9 ifTrue: [1] ifFalse: [-1]).
	].
	type == 11 ifTrue: [		"String with size < 256"
		bytes := aStream next: aStream next.
		x := String new: bytes size.
		1 to: bytes size do: [:i | 
			x at: i put: (Character codePoint: (bytes at: i)).
		].
		^x.
	].
	type == 12 ifTrue: [		"String with size >= 256"
		x := aStream next + (aStream next * 16r100) + (aStream next * 16r10000).
		bytes := aStream next: x.
		x := String new: bytes size.
		1 to: bytes size do: [:i | 
			x at: i put: (Character codePoint: (bytes at: i)).
		].
		^x.
	].
	type == 13 ifTrue: [		"GciErrSType"
		^self readExceptionFrom: aStream errorClass: gciErrorSTypeClass.
	].
	type == 14 ifTrue: [		"Array"
		x := Array new: aStream next.
		1 to: x size do: [:i | x at: i put: (self readObjectFrom: aStream)].
		^x.
	].
!

readSocket: anInteger

	| arguments bytes process receiver selector semaphore stream |	bytes := ByteArray new.	[		bytes size < anInteger.
	] whileTrue: [
		socket read: anInteger - bytes size into: bytes startingAt: bytes size + 1.
	].
	stream := ReadStream on: bytes.
	receiver := self readObjectFrom: stream.
	selector := self readObjectFrom: stream.
	arguments := self readObjectFrom: stream.
	(receiver == self and: [selector == #'processAction:']) ifTrue: [	"We already have a process so should not fork again!!"
		process := arguments at: 1.
		process environmentAt: #'parent' put: Processor activeProcess.		"ignore me when returning a list of processes"
		stream := process environmentAt: #'stream'.
		self processAction: arguments.
	] ifFalse: [		"This is the first time with this command so create a new process to handle request"
		process := [self doSocketRequest] newProcess.
		process 
			environmentAt: #'receiver'		put: receiver;
			environmentAt: #'selector'		put: selector;
			environmentAt: #'arguments'	put: arguments;
			environmentAt: #'semaphore'	put: (semaphore := Semaphore new);
			environmentAt: #'stream'		put: (stream := WriteStream on: ByteArray new);
			environmentAt: #'parent' 		put: Processor activeProcess;		"ignore me when returning a list of processes"
			resume.
		semaphore wait.	"we wait while the process runs"
	].
	bytes := stream contents.
	socket write: bytes.
	^bytes size.
! !
!JadeServer64bit33 categoriesFor: #acceptConnection!public! !
!JadeServer64bit33 categoriesFor: #add:toByteStream:!public!streaming! !
!JadeServer64bit33 categoriesFor: #addArray:toByteStream:!public!streaming! !
!JadeServer64bit33 categoriesFor: #addExternalInteger:toByteStream:!public!streaming! !
!JadeServer64bit33 categoriesFor: #addInteger:toByteStream:!public!streaming! !
!JadeServer64bit33 categoriesFor: #addPositiveInteger:toByteStream:!public!streaming! !
!JadeServer64bit33 categoriesFor: #addPositiveInteger:toByteStream:code:size:!public!streaming! !
!JadeServer64bit33 categoriesFor: #addString:toByteStream:!public!streaming! !
!JadeServer64bit33 categoriesFor: #addSymbol:toByteStream:!public!streaming! !
!JadeServer64bit33 categoriesFor: #doSocketRequest!public!Socket! !
!JadeServer64bit33 categoriesFor: #environmentAt:!public!Socket! !
!JadeServer64bit33 categoriesFor: #environmentAt:put:!public!Socket! !
!JadeServer64bit33 categoriesFor: #isInDolphin!public!testing! !
!JadeServer64bit33 categoriesFor: #isInGemStone!public!testing! !
!JadeServer64bit33 categoriesFor: #makeListener!public! !
!JadeServer64bit33 categoriesFor: #processAction:!public!Socket! !
!JadeServer64bit33 categoriesFor: #readExceptionFrom:errorClass:!public!Socket! !
!JadeServer64bit33 categoriesFor: #readObjectFrom:!public!streaming! !
!JadeServer64bit33 categoriesFor: #readObjectFrom:errorClass:!public!streaming! !
!JadeServer64bit33 categoriesFor: #readSocket:!public!Socket! !

GsBreakDialog guid: (GUID fromString: '{4D16A999-7457-4B6C-A8F3-40B6ECD5A7AD}')!
GsBreakDialog comment: ''!
!GsBreakDialog categoriesForClass!Unclassified! !
!GsBreakDialog methodsFor!

dolphinBreak

	self value: #dolphinBreak.
	self ok.
!

hardBreak

	self value: #hardBreak.
	self ok.
!

queryCommand: aCommandQuery

	aCommandQuery commandSymbol = #dolphinBreak ifTrue: [
		aCommandQuery isEnabled: SessionManager isRuntime not.
		^true.
	].
	^super queryCommand: aCommandQuery.
!

softBreak

	self value: #softBreak.
	self ok.
! !
!GsBreakDialog categoriesFor: #dolphinBreak!public! !
!GsBreakDialog categoriesFor: #hardBreak!public! !
!GsBreakDialog categoriesFor: #queryCommand:!public! !
!GsBreakDialog categoriesFor: #softBreak!public! !

!GsBreakDialog class methodsFor!

icon

	^Icon fromFile: 'icons\GS32x32.ico'.
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 0 234 256 98 0 590342 ##(Smalltalk.Rectangle)  328198 ##(Smalltalk.Point)  21 21 626 21 21 0 0 0 0 12485 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2118378847 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 626 2799 21 626 441 341 416 786 8 #text: 98 1 8 'User Interrupt Requested' 416 786 8 #updateMenuBar 576 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 83 6 0 0 180 0 0 0] 98 7 410 8 ##(Smalltalk.PushButton)  98 17 0 416 98 2 8 1140924416 1 1040 0 0 0 7 0 0 0 1040 0 8 4294903631 1180998 4 ##(Smalltalk.CommandDescription)  8 #softBreak 8 '&Soft Break' 1 1 0 0 16 722 202 208 98 3 786 816 98 2 626 91 61 626 141 51 1040 786 8 #isEnabled: 98 1 32 1040 786 896 98 1 8 '&Soft Break' 1040 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 45 0 0 0 30 0 0 0 115 0 0 0 55 0 0 0] 98 0 626 193 193 0 27 410 1056 98 17 0 416 98 2 8 1140924416 1 1472 0 0 0 7 0 0 0 1472 0 8 4294903631 1138 8 #hardBreak 8 '&Hard Break' 1 1 0 0 32 722 202 208 98 3 786 816 98 2 626 241 61 626 141 51 1472 786 1328 98 1 32 1472 786 896 98 1 8 '&Hard Break' 1472 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 120 0 0 0 30 0 0 0 190 0 0 0 55 0 0 0] 98 0 1456 0 27 410 1056 98 17 0 416 98 2 8 1140924416 1 1840 0 0 0 7 0 0 0 1840 0 8 4294903631 1138 8 #dolphinBreak 8 '&Dolphin' 1 1 0 0 32 722 202 208 98 3 786 816 98 2 626 241 121 626 141 51 1840 786 1328 98 1 32 1840 786 896 98 1 8 '&Dolphin' 1840 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 120 0 0 0 60 0 0 0 190 0 0 0 85 0 0 0] 98 0 1456 0 27 410 1056 98 17 0 416 98 2 8 1140924416 1 2208 0 0 0 7 0 0 0 2208 0 8 4294903631 1138 8 #cancel 8 '&Cancel' 1 1 0 0 32 722 202 208 98 3 786 816 98 2 626 241 181 626 141 51 2208 786 1328 98 1 32 2208 786 896 98 1 8 '&Cancel' 2208 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 120 0 0 0 90 0 0 0 190 0 0 0 115 0 0 0] 98 0 1456 0 27 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850944 1 2576 0 0 0 7 0 0 0 2576 0 8 4294903639 852486 ##(Smalltalk.NullConverter)  0 0 0 722 202 208 98 2 786 816 98 2 626 1 11 626 431 41 2576 786 896 98 1 8 ' Interrupt GemStone execution with:' 2576 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 215 0 0 0 25 0 0 0] 98 0 1456 0 27 410 2592 98 16 0 416 98 2 8 1140850944 1 2912 0 0 0 7 0 0 0 2912 0 8 4294903639 2674 0 0 0 722 202 208 98 2 786 816 98 2 626 1 131 626 211 41 2912 786 896 98 1 8 ' Interrupt Dolphin:' 2912 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 0 0 0 105 0 0 0 85 0 0 0] 98 0 1456 0 27 410 2592 98 16 0 416 98 2 8 1140850944 1 3216 0 0 0 7 0 0 0 3216 0 8 4294903639 2674 0 0 0 722 202 208 98 2 786 816 98 2 626 1 191 626 201 41 3216 786 896 98 1 8 ' Ignore interrupt:' 3216 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 95 0 0 0 100 0 0 0 115 0 0 0] 98 0 1456 0 27 1456 0 27 )! !
!GsBreakDialog class categoriesFor: #icon!public! !
!GsBreakDialog class categoriesFor: #resource_Default_view!public!resources-views! !

JadeServerTestCase guid: (GUID fromString: '{494DCD74-2E61-4AA2-9836-C23515C37947}')!
JadeServerTestCase comment: ''!
!JadeServerTestCase categoriesForClass!Unclassified! !
!JadeServerTestCase methodsFor!

testSocket

	| encoder stream x |
	encoder := JadeServer new.
	stream := WriteStream on: ByteArray new.
	encoder
		add: nil toByteStream: stream;
		add: true toByteStream: stream;
		add: false toByteStream: stream;
		add: (OopType32 fromInteger: 123456) toByteStream: stream;
		add: (OopType64 fromInteger: 12345678) toByteStream: stream;
		add: #'foo' toByteStream: stream;
		add: 0 toByteStream: stream;
		add: 255 toByteStream: stream;
		add: 'bar' toByteStream: stream;
		add: ((String new: 256) atAllPut: $x) asSymbol toByteStream: stream;
		add: -1 toByteStream: stream;
		add: -256 toByteStream: stream;
		add: 256 toByteStream: stream;
		add: SmallInteger maximum toByteStream: stream;
		add: SmallInteger minimum toByteStream: stream;
		add: SmallInteger maximum + 1 toByteStream: stream;
		add: SmallInteger minimum - 1 toByteStream: stream;
		add: ((String new: 256) atAllPut: $x) toByteStream: stream;
		add: #(nil true false #(1 'abc' #'foo')) toByteStream: stream;
		add: nil toByteStream: stream;
		yourself.
	stream := ReadStream on: stream contents.
	self 
		assert: (encoder readObjectFrom: stream) == nil;
		assert: (encoder readObjectFrom: stream) == true;
		assert: (encoder readObjectFrom: stream) == false;
		assert: (x := encoder readObjectFrom: stream) class == OopType32;
		assert: x value == 123456;
		assert: (x := encoder readObjectFrom: stream) class == OopType64;
		assert: x value == 12345678;
		assert: (encoder readObjectFrom: stream) == #'foo';
		assert: (encoder readObjectFrom: stream) == 0;
		assert: (encoder readObjectFrom: stream) == 255;
		assert: (encoder readObjectFrom: stream) = 'bar';
		assert: (x := encoder readObjectFrom: stream) class == Symbol;
		assert: x size == 256;
		assert: (encoder readObjectFrom: stream) == -1;
		assert: (encoder readObjectFrom: stream) == -256;
		assert: (encoder readObjectFrom: stream) == 256;
		assert: (encoder readObjectFrom: stream) == SmallInteger maximum;
		assert: (encoder readObjectFrom: stream) == SmallInteger minimum;
		assert: (encoder readObjectFrom: stream) = (SmallInteger maximum + 1);
		assert: (encoder readObjectFrom: stream) = (SmallInteger minimum - 1);
		assert: (x := encoder readObjectFrom: stream) class == String;
		assert: x size == 256;
		assert: (x := encoder readObjectFrom: stream) = #(nil true false #(1 'abc' #'foo'));
		assert: (encoder readObjectFrom: stream) == nil;
		yourself.
! !
!JadeServerTestCase categoriesFor: #testSocket!public! !

"Binary Globals"!

