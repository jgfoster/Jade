﻿"Filed out from Dolphin Smalltalk"!

Model subclass: #JadeLogin
	instanceVariableNames: 'debugPath gemHost gemNRS gemService gemTask gemType gemVersion gsPassword gsUserID hostPassword hostUserID initials lastLogin loginType session stoneHost stoneName stoneNRS transcript'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

JadeLogin guid: (GUID fromString: '{585bd13e-3a03-47f3-b78d-5c29ef797913}')!

JadeLogin comment: ''!

!JadeLogin categoriesForClass!Unclassified! !

!JadeLogin methodsFor!

asXML

	| doc root |
	doc := IXMLDOMDocument new.
	root := (doc createElement: 'JadeLogin')
		setAttribute: 'gemVersion' 		value: gemVersion;
		setAttribute: 'stoneHost' 		value: stoneHost;
		setAttribute: 'stoneName' 		value: stoneName;
		setAttribute: 'stoneNRS' 		value: stoneNRS;
		setAttribute: 'gemType' 		value: gemType;
		setAttribute: 'gemHost' 		value: gemHost;
		setAttribute: 'gemService' 		value: gemService;
		setAttribute: 'gemNRS' 		value: gemNRS;
		setAttribute: 'hostUserID' 		value: hostUserID;
		setAttribute: 'hostPassword' 	value: hostPassword;
		setAttribute: 'gsUserID' 		value: gsUserID;
		setAttribute: 'gsPassword' 		value: gsPassword;
		setAttribute: 'initials'			value: initials;
		yourself.
	doc setDocumentElement: root.
	^doc xml.
!

debugPath

	^debugPath ifNil: [''].
!

debugPath: aString

	self debugPath = aString ifTrue: [^self].
	debugPath := aString.
!

gemHost

	gemHost ifNil: [gemHost := ''].
	gemHost isEmpty ifTrue: [^'localhost'].
	^gemHost
!

gemHost: aString

	self gemHost = aString ifTrue: [^self].
	gemHost := aString.
	self generateGemNRS.
!

gemNRS

	gemType = #linked ifTrue: [^''].
	^gemNRS!

gemNRS: aString

	self gemNRS = aString ifTrue: [^self].
	gemNRS := aString.
!

gemService

	^gemService.
!

gemService: aString

	self gemService = aString ifTrue: [^self].
	gemService := aString.
	self generateGemNRS.
!

gemTask

	gemTask ifNil: [gemTask := ''].
	gemTask isEmpty ifTrue: [^'gemnetobject'].
	^gemTask
!

gemTask: aString

	self gemTask = aString ifTrue: [^self].
	gemTask := aString.
	self generateGemNRS.
!

gemType
	^gemType!

gemType: aSymbol

	(#( #linked #remote ) includes: aSymbol) ifFalse: [self error: 'Invalid Gem type'].
	self gemType = aSymbol ifTrue: [^self].
	gemType := aSymbol.
!

gemVersion

	gemVersion ifNil: [gemVersion := ''].
	gemVersion isEmpty ifTrue: [^Gcilw6x displayName].
	^gemVersion!

gemVersion: aString 
	gemVersion := aString!

generateGemNRS

	gemNRS := '!!tcp@' , self gemHost , '#netldi:' , self gemService , '#task!!' , self gemTask.
!

generateStoneNRS

	stoneNRS := '!!tcp@' , self stoneHost , '#server!!' , self stoneName.
!

gsPassword

	gsPassword ifNil: [gsPassword := ''].
	gsPassword isEmpty ifTrue: [^'swordfish'].
	^gsPassword.
!

gsPassword: aString

	self gsPassword = aString ifTrue: [^self].
	gsPassword := aString.
!

gsUserID

	gsUserID ifNil: [gsUserID := ''].
	gsUserID isEmpty ifTrue: [^'DataCurator'].
	^gsUserID.
!

gsUserID: aString

	self gsUserID = aString ifTrue: [^self].
	gsUserID := aString.
!

hostPassword
	^hostPassword!

hostPassword: aString

	self hostPassword = aString ifTrue: [^self].
	hostPassword := aString.
!

hostUserID
	^hostUserID!

hostUserID: aString

	self hostUserID = aString ifTrue: [^self].
	hostUserID := aString.
!

icon

	(session notNil and: [session isValidSession not]) ifTrue: [session := nil].
	session notNil ifTrue: [^Icon fromId: 'InputState.ico'].		"green - logged in"
	self isAbleToLoadLibrary ifTrue: [^Icon fromId: 'Event.ico'].	"yellow - can log in"
	^Icon fromFile: 'icons\EditDelete.ico' usingLocator: ImageRelativeFileLocator new	"red - not available because we have another DLL loaded"
!

initializeFromXML: aString

	| element |
	element := (IXMLDOMDocument new loadText: aString) documentElement.
	element baseName = 'JadeLogin' ifFalse: [self error: 'Invalid document!!'].
	gemVersion	:= (element getAttribute: 'gemVersion'	) ifNil: [''].
	stoneHost	:= (element getAttribute: 'stoneHost'		) ifNil: [''].
	stoneName	:= (element getAttribute: 'stoneName'		) ifNil: [''].
	stoneNRS	:= (element getAttribute: 'stoneNRS'		) ifNil: [''].
	gemType		:= (element getAttribute: 'gemType'		) asSymbol.
	gemHost		:= (element getAttribute: 'gemHost'		) ifNil: [''].
	gemService	:= (element getAttribute: 'gemService'		) ifNil: [''].
	gemNRS		:= (element getAttribute: 'gemNRS'		) ifNil: [''].
	loginType	:= (element getAttribute: 'loginType'		) ifNil: [''].
	loginType 	:= loginType isNil ifTrue: [#'guest'] ifFalse: [loginType asSymbol].
	hostUserID	:= (element getAttribute: 'hostUserID'		) ifNil: [''].
	hostPassword	:= (element getAttribute: 'hostPassword'	) ifNil: [''].
	gsUserID		:= (element getAttribute: 'gsUserID'		) ifNil: [''].
	gsPassword	:= (element getAttribute: 'gsPassword'		) ifNil: [''].
	initials		:= (element getAttribute: 'initials'			) ifNil: [''].
!

initials

	initials ifNil: [initials := ''].
	initials isEmpty ifTrue: [^'Jade'].
	^initials.
!

initials: aString

	self initials = aString ifTrue: [^self].
	initials := aString.
!

isAbleToLoadLibrary

	| library |
	^(library := GciLibrary activeLibrary) isNil or: [library class displayName = self gemVersion]!

lastLogin

	^lastLogin
!

lastLoginString

	^self lastLogin 
		ifNil: ['']
		ifNotNil: [:value | value printString]
!

login

	| libraryClass |
	libraryClass := GciLibrary withDisplayName: gemVersion.
	^libraryClass gciSessionClass
		libraryClass: libraryClass
		stoneNRS: self stoneNRS
		gemNRS: self gemNRS
		userID: self gsUserID
		password: self gsPassword
		hostUserID: self hostUserID
		password: self hostPassword
		initials: self initials
		debugPath: self debugPath!

loginType
	^loginType.
!

loginType: anObject

	loginType 		:= anObject.
	hostUserID 	:= ''.
	hostPassword 	:= ''.
!

postCopy

	super postCopy.
	lastLogin 	:= nil.
	session	:= nil.
	transcript 	:= nil.
!

saveDefault

	| path |
	path := self class defaultPath.
	[
		(FileStream write: path mode: #'truncate' check: false type: #'ansi')	"https://github.com/jgfoster/Jade/issues/151"
			nextPutAll: self asXML;
			close.
	] on: Error do: [:ex | 
		MessageBox errorMsg: 'JadeLogin>>#''saveDefault'' resulted in ' , ex description.
		ex return.
	].
!

session

	^session!

session: aGciSession

	session := aGciSession.
	lastLogin := DateAndTime now.
!

stoneHost

	stoneHost ifNil: [stoneHost := ''].
	stoneHost isEmpty ifTrue: [^'localhost'].
	^stoneHost!

stoneHost: aString

	self stoneHost = aString ifTrue: [^self].
	stoneHost := aString.
	self generateStoneNRS.

!

stoneName

	^stoneName.
!

stoneName: aString

	self stoneName = aString ifTrue: [^self].
	stoneName := aString.
	self generateStoneNRS.
!

stoneNRS
	^stoneNRS!

stoneNRS: aString

	self stoneNRS = aString ifTrue: [^self].
	stoneNRS := aString.
!

transcript

	^transcript
!

transcript: aJadeTranscript

	transcript := aJadeTranscript.
! !

!JadeLogin categoriesForMethods!
asXML!public! !
debugPath!accessing!public! !
debugPath:!accessing!public! !
gemHost!accessing!public! !
gemHost:!accessing!public! !
gemNRS!accessing!public! !
gemNRS:!accessing!public! !
gemService!accessing!public! !
gemService:!accessing!public! !
gemTask!accessing!public! !
gemTask:!accessing!public! !
gemType!accessing!public! !
gemType:!accessing!public! !
gemVersion!accessing!public! !
gemVersion:!public! !
generateGemNRS!private! !
generateStoneNRS!private! !
gsPassword!accessing!public! !
gsPassword:!accessing!public! !
gsUserID!accessing!public! !
gsUserID:!accessing!public! !
hostPassword!accessing!public! !
hostPassword:!accessing!public! !
hostUserID!accessing!public! !
hostUserID:!accessing!public! !
icon!public! !
initializeFromXML:!public! !
initials!accessing!public! !
initials:!accessing!public! !
isAbleToLoadLibrary!public! !
lastLogin!accessing!public! !
lastLoginString!accessing!public! !
login!public! !
loginType!accessing!public! !
loginType:!accessing!public! !
postCopy!public! !
saveDefault!public! !
session!accessing!public! !
session:!accessing!public! !
stoneHost!accessing!public! !
stoneHost:!accessing!public! !
stoneName!accessing!public! !
stoneName:!accessing!public! !
stoneNRS!accessing!public! !
stoneNRS:!accessing!public! !
transcript!accessing!public! !
transcript:!accessing!public! !
!

!JadeLogin class methodsFor!

default
	"Edited to address https://github.com/jgfoster/Jade/issues/262"

	^[
		| path stream string |
		path := self defaultPath.
		stream := FileStream read: path type: #'ansi'.
		string := stream upToEnd.
		stream close.
		self fromXML: string.
	] on: Error do: [:ex | 	"file doesn't exist or we have an error reading it"
		ex return: (self fromXML: self defaultXML).
	].
!

defaultPath

	| regKey appData |
	regKey := RegKey userRoot at: 'Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' ifAbsent: [nil].
	appData := regKey valueAt: 'AppData'.
	(appData endsWith: ' Dat') ifTrue: [appData := appData , 'a'].		"Wine seems to cut off a character"
	^appData , '\JadeDefaultConnection.gss'.
!

defaultXML

^'<?xml version="1.0"?>
<JadeLogin 
	gemVersion="64-bit 3.5.2" 
	stoneHost="localhost" 
	stoneName="gs64stone" 
	stoneNRS="!!tcp@localhost#server!!gs64stone" 
	gemType="remote" 
	gemHost="localhost" 
	gemService="gs64ldi" 
	gemNRS="!!tcp@localhost#netldi:gs64ldi#task!!gemnetobject" 
	loginType="guest"
	hostUserID="" 
	hostPassword="" 
	gsUserID="DataCurator" 
	gsPassword="swordfish"
	initials="MyName"
	useSocket="false"
	debugPath=""
/>
'.
!

fromXML: aString

	^super new
		initializeFromXML: aString;
		yourself.
!

new

	^self fromXML: self defaultXML
! !

!JadeLogin class categoriesForMethods!
default!public! !
defaultPath!public! !
defaultXML!public! !
fromXML:!public! !
new!public! !
!

