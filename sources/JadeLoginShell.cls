"Filed out from Dolphin Smalltalk"!

Shell subclass: #JadeLoginShell
	instanceVariableNames: 'activeLibraryPresenter activityListMutex activityListPresenter debugPathPresenter gemHostPresenter gemServicePresenter gemTaskPresenter gemTypePresenter hostPasswordPresenter hostUserIDPresenter initialsPresenter inUpdateView loginListPresenter loginTypePresenter passwordPresenter recentActivity resetButtonPresenter stoneHostPresenter stoneNamePresenter userIDPresenter versionListPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeLoginShell guid: (GUID fromString: '{0fa658ce-d1b0-40d0-9305-5830b29aed32}')!
JadeLoginShell comment: 'model - an instance of JadeLogin (treated as a document)
'!
!JadeLoginShell categoriesForClass!Unclassified! !
!JadeLoginShell methodsFor!

aboutJade
	"See also JadeTextDocument>>#'aboutJade'"

	| version |
	version := [
		SessionManager current isRuntime 
		ifTrue: [SessionManager current version] 
		ifFalse: ['<Development>']
	] on: Error do: [:ex | 
		ex return: ex description printString.
	].
	MessageBox 
		notify: 
'Jade is an Alternative Development Environment (JADE) for
GemStone/Smalltalk that provides developer tools (Browsers 
and Workspaces) as an alternative to Topaz or GBS.

Jade was inspired by, built in, and includes components from 
Dolphin Smalltalk at http://www.object-arts.com.

Version ' , version , ' built by James Foster
with contributions from Bruno Buzzi Brassesco.'
		caption: 'About Jade'.
!

addLogin

	| login |
	login := loginListPresenter selectionOrNil 
		ifNil: [JadeLogin default]
		ifNotNil: [:value | value copy].
	loginListPresenter 
		list: (loginListPresenter list copyWith: login);
		selection: login;
		yourself.
!

breakBlock: aBlock

	activityListPresenter selectionOrNil ifNil: [
		Sound beep.
	] ifNotNil: [:activity | 
		activity canBreak ifTrue: [
			aBlock value: GciLibrary activeLibrary value: activity sessionId.
		] ifFalse: [
			Sound beep.
		].
	].
!

checkScintillaVersion

	| expected actual |
	expected := ScintillaLibrary versionString.
	actual := ScintillaLibrary versionInfo productVersionString.
	expected = actual ifTrue: [^self].
	MessageBox warning: 'SciLexer.dll is version ' , actual , ' and we expected ' , expected , '
Please consider downloading the latest product package!!'
!

copyXML

	Clipboard current setText: loginListPresenter selection asXML.
	Sound informationBeep.
!

createComponents

	super createComponents.
	versionListPresenter	:= self add: ListPresenter				new name: 'versionList'.
	stoneHostPresenter 	:= self add: TextPresenter 			new name: 'stoneHost'.
	stoneNamePresenter 	:= self add: TextPresenter 			new name: 'stoneName'.
	gemTypePresenter 		:= self add: RadioButtonSetPresenter 	new name: 'gemType'.
	gemHostPresenter 		:= self add: TextPresenter 			new name: 'gemHost'.
	gemServicePresenter 	:= self add: TextPresenter 			new name: 'gemService'.
	gemTaskPresenter 		:= self add: TextPresenter 			new name: 'gemTask'.
	userIDPresenter 		:= self add: TextPresenter 			new name: 'userID'.
	passwordPresenter 	:= self add: TextPresenter 			new name: 'password'.
	loginListPresenter		:= self add: ListPresenter				new name: 'loginList'.
	loginTypePresenter 	:= self add: RadioButtonSetPresenter 	new name: 'loginType'.
	hostUserIDPresenter	:= self add: TextPresenter			new name: 'hostUserID'.
	hostPasswordPresenter	:= self add: TextPresenter			new name: 'hostPassword'.
	initialsPresenter		:= self add: TextPresenter			new name: 'initials'.
	debugPathPresenter	:= self add: TextPresenter			new name: 'debugPath'.

	activeLibraryPresenter	:= self add: TextPresenter			new name: 'activeLibrary'.
	activityListPresenter	:= self add: ListPresenter				new name: 'activityList'.
!

createSchematicWiring

	super createSchematicWiring.
	loginListPresenter	
		when: #'selectionChanged'	send: #'selectionChanged' 	to: self;
		when: #'actionPerformed'	send: #'openLogin'			to: self;
		yourself.
	versionListPresenter	when: #selectionChanged 	send: #modified 	to: self.
	stoneHostPresenter 	when: #valueChanged 		send: #modified 	to: self.
	stoneNamePresenter 	when: #valueChanged 		send: #modified 	to: self.
	gemTypePresenter		when: #valueChanged 		send: #modified 	to: self.
	gemHostPresenter 		when: #valueChanged 		send: #modified 	to: self.
	gemServicePresenter 	when: #valueChanged 		send: #modified 	to: self.
	gemTaskPresenter 		when: #valueChanged 		send: #modified 	to: self.
	userIDPresenter 		when: #valueChanged 		send: #modified 	to: self.
	passwordPresenter 	when: #valueChanged 		send: #modified 	to: self.
	loginTypePresenter		when: #valueChanged 		send: #modified 	to: self.
	hostUserIDPresenter	when: #valueChanged 		send: #modified 	to: self.
	hostPasswordPresenter	when: #valueChanged 		send: #modified 	to: self.
	initialsPresenter		when: #valueChanged		send: #modified 	to: self.
	debugPathPresenter	when: #valueChanged		send: #modified 	to: self.
	self					when: #closeRequested:		send: #saveData	to: self.

	GciActivity activity 		when:  #changed			send: #'updateActivity'  to: self.!

dataPath

	| regKey appData |
	regKey := RegKey userRoot at: 'Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' ifAbsent: [nil].
	appData := regKey valueAt: 'AppData'.
	(appData endsWith: ' Dat') ifTrue: [appData := appData , 'a'].		"Wine seems to cut off a character"
	^appData , '\JadeData.gss'.
!

debugGCI

	| default fileTypes path |
	default := debugPathPresenter value.
	default isEmpty ifTrue: [default := File workingDirectory , 'gciDebug.log'].
	fileTypes := 	#( 
		('Text Files (*.txt)' '*.txt')
		('Log Files (*.log)' '*.log')
		('All Files (*.*)' '*.*')).
	path := FileSaveDialog new
		caption: 'Add GCI debug information to log file';
		fileTypes: fileTypes;
		defaultExtension: 'log';
		value: default;
		showModal.
	debugPathPresenter value: (path ifNil: ['']).
!

editCopy

	| textView |
	textView := View focus.
	(textView isKindOf: TextEdit) ifFalse: [^Sound beep].
	textView hasSelection ifFalse: [^Sound beep].
	textView copySelection.
!

editCut

	| textView |
	textView := View focus.
	(textView isKindOf: TextEdit) ifFalse: [^Sound beep].
	textView hasSelection ifFalse: [^Sound beep].
	textView cutSelection.
!

editDelete

	| textView |
	textView := View focus.
	(textView isKindOf: TextEdit) ifFalse: [^Sound beep].
	textView clearSelection.
!

editPaste

	| textView |
	textView := View focus.
	(textView isKindOf: TextEdit) ifFalse: [^Sound beep].
	textView canPaste ifFalse: [^Sound beep].
	textView pasteClipboard.
!

editRedo

	View focus redo.
!

editSelectAll

	| textView |
	textView := View focus.
	(textView isKindOf: TextEdit) ifFalse: [^Sound beep].
	textView selectAll.
!

editUndo

	View focus undo.
!

enableWindow

	activityListPresenter selectionOrNil ifNil: [
		Sound beep.
	] ifNotNil: [:activity | 
		activity enableWindow.
	].
!

exportActivity

	| default fileTypes path file |
	default := File workingDirectory , 'gcActivity.log'.
	fileTypes := #( 
		('Text Files (*.txt)' '*.txt')
		('Log Files (*.log)' '*.log')
		('All Files (*.*)' '*.*')).
	path := FileSaveDialog new
		caption: 'Export GCI Activity to File';
		fileTypes: fileTypes;
		defaultExtension: 'log';
		value: default;
		overwritePrompt;
		showModal.
	file := FileStream write: path mode: #'truncate' check: false type: #'utf8'.
	[
		GciActivity activity do: [:each | each writeOn: file].
	] ensure: [
		file close.
	].
!

fileOpen

	| path |
	path := FileOpenDialog new
		caption: 'Open logins';
		fileTypes: (Array with: #('GemStone/S Logins (*.GSS)' '*.GSS' ) with: #('All Files (*.*)' '*.*' ));
		defaultExtension: 'gss';
		showModal.
	path isNil ifTrue: [^self].
	self loadDataFrom: path.
!

fileSave

	| path |
	path := FileSaveDialog new
		caption: 'Save logins';
		fileTypes: (Array with: #('GemStone/S Logins (*.GSS)' '*.GSS' ) with: #('All Files (*.*)' '*.*' ));
		defaultExtension: 'log';
		overwritePrompt;
		showModal.
	path isNil ifTrue: [^self].
	self saveDataTo: path.
!

fillVersionList

	| list |
	list := GciLibrary allSubclasses collect: [:each | each displayName].
	list := list reject: [:each | each isNil].
	list := list asSortedCollection: [:a :b | self isVersion: a lessThanOrEqualTo: b].
	versionListPresenter list: list!

hardBreak

	self breakBlock: [:library :sessionId | library hardBreakSession: sessionId].
!

initialize

	super initialize.
	inUpdateView := false.
	activityListMutex := Semaphore forMutualExclusion.
!

isVersion: a lessThanOrEqualTo: b

	| aList bList |
	aList := a subStrings: $. .
	bList := b subStrings: $. .
	1 to: aList size do: [:i | 
		| x y |
		bList size < i ifTrue: [^false].
		x := aList at: i.
		y := bList at: i.
		((x allSatisfy: [:each | each isDigit]) and: [y allSatisfy: [:each | each isDigit]]) ifTrue: [
			x := x asNumber.
			y := y asNumber.
		].
		x < y ifTrue: [^true].
		x = y ifFalse: [^false].
	].
	^true.
!

loadData

	| path tempPath |
	path := self dataPath.
	tempPath := self tempDataPath.
	((File exists: path) not and: [File exists: tempPath]) ifTrue: [
		File rename: tempPath to: path.
	].
	self loadDataFrom: path.
!

loadDataFrom: aPath

	| data |
	[
		| fileStream |
		fileStream := FileStream read: aPath type: #'binary'.
		data := Object binaryReadFrom: fileStream.
		fileStream close.
	] on: Error do: [:ex | 
		data := OrderedCollection new.
	].
	data size < 1 ifTrue: [data add: (OrderedCollection with: JadeLogin default)].
	data size < 2 ifTrue: [data add: data first first].
	data size < 3 ifTrue: [data add: JadePreferencesPresenter defaultFont].
	data size < 4 ifTrue: [data add: JadePreferencesPresenter codeFont].
	loginListPresenter 
		list: (data at: 1);
		selectionOrNil: (data at: 2);
		yourself.
	JadePreferencesPresenter defaultFont: (data at: 3).
	JadePreferencesPresenter codeFont: (data at: 4).
!

login

	| cardContainerView session |
	cardContainerView := self view viewNamed: 'cardContainer'.
	self updateModel.
	self model isAbleToLoadLibrary ifFalse: [
		Sound beep.
		^self
	].
	[
		SessionManager inputState pumpMessages.
		session := self model login.
	] on: Error do: [:ex | 
		MessageBox 
			errorMsg: ex description
			caption: 'Jade Login Error'.
		SessionManager current pause.
		^self.
	]. 
	self postLogin: session.
	activeLibraryPresenter value: GciLibrary activeLibrary class name asString.
!

logout: aLogin

	aLogin
		session: nil;
		transcript: nil;
		yourself.
	loginListPresenter view updateAll.
!

modified

	inUpdateView ifTrue: [^self].
	self updateModel.
	loginListPresenter view updateAll.!

onCloseRequested

	JadeLog log: 'JadeLoginShell>>onCloseRequested at ' , DateAndTime now printString.
	^super onCloseRequested!

onViewOpened

	super onViewOpened.
	self view position: 80 @ 5.
	self 
		fillVersionList;
		loadData;
		updateView;
		sendRequiredMessages;
		yourself.
	[self checkScintillaVersion] postToMessageQueue.
	activityListPresenter list: GciActivity activity.
	(self view viewNamed: 'cardContainer') firstCard.

!

openConsole

	KernelLibrary default 
		allocConsole; 
		setConsoleTitle: 'Jade Console';
		setConsoleOutputCP: 65001; "CP_UTF8"
		setConsoleCP: 65001; "CP_UTF8"
		yourself.
!

openExeDir

	[
		ShellLibrary default shellOpen: (SessionManager current getenv: 'LOCALAPPDATA') , '\VirtualStore\Program Files\Jade'.
	] on: Error do: [:ex | 
		ShellLibrary default shellOpen: (File splitPathFrom: SessionManager current imagePath).
	].!

openGemTalkHomePage

	ShellLibrary default shellOpen: 'https://gemtalksystems.com/'.
!

openJadeHomePage

	ShellLibrary default shellOpen: 'https://github.com/jgfoster/Jade'.
!

openLogin

	self model transcript
		ifNil: [self login] 
		ifNotNil: [:value | value view setFocus]
!

postLogin: aGciSession

	loginListPresenter view updateAll.
	self setWorkingDirectory.
	model 
		session: aGciSession;
		transcript: (JadeTranscript showOnSession: aGciSession);
		yourself.
	aGciSession 
		when: #logout
		send: #logout:
		to: self
		with: self model.

!

predefinedLogin

	| login string |
	string := Prompter 
		prompt: 'Enter the GemStone/S login data:' 
		caption: 'Predefined Login'.
	string ifNil: [^self].
	login := JadeLogin fromXML: string.
	loginListPresenter 
		list: (loginListPresenter list copyWith: login);
		selection: login;
		yourself.
!

queryCommand: query

	(#(#editCopy #editCut #editDelete ) includes: query commandSymbol) ifTrue: [
		query isEnabled: (View focus isKindOf: TextEdit).
		^true.
	].
	(#(#editSelectAll) includes: query commandSymbol) ifTrue: [
		query isEnabled: ((View focus isKindOf: TextEdit) and: [View focus value notEmpty]).
		^true.
	].
	(#(#editPaste) includes: query commandSymbol) ifTrue: [
		query isEnabled: ((View focus isKindOf: TextEdit) and: [View focus canPaste]).
		^true.
	].
	(#(#editUndo) includes: query commandSymbol) ifTrue: [
		query isEnabled: ((View focus isKindOf: TextEdit) and: [View focus canUndo]).
		^true.
	].
	(#(#editRedo) includes: query commandSymbol) ifTrue: [
		query isEnabled: ((View focus isKindOf: TextEdit) and: [View focus canRedo]).
		^true.
	].
	(#(#login) includes: query commandSymbol) ifTrue: [
		query isEnabled: (loginListPresenter hasSelection and: [loginListPresenter selection isAbleToLoadLibrary]).
		^true
	].
	(#(#copyXML #removeLogin) includes: query commandSymbol) ifTrue: [
		query isEnabled: loginListPresenter hasSelection.
		^true
	].
	^super queryCommand: query.
!

removeLogin

	self updateModel.
	loginListPresenter 
		list: (loginListPresenter list copyWithout: loginListPresenter selection);
		selectionOrNil: nil;
		yourself.
!

resetActivity

	GciActivity activity resize: 0.
	self updateActivity.

!

saveData

	self saveDataTo: self dataPath.
!

saveDataTo: aPath
	"Version is essentially the number of elements"

	| data fileStream |
	data := OrderedCollection new
		add: loginListPresenter list;
		add: loginListPresenter selectionOrNil;
		add: JadePreferencesPresenter defaultFont;
		add: JadePreferencesPresenter codeFont;
		yourself.
	[
		| tempPath |
		tempPath := self tempDataPath.
		fileStream := FileStream 
			write: tempPath
			mode: #'truncate' 
			check: false 
			type: #'binary'.
		data binaryStoreOn: fileStream.
		fileStream close.
		(File exists: aPath) ifTrue: [File delete: aPath].
		File rename: tempPath to: aPath.
	] on: Error do: [:ex | 
		MessageBox warning: ex description.
		fileStream ifNotNil: [fileStream close].
		ex return.
	].
!

selectionChanged

	self 
		updateModel;
		model: loginListPresenter selectionOrNil;
		updateView;
		yourself.
	!

sendRequiredMessages
	"The ImageStripper seems to think these messages aren't needed, without them we have problems."

	false ifTrue: [
		self onShutdown.	"https://github.com/dolphinsmalltalk/Dolphin/issues/1103"
	].
!

setWorkingDirectory

	File workingDirectory: SessionManager current imageBase.
!

showGemNRS

	Prompter
		on: (model generateGemNRS; gemNRS)
		prompt: 'Gem NRS'
		caption: 'Jade Login Info'.!

showStoneNRS

	Prompter
		on: (model generateStoneNRS; stoneNRS)
		prompt: 'Stone NRS'
		caption: 'Jade Login Info'.!

softBreak

	self breakBlock: [:library :sessionId | library softBreakSession: sessionId].
!

tempDataPath

	^self dataPath , '.new'
!

updateActivity
	"If we update in real time it seems to slow down other processing (like changing tabs in the System Browser).
	The mutex is to ensure that only one process manipulates the UI at a time (otherwise we can hang)."

	activityListMutex excessSignals == 0 ifTrue: [^self].
	[
		[
			(Delay forMilliseconds: 100) wait.
			activityListMutex critical: [
				| list |
				list := GciActivity activity.
				((list isEmpty and: [recentActivity notNil]) or: [list notEmpty and: [recentActivity ~~ list last]]) ifTrue: [
					[list size > 99] whileTrue: [list removeFirst].
					list := list copy.
					[
						activityListPresenter list: list.
					] forkAt: Processor userSchedulingPriority.
					Processor yield.
					list isEmpty ifTrue: [
						recentActivity := nil.
					] ifFalse: [
						recentActivity := list last.
						[
							activityListPresenter selection: recentActivity.
						] forkAt: Processor userSchedulingPriority.
						Processor yield.
					].
				].
			].
		] on: Error do: [:ex | ex halt return].
	] forkAt: Processor userBackgroundPriority.!

updateModel

	inUpdateView ifTrue: [^self].
	self model ifNil: [^self].
	self model
		gemVersion:	versionListPresenter 	selection;
		stoneHost: 	stoneHostPresenter 	value trimBlanks;
		stoneName: 	stoneNamePresenter 	value trimBlanks;
		gemType: 	gemTypePresenter 		value;
		gemHost: 	gemHostPresenter 		value trimBlanks;
		gemService: 	gemServicePresenter 	value trimBlanks;
		gemTask: 	gemTaskPresenter 		value trimBlanks;
		gsUserID: 	userIDPresenter 		value trimBlanks;
		gsPassword: 	passwordPresenter 	value trimBlanks;
		loginType: 	loginTypePresenter 	value;
		hostUserID:	hostUserIDPresenter	value trimBlanks;
		hostPassword:	hostPasswordPresenter	value trimBlanks;
		initials:		initialsPresenter		value trimBlanks;
		debugPath: 	debugPathPresenter	value trimBlanks;
		yourself.
!

updateView

	[
		inUpdateView := true.
		self model ifNil: [
			(self view viewNamed: 'bottom') hide.
		] ifNotNil: [
			| selection |
			(self view viewNamed: 'bottom') show.
			selection := versionListPresenter list 
				detect: [:each | each = self model gemVersion] 
				ifNone: [versionListPresenter list last].
			versionListPresenter		selection: selection.
			stoneHostPresenter 		value: self model stoneHost.
			stoneNamePresenter 		value: self model stoneName.
			gemTypePresenter 		value: self model gemType.
			gemHostPresenter 		value: self model gemHost.
			gemServicePresenter 	value: self model gemService.
			gemTaskPresenter 		value: self model gemTask.
			userIDPresenter 		value: self model gsUserID.
			passwordPresenter 		value: self model gsPassword.
			loginTypePresenter		value: self model loginType.
			hostUserIDPresenter		value: self model hostUserID.
			hostPasswordPresenter	value: self model hostPassword.
			initialsPresenter		value: self model initials.
			debugPathPresenter		value: self model debugPath.
		].
	] ensure: [
		inUpdateView := false.
	].! !
!JadeLoginShell categoriesForMethods!
aboutJade!public! !
addLogin!commands!public! !
breakBlock:!private! !
checkScintillaVersion!public! !
copyXML!commands!public! !
createComponents!public! !
createSchematicWiring!public! !
dataPath!public!user data! !
debugGCI!commands!public! !
editCopy!public! !
editCut!public! !
editDelete!public! !
editPaste!public! !
editRedo!public! !
editSelectAll!public! !
editUndo!public! !
enableWindow!private! !
exportActivity!private! !
fileOpen!public!user data! !
fileSave!public!user data! !
fillVersionList!public! !
hardBreak!private! !
initialize!public! !
isVersion:lessThanOrEqualTo:!public! !
loadData!public!user data! !
loadDataFrom:!public!user data! !
login!public! !
logout:!public! !
modified!public! !
onCloseRequested!public! !
onViewOpened!public! !
openConsole!commands!public! !
openExeDir!commands!public! !
openGemTalkHomePage!public! !
openJadeHomePage!public! !
openLogin!public! !
postLogin:!public! !
predefinedLogin!commands!public! !
queryCommand:!public! !
removeLogin!commands!public! !
resetActivity!private! !
saveData!public!user data! !
saveDataTo:!public!user data! !
selectionChanged!public! !
sendRequiredMessages!public! !
setWorkingDirectory!public! !
showGemNRS!commands!public! !
showStoneNRS!commands!public! !
softBreak!private! !
tempDataPath!public!user data! !
updateActivity!private! !
updateModel!public! !
updateView!public! !
!

!JadeLoginShell class methodsFor!

icon

	^Icon fromFile: 'icons\GS32.ico'.
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13238272 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 1421 901 549 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 34 2 410 ##(Smalltalk.CardContainer) 34 16 nil 416 34 2 8 1409286144 131073 624 nil 480 nil 7 nil nil nil 624 656710 1 ##(Smalltalk.CardLayout) 138 144 34 2 721414 ##(Smalltalk.Association) 8 'Logins' 410 ##(Smalltalk.ContainerView) 34 15 nil 624 34 2 8 1140850688 131073 800 nil nil nil 5 nil nil nil 800 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 170 192 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 800 34 2 8 1140850688 131073 928 nil nil nil 5 nil nil nil 928 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 928 34 2 8 1140850688 131073 1056 nil nil nil 5 nil nil nil 1056 994 170 176 34 28 410 ##(Smalltalk.TextEdit) 34 16 nil 1056 34 2 8 1140916352 1025 1168 nil 480 nil 5 nil nil nil 1168 nil 8 1959998768 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 391 113 498 285 45 1168 1346 #setMarginWidths: 34 1 8 #(3 3) 1168 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 56 0 0 0 81 1 0 0 78 0 0 0] 8 #() 498 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 11 1586 #fixedParentRight -9 1586 #fixedPreviousTop 1 1586 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 1056 34 2 8 1140850944 1 1664 nil nil nil 5 nil nil nil 1664 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 11 213 498 371 41 1664 1346 #text: 34 1 8 'GemStone User ID:' 1664 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 106 0 0 0 190 0 0 0 126 0 0 0] 8 #() 1536 nil 27 1554 1586 #fixedParentLeft 11 1586 #fixedViewLeft 371 1586 #fixedPreviousBottom 3 1648 41 410 ##(Smalltalk.StaticText) 34 16 nil 1056 34 2 8 1140850944 1 2032 nil nil nil 5 nil nil nil 2032 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 11 21 498 371 41 2032 1346 #text: 34 1 8 'GemStone/Smalltalk Version:' 2032 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 190 0 0 0 30 0 0 0] 8 #() 1536 nil 27 1554 1984 11 2000 371 1586 #fixedParentTop 21 1648 41 410 ##(Smalltalk.StaticText) 34 16 nil 1056 34 2 8 1140850944 1 2368 nil nil nil 5 nil nil nil 2368 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 11 67 498 371 31 2368 1346 #text: 34 1 8 'RPC Gem Host Name or IP:' 2368 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 33 0 0 0 190 0 0 0 48 0 0 0] 8 #() 1536 nil 27 1554 1984 11 2000 371 2016 11 1648 31 410 ##(Smalltalk.TextEdit) 34 16 nil 1056 34 2 8 1140916352 1025 2688 nil 480 nil 5 nil nil nil 2688 nil 8 1959998768 1250 nil nil 1 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 391 313 498 285 45 2688 1346 #setMarginWidths: 34 1 8 #(3 3) 2688 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 156 0 0 0 81 1 0 0 178 0 0 0] 8 #() 1536 nil 27 1554 1600 11 1616 -9 1632 1 1648 45 410 ##(Smalltalk.TextEdit) 34 16 nil 1056 34 2 8 1140916384 1025 3008 nil 480 nil 5 nil nil nil 3008 nil 8 1959998768 1250 nil nil 1 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 391 259 498 285 45 3008 1346 #setMarginWidths: 34 1 8 #(3 3) 3008 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 129 0 0 0 81 1 0 0 151 0 0 0] 8 #() 1536 nil 27 1554 1600 11 1616 -9 1632 1 1648 45 410 ##(Smalltalk.ComboBox) 34 17 nil 1056 34 2 8 1144063491 1025 3328 590662 2 ##(Smalltalk.ListModel) 138 144 576 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 5 nil nil nil 3328 nil 8 1959798752 459270 ##(Smalltalk.Message) #displayString 8 #() 8 #() 401 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 391 11 498 285 51 3328 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 5 0 0 0 81 1 0 0 30 0 0 0] 8 #() 1536 nil 27 1554 1600 11 1616 -9 2352 11 1648 47 410 ##(Smalltalk.TextEdit) 34 16 nil 1056 34 2 8 1140916352 1025 3728 nil 480 nil 5 nil nil nil 3728 nil 8 1959998768 1250 nil nil 1 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 391 213 498 285 45 3728 1346 #setMarginWidths: 34 1 8 #(3 3) 3728 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 106 0 0 0 81 1 0 0 128 0 0 0] 8 #() 1536 nil 27 1554 1600 11 1616 -9 1632 1 1648 45 410 ##(Smalltalk.StaticText) 34 16 nil 1056 34 2 8 1140850944 1 4048 nil nil nil 5 nil nil nil 4048 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 11 313 498 371 41 4048 1346 #text: 34 1 8 'Monticello User Name:' 4048 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 156 0 0 0 190 0 0 0 176 0 0 0] 8 #() 1536 nil 27 1554 1984 11 2000 371 2016 11 1648 41 410 ##(Smalltalk.StaticText) 34 16 nil 1056 34 2 8 1140850944 1 4368 nil nil nil 5 nil nil nil 4368 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 11 167 498 371 39 4368 1346 #text: 34 1 8 'Stone Name:' 4368 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 83 0 0 0 190 0 0 0 102 0 0 0] 8 #() 1536 nil 27 1554 1984 11 2000 371 2016 11 1648 39 410 ##(Smalltalk.TextEdit) 34 16 nil 1056 34 2 8 1140916352 1025 4688 nil 480 nil 5 nil nil nil 4688 nil 8 1959998768 1250 nil nil 1 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 391 67 498 285 45 4688 1346 #setMarginWidths: 34 1 8 #(3 3) 4688 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 33 0 0 0 81 1 0 0 55 0 0 0] 8 #() 1536 nil 27 1554 1600 11 1616 -9 1632 1 1648 45 410 ##(Smalltalk.StaticText) 34 16 nil 1056 34 2 8 1140850944 1 5008 nil nil nil 5 nil nil nil 5008 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 11 113 498 371 31 5008 1346 #text: 34 1 8 'NetLDI Service Name or Port:' 5008 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 56 0 0 0 190 0 0 0 71 0 0 0] 8 #() 1536 nil 27 1554 1984 11 2000 371 2016 3 1648 31 410 ##(Smalltalk.TextEdit) 34 16 nil 1056 34 2 8 1140916352 1025 5328 nil 480 nil 5 nil nil nil 5328 nil 8 1959998768 1250 nil nil 1 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 391 167 498 285 45 5328 1346 #setMarginWidths: 34 1 8 #(3 3) 5328 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 83 0 0 0 81 1 0 0 105 0 0 0] 8 #() 1536 nil 27 1554 1600 11 1616 -9 1632 1 1648 45 410 ##(Smalltalk.StaticText) 34 16 nil 1056 34 2 8 1140850944 1 5648 nil nil nil 5 nil nil nil 5648 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 11 259 498 371 41 5648 1346 #text: 34 1 8 'GemStone Password:' 5648 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 129 0 0 0 190 0 0 0 149 0 0 0] 8 #() 1536 nil 27 1554 1984 11 2000 371 2016 3 1648 41 170 192 34 14 3008 8 'password' 1168 8 'gemService' 5328 8 'stoneName' 3328 8 'versionList' 3728 8 'userID' 2688 8 'initials' 4688 8 'gemHost' nil 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 1 1 498 685 687 1056 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 87 1 0 0] 34 14 2032 3328 2368 4688 5008 1168 4368 5328 1664 3728 5648 3008 4048 2688 1536 nil 27 1554 1984 1 1586 #relativeParentWidth 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 224 63 2352 1 1586 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 928 34 2 8 1140850688 131073 6352 nil nil nil 5 nil nil nil 6352 994 170 176 34 26 410 ##(Smalltalk.StaticText) 34 16 nil 6352 34 2 8 1140850944 1 6464 nil nil nil 5 nil nil nil 6464 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 321 163 498 161 41 6464 1346 #text: 34 1 8 'OS User ID:' 6464 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 160 0 0 0 81 0 0 0 240 0 0 0 101 0 0 0] 8 #() 1536 nil 27 1554 1600 11 2000 161 1632 1 1648 41 410 ##(Smalltalk.TextEdit) 34 16 nil 6352 34 2 8 1140916384 1025 6784 nil 480 nil 5 nil nil nil 6784 nil 8 1959998768 1250 nil nil 1 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 491 209 498 185 45 6784 1346 #setMarginWidths: 34 1 8 #(3 3) 6784 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 0 0 0 104 0 0 0 81 1 0 0 126 0 0 0] 8 #() 1536 nil 27 1554 1600 11 1616 -9 1632 1 1648 45 410 ##(Smalltalk.TextEdit) 34 16 nil 6352 34 2 8 1140916352 1025 7104 nil 480 nil 5 nil nil nil 7104 nil 8 1959998768 1250 nil nil 1 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 321 115 498 355 45 7104 1346 #text: 34 1 8 'gemnetobject' 7104 1346 #setMarginWidths: 34 1 8 #(3 3) 7104 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 160 0 0 0 57 0 0 0 81 1 0 0 79 0 0 0] 8 #() 1536 nil 27 1554 1600 11 1616 -9 1632 1 1648 45 410 ##(Smalltalk.StaticText) 34 16 nil 6352 34 2 8 1140850944 1 7472 nil nil nil 5 nil nil nil 7472 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 11 69 498 301 41 7472 1346 #text: 34 1 8 'Stone Host (from Gem):' 7472 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 34 0 0 0 155 0 0 0 54 0 0 0] 8 #() 1536 nil 27 1554 1984 11 2000 301 2016 11 1648 41 410 ##(Smalltalk.StaticText) 34 16 nil 6352 34 2 8 1140850944 1 7792 nil nil nil 5 nil nil nil 7792 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 321 209 498 161 41 7792 1346 #text: 34 1 8 'Password:' 7792 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 160 0 0 0 104 0 0 0 240 0 0 0 124 0 0 0] 8 #() 1536 nil 27 1554 1586 #fixedPreviousLeft -169 2000 161 2016 3 1648 41 410 ##(Smalltalk.StaticPath) 34 17 nil 6352 34 2 8 1140850944 1 8128 nil nil nil 5 nil nil nil 8128 nil 8 1959855184 1250 nil nil nil 8 'XXX' 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 161 15 498 515 45 8128 1346 #text: 34 1 8224 8128 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 7 0 0 0 81 1 0 0 29 0 0 0] 8 #() 1536 nil 27 1554 1984 161 1616 -9 1632 11 1648 45 410 ##(Smalltalk.StaticText) 34 16 nil 6352 34 2 8 1140850944 1 8448 nil nil nil 5 nil nil nil 8448 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 11 115 498 301 31 8448 1346 #text: 34 1 8 'NetLDI Task Name:' 8448 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 57 0 0 0 155 0 0 0 72 0 0 0] 8 #() 1536 nil 27 1554 1984 11 2000 301 2016 3 1648 31 410 ##(Smalltalk.ContainerView) 34 15 nil 6352 34 2 8 1140850688 393217 8768 nil 480 nil 5 nil nil nil 8768 656390 ##(Smalltalk.GridLayout) 3 5 1 1 170 192 34 4 410 ##(Smalltalk.RadioButton) 34 16 nil 8768 34 2 8 1140924425 1 8896 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 3490 #= 8 #() 3490 #hash 8 #() false 480 nil 5 nil nil nil 8896 nil 8 1960006960 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 1 1 498 331 45 8896 1346 #text: 34 1 8 'RPC Gem' 8896 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 165 0 0 0 22 0 0 0] 8 #() 1536 nil 27 8 'remote' 410 ##(Smalltalk.RadioButton) 34 16 nil 8768 34 2 8 1141055497 1 9344 8962 nil nil 8994 3490 #= 8 #() 3490 #hash 8 #() false 480 nil 5 nil nil nil 9344 nil 8 1960006960 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 331 1 498 331 45 9344 1346 #text: 34 1 8 'Linked Gem (32-bit only)' 9344 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 165 0 0 0 0 0 0 0 74 1 0 0 22 0 0 0] 8 #() 1536 nil 27 8 'linked' nil 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 11 257 498 665 49 8768 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 128 0 0 0 81 1 0 0 152 0 0 0] 34 2 8896 9344 1536 nil 27 1554 1984 11 1616 -9 2016 5 1648 49 410 ##(Smalltalk.PushButton) 34 20 nil 6352 34 2 8 1140924416 1 9936 nil nil nil 5 nil nil nil 9936 nil 8 1960006960 1180998 4 ##(Smalltalk.CommandDescription) #login 8 'Login' 1 1 nil nil true nil nil nil 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 11 305 498 665 61 9936 1346 #isEnabled: 8 #(false) 9936 1346 #text: 34 1 8 'Login' 9936 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 152 0 0 0 81 1 0 0 182 0 0 0] 8 #() 1536 nil 29 1554 1984 11 1616 -9 2016 1 1648 61 410 ##(Smalltalk.ContainerView) 34 15 nil 6352 34 2 8 1409286144 393217 10320 nil 480 nil 5 nil nil nil 10320 8834 1 3 1 1 170 192 34 4 410 ##(Smalltalk.RadioButton) 34 16 nil 10320 34 2 8 1140924425 1 10432 8962 nil nil 8994 3490 #= 8 #() 3490 #hash 8 #() false 480 nil 5 nil nil nil 10432 nil 8 1960006960 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 1 39 498 297 39 10432 1346 #text: 34 1 8 'Native OS User' 10432 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 148 0 0 0 38 0 0 0] 8 #() 1536 nil 27 8 'member' 410 ##(Smalltalk.RadioButton) 34 16 nil 10320 34 2 8 1141055497 1 10848 8962 nil nil 8994 3490 #= 8 #() 3490 #hash 8 #() false 480 nil 5 nil nil nil 10848 nil 8 1960006960 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 1 1 498 297 39 10848 1346 #text: 34 1 8 'NetLDI Guest' 10848 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 148 0 0 0 19 0 0 0] 8 #() 1536 nil 27 8 'guest' nil 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 11 163 498 301 81 10320 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 81 0 0 0 155 0 0 0 121 0 0 0] 34 2 10848 10432 1536 nil 27 1554 1984 11 2000 301 2016 5 1648 81 410 ##(Smalltalk.PushButton) 34 20 nil 6352 34 2 8 1140924416 1 11440 nil nil nil 5 nil nil nil 11440 nil 8 1960006960 10018 #debugGCI 8 'Debug GCI' 1 1 nil nil false nil nil nil 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 11 5 498 141 51 11440 1346 #isEnabled: 8 #(false) 11440 1346 #text: 34 1 8 'Debug GCI' 11440 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 2 0 0 0 75 0 0 0 27 0 0 0] 8 #() 1536 nil 29 1554 1984 11 2000 141 2016 5 1648 51 410 ##(Smalltalk.TextEdit) 34 16 nil 6352 34 2 8 1140916352 1025 11808 nil 480 nil 5 nil nil nil 11808 nil 8 1959998768 1250 nil nil 1 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 321 69 498 355 45 11808 1346 #text: 34 1 8 'localhost' 11808 1346 #setMarginWidths: 34 1 8 #(3 3) 11808 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 160 0 0 0 34 0 0 0 81 1 0 0 56 0 0 0] 8 #() 1536 nil 27 1554 1600 11 1616 -9 1632 1 1648 45 410 ##(Smalltalk.TextEdit) 34 16 nil 6352 34 2 8 1140916352 1025 12176 nil 480 nil 5 nil nil nil 12176 nil 8 1959998768 1250 nil nil 1 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 491 163 498 185 45 12176 1346 #setMarginWidths: 34 1 8 #(3 3) 12176 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 0 0 0 81 0 0 0 81 1 0 0 103 0 0 0] 8 #() 1536 nil 27 1554 1600 11 1616 -9 1632 1 1648 45 170 192 34 14 8768 8 'gemType' 8128 8 'debugPath' 11808 8 'stoneHost' 12176 8 'hostUserID' 7104 8 'gemTask' 10320 8 'loginType' 6784 8 'hostPassword' nil 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 685 1 498 685 687 6352 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 0 0 0 0 172 2 0 0 87 1 0 0] 34 13 11440 8128 7472 11808 8448 7104 10320 6464 12176 7792 6784 8768 9936 1536 nil 27 1554 6288 6306 8 0 0 0 0 0 0 224 63 1616 1 2352 1 6336 1 170 192 34 4 1056 8 'Basic' 6352 8 'Advanced' nil 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 1 349 498 1369 687 928 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 174 0 0 0 172 2 0 0 5 2 0 0] 34 2 1056 6352 1536 nil 27 8 'bottom' 410 ##(Smalltalk.ContainerView) 34 15 nil 800 34 2 8 1140850688 131073 13072 nil nil nil 5 nil nil nil 13072 994 170 176 34 10 410 ##(Smalltalk.ListView) 34 45 nil 13072 34 2 8 1409355853 1025 13184 3394 138 144 576 nil 3456 480 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 10018 #copyXML 8 '&Copy XML' 1 1 nil nil nil 13330 1 10018 #addLogin 8 '&Add' 1 1 nil nil nil 13330 1 10018 #removeLogin 8 '&Remove' 1 1 nil nil nil 13330 1 10018 #login 8 '&Login' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 13184 nil 8 1959942240 3490 #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 6 920646 5 ##(Smalltalk.ListViewColumn) 8 'Version' 241 #left 3490 #gemVersion 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 106 8 'Dolphin' 8 'SortedCollection' 8 'doIt' 8 '[:a :b | a gemVersion <= b gemVersion]' 8 #[30 105 226 0 226 32 130 106] #gemVersion 13760 7 513 nil nil nil 13184 nil 1 nil nil 13666 8 'Gem Host' 201 #left 3490 #gemHost 13728 13746 0 nil 13778 2 1 3488 8 'doIt' 8 '[:a :b | a gemHost <= b gemHost]' 8 #[30 105 226 0 226 32 130 106] #gemHost 13952 7 513 nil nil nil 13184 nil 1 nil nil 13666 8 'NetLDI' 201 #left 3490 #gemService 13728 13746 0 nil 13778 2 1 3488 8 'doIt' 8 '[:a :b | a gemService <= b gemService]' 8 #[30 105 226 0 226 32 130 106] #gemService 14080 7 513 nil nil nil 13184 nil 1 nil nil 13666 8 'Stone' 201 #left 3490 #stoneName 13728 13746 0 nil 13778 2 1 3488 8 'doIt' 8 '[:a :b | a stoneName <= b stoneName]' 8 #[30 105 226 0 226 32 130 106] #stoneName 14208 7 513 nil nil nil 13184 nil 1 nil nil 13666 8 'User' 201 #left 3490 #gsUserID 13728 13746 0 nil 13778 2 1 3488 8 'doIt' 8 '[:a :b | a gsUserID <= b gsUserID]' 8 #[30 105 226 0 226 32 130 106] #gsUserID 14336 7 513 nil nil nil 13184 nil 1 nil nil 13666 8 'Last Login' 441 #left 3490 #lastLoginString 8 #() 13746 0 nil 13778 2 1 3488 8 'doIt' 8 '[:a :b | a lastLogin <= b lastLogin]' 8 #[30 105 226 0 226 32 130 106] #lastLogin 14480 7 513 nil nil nil 13184 nil 1 nil nil #report 3536 nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 1 51 498 1319 289 13184 1346 #contextMenu: 34 1 13296 13184 1346 #text: 34 1 8 'Version' 13184 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 147 2 0 0 169 0 0 0] 8 #() 1536 nil 35 1554 1984 1 1616 -49 2016 1 6336 1 410 ##(Smalltalk.PushButton) 34 20 nil 13072 34 2 8 1140924416 1 14816 nil nil nil 5 nil nil nil 14816 nil 8 1960006960 10018 #removeLogin 8 '-' 1 1 nil nil false nil nil nil 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 1319 121 498 51 51 14816 1346 #isEnabled: 8 #(false) 14816 1346 #text: 34 1 8 '-' 14816 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 147 2 0 0 60 0 0 0 172 2 0 0 85 0 0 0] 8 #() 1536 nil 29 1554 1616 -49 2000 51 2016 11 1648 51 410 ##(Smalltalk.Toolbar) 34 25 nil 13072 34 2 8 1409289036 131137 15184 nil 480 nil 5 nil nil nil 15184 480 8 1959965968 170 192 576 170 192 34 10 12263 1115206 1 ##(Smalltalk.ToolbarIconButton) 15184 1 10018 #editDelete 8 'Delete' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'icons\EditDelete.ico' nil 12263 12259 15314 15184 1 10018 #editCopy 8 'Copy' 1 1 15378 nil true 15424 8 'icons\EditCopy.ico' nil 12259 12265 15314 15184 1 10018 #editUndo 8 'Undo' 1 1 15378 nil true 15424 8 'icons\EditUndo.ico' nil 12265 12261 15314 15184 1 10018 #editPaste 8 'Paste' 1 1 15378 nil true 15424 8 'icons\EditPasteLink.ico' nil 12261 12257 15314 15184 1 10018 #editCut 8 'Cut' 1 1 15378 nil true 15424 8 'icons\EditCut.ico' nil 12257 34 6 15696 15456 15616 15328 15536 1049158 1 ##(Smalltalk.ToolbarSeparator) 15184 1 nil nil 1 nil 498 33 33 498 45 45 nil nil 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 1 1 498 241 51 15184 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 120 0 0 0 25 0 0 0] 8 #() 1536 nil 27 1554 1984 1 2000 241 2352 1 1648 51 410 ##(Smalltalk.Toolbar) 34 25 nil 13072 34 2 8 1140853580 131137 16032 nil 480 nil 517 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 16032 480 8 1959965968 170 192 576 170 192 34 4 12267 1246790 1 ##(Smalltalk.ToolbarSystemButton) 16032 1 10018 #getHelpOn 8 'Get help on widget' 1 1 nil 12267 1 23 12269 1246790 1 ##(Smalltalk.ToolbarBitmapButton) 16032 1 10018 #openHelp 8 'Jade Help' 1 1 nil 12269 395334 3 ##(Smalltalk.Bitmap) nil true 15424 8 'Tools.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil 7 498 1857 33 71 34 2 16272 16336 nil nil 1 nil 498 33 33 498 45 45 nil 866 1 1 1 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 241 1 498 1129 51 16032 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 120 0 0 0 0 0 0 0 172 2 0 0 25 0 0 0] 8 #() 1536 nil 27 1554 1600 1 1616 1 2352 1 1648 51 410 ##(Smalltalk.PushButton) 34 20 nil 13072 34 2 8 1140924416 1 16736 nil nil nil 5 nil nil nil 16736 nil 8 1960006960 10018 #addLogin 8 '+' 1 1 nil nil false nil nil nil 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 1319 61 498 51 51 16736 1346 #isEnabled: 8 #(false) 16736 1346 #text: 34 1 8 '+' 16736 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 147 2 0 0 30 0 0 0 172 2 0 0 55 0 0 0] 8 #() 1536 nil 29 1554 1616 -49 2000 51 2352 61 1648 51 170 192 34 6 13184 8 'loginList' 15184 8 'Edit Tools' 16032 8 'Other Tools' nil 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 1 1 498 1369 339 13072 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 2 0 0 169 0 0 0] 34 5 15184 16032 13184 16736 14816 1536 nil 27 8 'top' nil 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 9 53 498 1373 723 800 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 178 2 0 0 131 1 0 0] 34 3 13072 410 ##(Smalltalk.Splitter) 34 12 nil 800 34 2 8 1140850688 1 17520 nil 480 nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 17520 nil 1 #left nil nil nil 498 1 1 498 9 9 nil 17616 nil 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 1 339 498 11 11 17520 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 169 0 0 0 5 0 0 0 174 0 0 0] 8 #() 1536 nil 27 928 1536 nil 27 754 8 'GCI Activity' 410 ##(Smalltalk.ContainerView) 34 15 nil 624 34 2 8 1140850688 131073 17840 nil nil nil 7 nil nil nil 17840 994 170 176 34 16 410 ##(Smalltalk.StaticText) 34 16 nil 17840 34 2 8 1140850944 65 17952 nil nil nil 7 nil nil nil 17952 nil 8 1959855184 1250 nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 11 11 498 201 41 17952 1346 #text: 34 1 8 'Active Library:' 17952 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 105 0 0 0 25 0 0 0] 8 #() 1536 nil 27 1554 1984 11 2000 201 2352 11 1648 41 410 ##(Smalltalk.TextEdit) 34 16 nil 17840 34 2 8 1140916352 1025 18272 nil 480 nil 7 nil nil nil 18272 nil 8 1959998768 1250 nil nil 1 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 211 11 498 301 39 18272 1346 #isEnabled: 8 #(false) 18272 1346 #setMarginWidths: 34 1 8 #(3 3) 18272 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 5 0 0 0 255 0 0 0 24 0 0 0] 8 #() 1536 nil 27 1554 1984 211 2000 301 2352 11 1648 39 410 ##(Smalltalk.PushButton) 34 20 nil 17840 34 2 8 1140924416 1 18624 nil nil nil 7 nil nil nil 18624 nil 8 1960006960 10018 #enableWindow 8 'Enable' 1 1 nil nil false nil nil nil 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 573 5 498 151 51 18624 1346 #isEnabled: 8 #(false) 18624 1346 #text: 34 1 8 'Enable' 18624 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 1 0 0 2 0 0 0 105 1 0 0 27 0 0 0] 8 #() 1536 nil 29 1554 1616 -799 2000 151 2352 5 1648 51 410 ##(Smalltalk.PushButton) 34 20 nil 17840 34 2 8 1140924416 1 18992 nil nil nil 7 nil nil nil 18992 nil 8 1960006960 10018 #resetActivity 8 'Reset' 1 1 nil nil false nil nil nil 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 1213 5 498 151 51 18992 1346 #isEnabled: 8 #(false) 18992 1346 #text: 34 1 8 'Reset' 18992 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 94 2 0 0 2 0 0 0 169 2 0 0 27 0 0 0] 8 #() 1536 nil 29 1554 1616 -159 2000 151 2352 5 1648 51 410 ##(Smalltalk.PushButton) 34 20 nil 17840 34 2 8 1140924416 1 19360 nil nil nil 7 nil nil nil 19360 nil 8 1960006960 10018 #softBreak 8 'Soft Break' 1 1 nil nil false nil nil nil 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 1053 5 498 151 51 19360 1346 #isEnabled: 8 #(false) 19360 1346 #text: 34 1 8 'Soft Break' 19360 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 2 0 0 0 89 2 0 0 27 0 0 0] 8 #() 1536 nil 29 1554 1616 -319 2000 151 2352 5 1648 51 410 ##(Smalltalk.PushButton) 34 20 nil 17840 34 2 8 1140924416 1 19728 nil nil nil 7 nil nil nil 19728 nil 8 1960006960 10018 #hardBreak 8 'Hard Break' 1 1 nil nil false nil nil nil 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 893 5 498 151 51 19728 1346 #isEnabled: 8 #(false) 19728 1346 #text: 34 1 8 'Hard Break' 19728 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 1 0 0 2 0 0 0 9 2 0 0 27 0 0 0] 8 #() 1536 nil 29 1554 1616 -479 2000 151 2352 5 1648 51 410 ##(Smalltalk.PushButton) 34 20 nil 17840 34 2 8 1140924416 1 20096 nil nil nil 7 nil nil nil 20096 nil 8 1960006960 10018 #exportActivity 8 'Export' 1 1 nil nil false nil nil nil 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 733 5 498 151 51 20096 1346 #isEnabled: 8 #(false) 20096 1346 #text: 34 1 8 'Export' 20096 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 1 0 0 2 0 0 0 185 1 0 0 27 0 0 0] 8 #() 1536 nil 29 1554 1616 -639 2000 151 2352 5 1648 51 410 ##(Smalltalk.ListView) 34 45 nil 17840 34 2 8 1409355853 1025 20464 3394 138 144 576 nil 3456 480 nil 7 nil nil nil 20464 nil 8 1959942240 3490 #displayString 8 #() nil 13616 nil nil nil nil nil nil 138 144 34 7 13666 8 '#' 51 #right 3490 #displayString 20592 3490 #<= 8 #() 13746 0 nil 13778 2 1 13744 8 'doIt' 8 '[:each | each sessionId]' 8 #[30 105 226 0 106] #sessionId 20720 7 257 nil nil 20464 nil 1 nil nil 13666 8 'Process' 131 #right 3490 #displayString 8 #() 3490 #<= 20848 13746 0 nil 13778 2 1 13744 8 'doIt' 8 '[:entry |entry processId]' 8 #[30 105 226 0 106] #processId 20880 7 257 nil nil 20464 nil 1 nil nil 13666 8 'Time' 171 #left 3490 #displayString 8 #() 3490 #<= 21008 13746 0 nil 13778 2 1 13744 8 'doIt' 8 '[:each | each time ]' 8 #[30 105 226 0 106] #time 21040 7 257 nil nil 20464 nil 1 nil nil 13666 8 'Description' 601 #left 3490 #displayString 21008 3490 #<= 21008 13746 0 nil 13778 2 1 13744 8 'doIt' 8 '[:each | each request ]' 8 #[30 105 226 0 106] #request 21184 7 257 nil nil 20464 nil 1 nil nil 13666 8 'Sem' 101 #right 3490 #displayString 21008 3490 #<= 21008 13746 0 nil 13778 2 1 13744 8 'doIt' 8 '[:each | each msForSemaphore]' 8 #[30 105 226 0 106] #msForSemaphore 21328 7 257 nil nil 20464 nil 1 nil nil 13666 8 'GCI' 101 #right 3490 #displayString 21008 3490 #<= 21008 13746 0 nil 13778 2 1 13744 8 'doIt' 8 '[:each | each msForResponse]' 8 #[30 105 226 0 106] #msForResponse 21472 7 257 nil nil 20464 nil 1 nil nil 13666 8 'Result' 161 #left 3490 #displayString 21008 3490 #<= 21008 13746 0 nil 13778 2 1 13744 8 'doIt' 8 '[:each | each response]' 8 #[30 105 226 0 106] #response 21616 7 257 nil nil 20464 nil 1 nil nil #report 3536 nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 11 61 498 1353 653 20464 1346 #text: 34 1 8 '#' 20464 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 30 0 0 0 169 2 0 0 100 1 0 0] 8 #() 1536 nil 35 1554 1984 11 1616 -9 2352 61 6336 -9 170 192 34 6 18992 8 'resetActivity' 18272 8 'activeLibrary' 20464 8 'activityList' nil 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 9 53 498 1373 723 17840 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 178 2 0 0 131 1 0 0] 34 8 17952 18272 18992 19360 19728 20096 18624 20464 1536 nil 27 17840 nil nil nil 170 192 34 4 800 8 'logins' 17840 8 'gciActivity' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 624 34 2 8 1140916736 1 22224 3394 138 144 34 2 784 17824 nil 3456 nil nil 1 nil nil nil 22224 nil 8 1959710448 13746 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 ##(Smalltalk.ListControlView) #defaultGetTextBlock 575230339 8 #[30 105 226 0 106] #displayString 22352 7 257 nil 13746 0 nil 22370 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 22416 7 257 nil 13616 nil nil nil nil nil #noIcons nil nil nil nil nil 1282 138 144 34 3 1346 #createAt:extent: 34 2 498 1 1 498 1389 783 22224 1346 #setSingleSelection: 8 #(2) 22224 1346 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 22224 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 135 1 0 0] 8 #() 1536 nil 27 1282 138 144 34 1 1346 #createAt:extent: 34 2 498 1 1 498 1389 783 624 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 135 1 0 0] 34 3 800 17840 22224 1536 nil 27 8 'cardContainer' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 13282 nil true 34 8 13330 1 10018 #openConsole 8 'Open &Console' 9369 1 nil nil nil 13330 1 10018 #fileOpen 8 '&Open...' 9375 1 nil nil nil 13330 1 10018 #fileSave 8 '&Save' 9383 1 nil nil nil 13330 1 10018 #addLogin 8 '&New' 9373 1 nil nil nil 13330 1 10018 #predefinedLogin 8 '&Predefined Login' 1 1 nil nil nil 13330 1 10018 #removeLogin 8 '&Remove' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 13330 1 10018 #exit 8 'E&xit' 17639 1 nil nil nil 8 '&File' nil 134217729 nil nil 12437 nil nil 13282 nil true 34 9 13330 1 10018 #editUndo 8 '&Undo' 9397 1 nil nil nil 13330 1 10018 #editRedo 8 '&Redo' 9395 1 nil nil nil 23234 4097 13330 1 10018 #editCut 8 'Cu&t' 9393 1 nil nil nil 13330 1 10018 #editCopy 8 '&Copy' 9351 1 nil nil nil 13330 1 10018 #editPaste 8 '&Paste' 9389 1 nil nil nil 13330 1 10018 #editDelete 8 'De&lete' 1629 1 nil nil nil 23234 4097 13330 1 10018 #editSelectAll 8 'Select &All' 9347 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 12453 nil nil 13282 nil true 34 7 13330 1 10018 #openGemTalkHomePage 8 '&GemTalk Home Page' 1025 1 nil nil nil 13330 1 10018 #openJadeHomePage 8 '&Jade Home Page' 1 1 nil nil nil 23234 4097 13330 1 10018 #showGemNRS 8 'Show Gem &NRS' 1 1 nil nil nil 13330 1 10018 #showStoneNRS 8 'Show Stone N&RS' 1 1 nil nil nil 13330 1 10018 #openExeDir 8 'Open Executable &Directory' 1 1 nil nil nil 13330 1 10018 #aboutJade 8 '&About Jade' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 12467 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 10223 15378 nil true 15424 8 'icons\GS32.ico' nil 15378 nil true 15424 8 'icons\GS16.ico' nil nil nil 1 nil nil 1282 138 144 34 2 1346 #createAt:extent: 34 2 498 5119 21 498 1421 901 416 1346 #text: 34 1 8 'Jade Login' 416 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 197 12 0 0 204 1 0 0] 34 1 624 1536 nil 27 )! !
!JadeLoginShell class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

