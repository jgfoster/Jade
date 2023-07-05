"Filed out from Dolphin Smalltalk"!

JadeWorkspace subclass: #JadeTranscript
	instanceVariableNames: 'allSessionsPresenter historyPresenter mySessionPresenter stoneInfoPresenter toolbarPresenter transcriptPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeTranscript guid: (GUID fromString: '{7d871bc4-1338-4ba1-af6a-c1edd936d683}')!
JadeTranscript comment: ''!
!JadeTranscript categoriesForClass!Unclassified! !
!JadeTranscript methodsFor!

addJadeServerToUserGlobals

	self gciSession serverPerform: #addJadeServerToUserGlobals.
!

autocompletion

	JadeAutocompletationConfigurationShell show.
!

browseMonticelloRepositories

	self jadeBrowseMonticello.
!

createComponents

	super createComponents.
	allSessionsPresenter	:= self add: AllSessionsPresenter		new name: 'All Sessions'.
	historyPresenter	:= self add: TextPresenter				new name: 'history'.
	mySessionPresenter	:= self add: MySessionPresenter			new name: 'My Session'.
	stoneInfoPresenter	:= self add: StoneInfoPresenter			new name: 'Stone'.
	toolbarPresenter	:= self add: JadeToolsToolBarPresenter	new name: 'Toolbar'.
	transcriptPresenter	:= self add: TranscriptPresenter			new name: 'Transcript'.
!

createSchematicWiring

	super createSchematicWiring.
	(self view viewNamed: 'cardContainer') when: #'currentCardChanged' send: #'currentCardChanged' to: self.
!

currentCardChanged

	| currentCard |
	currentCard := (self view viewNamed: 'cardContainer') currentCard.
	(currentCard isKindOf: TextEdit) 	ifTrue: [currentCard setFocus].
	(currentCard name = 'codePane')		ifTrue: [[(currentCard viewNamed: 'document') setFocus] postToInputQueue. ^self].
	(currentCard name = 'history')		ifTrue: [historyPresenter value isEmpty ifTrue: [historyPresenter value: (gciSession executeString: 'DbfHistory')]. ^self].
	(currentCard name = 'My Session')	ifTrue: [mySessionPresenter fillSessionInfo. ^self].
	(currentCard name = 'Stone')		ifTrue: [stoneInfoPresenter fillSessionInfo. ^self].!

defaultFileExtension

	^'gs'.
!

describeErrorNumber

	| string result |
	(string := Prompter prompt: 'Enter GemStoneError number:') isNil ifTrue: [^self].
	(string allSatisfy: [:each | each isDigit]) ifFalse: [
		MessageBox warning: 'Invalid number!!'.
		^self.
	].
	result := gciSession 
		serverPerform: #'descriptionOfErrorNumber:'
		with: string asNumber.
	MessageBox 
		notify: result
		caption: 'GemStoneError ' , string.
!

fileInPharo

	| path |
	path := FileOpenDialog new
		caption: 'Open Pharo File-out';
		fileTypes: (Array with: #('Pharo File-out (*.st)' '*.st' ) with: #('All Files (*.*)' '*.*' ));
		defaultExtension: 'st';
		showModal.
	path isNil ifTrue: [^self].
	FileInPharo path: path.


!

fileOutJadeServer

	| path string file index version |
	version := self gciSession serverPerform: #'version'.
	path := FileSaveDialog new
		caption: 'File Out JadeServer';
		fileTypes: self fileTypes;
		defaultExtension: self defaultFileExtension;
		value: gciSession serverClass name , '-' , version , '.gs';
		overwritePrompt;
		showModal.
	path isNil ifTrue: [^self].
	string := environment printString , ' fileOutJadeServer' , Character tab asString.
	string := self gciSession encode: string.
	string := self gciSession 
		serverPerform: #'systemBrowser:' 
		with: string.
	string := self gciSession decode: string.
	index := string indexOf: Character lf.
	string := string copyFrom: index + 1 to: string size.
	string := string copyReplaceAll: 'poolDictionaries: { UserGlobals . Globals }' with: 'poolDictionaries: { }'.
	string := string copyReplaceAll: '(class not in your dictionaries)' with: 'Globals'.
	file := FileStream write: path mode: #'truncate' check: false type: #'ansi'.
	[
		file nextPutAll: string.
	] ensure: [
		file close.
	].
!

fileTypes

	^Array
		with: #('GemStone Files (*.gs)' '*.gs')
		with: #('Smalltalk Files (*.st)' '*.st')
		with: FileDialog allFilesType.
!

gciSession: aGciSession

	super gciSession: aGciSession.
	mySessionPresenter	gciSession: aGciSession.
	allSessionsPresenter	gciSession: aGciSession.
	stoneInfoPresenter	gciSession: aGciSession.
	toolbarPresenter	gciSession: aGciSession.
	transcriptPresenter	gciSession: aGciSession.
!

hasClassSideSelected
	^false!

inspectOop

	| string result |
	(string := Prompter prompt: 'Enter OOP Number:') isNil ifTrue: [^self].
	(string allSatisfy: [:each | each isDigit]) ifFalse: [
		MessageBox warning: 'Invalid number!!'.
		^self.
	].
	result := gciSession executeString: 'Object _objectForOop: ' , string.
	JadeInspector showOn: result session: gciSession.
!

methodsChanged24

| string result |
	
	result := gciSession executeString: '| result methods|
		result := MethodVersionHistory uniqueInstance methodsNewerThan: (DateTime now subtractDays: 1 ).
		methods := IdentitySet new.
		result do: [:e | e asCompiledMethod ifNotNil: [:m | methods add: m]].
		methods asArray'.
(JadeMethodListBrowser showOnSession: self gciSession) primaryPresenter
		browseMethods: result;
		yourself.
	"JadeInspector showOn: result session: gciSession."
!

methodsChangedDays

| string result |
	(string := Prompter prompt: 'Enter number of days:') isNil ifTrue: [^self].	
	result := gciSession executeString: '| result methods|
		result := MethodVersionHistory uniqueInstance methodsNewerThan: (DateTime now subtractDays: ' , string , ' ).
		methods := IdentitySet new.
		result do: [:e | e asCompiledMethod ifNotNil: [:m | methods add: m]].
		methods asArray'.
	(JadeMethodListBrowser showOnSession: self gciSession) primaryPresenter
		browseMethods: result;
		yourself.

!

onCloseRequested: boolValueHolder
 
	| answer flag |
	super onCloseRequested: boolValueHolder.
	boolValueHolder value ifFalse: [^self].
	gciSession isNil ifTrue: [^self].
	gciSession isValidSession ifFalse: [^self].
	gciSession logoutRequested ifFalse: [
		boolValueHolder value: false.
		^self.
	].
	flag := [
		gciSession serverPerform: #hasDirtyObjects.
	] on: Error do: [:ex | 		"https://github.com/jgfoster/Jade/issues/170"
		ex return: false.
	].
	flag ifTrue: [
		answer := MessageBox new
			caption: 'Close Requested';
			confirmOrCancel: 'Commit current transaction?'.
		boolValueHolder value: (#(#yes #no) includes: answer).
		answer = #yes ifTrue: [gciSession commit].
		boolValueHolder value ifFalse: [^self].
	].
	"We are going to close, so do some things first..."
	"self view hide."
	allSessionsPresenter aboutToClose.
	gciSession notNil ifTrue: [
		| temp |
		temp := gciSession.		"A logout will trigger closing all open windows, including this one."
		gciSession := nil.
		temp forceLogout.
	].
!

onViewOpened

	super onViewOpened.
	self view position: 95 @ 35.
	codePane view ensureVisible.!

queryCommand: aCommandQuery

	aCommandQuery command == #'stopHeartbeat' ifTrue: [aCommandQuery isEnabled: (self gciSession notNil and: [self gciSession hasHeartbeat]). ^true].
	aCommandQuery command == #'profStef' ifTrue: [aCommandQuery isEnabled: (self gciSession notNil and: [self gciSession isProfStefAvailable]). ^true].
	^super queryCommand: aCommandQuery.
!

resetCursor

	[Cursor current: nil] forkAt: Processor userBackgroundPriority.
!

sleepAndCommit

	[
		gciSession serverPerform: #'sleepAndCommit'.
	] on: GsSoftBreak , GsHardBreak do: [:ex | 
		ex terminateProcess.
	].
!

stopHeartbeat

	self gciSession stopHeartbeat.
!

updateCaption

	gciSession ifNil: [^self].
	self caption: (gciSession titleBarFor: 'Transcript').
! !
!JadeTranscript categoriesForMethods!
addJadeServerToUserGlobals!event handling!public! !
autocompletion!event handling!public! !
browseMonticelloRepositories!event handling!public! !
createComponents!public! !
createSchematicWiring!public! !
currentCardChanged!public! !
defaultFileExtension!event handling!public! !
describeErrorNumber!event handling!public! !
fileInPharo!event handling!public! !
fileOutJadeServer!event handling!public! !
fileTypes!event handling!public! !
gciSession:!private! !
hasClassSideSelected!public! !
inspectOop!event handling!public! !
methodsChanged24!event handling!public! !
methodsChangedDays!event handling!public! !
onCloseRequested:!event handling!public! !
onViewOpened!public!updating! !
queryCommand:!event handling!public! !
resetCursor!event handling!public! !
sleepAndCommit!event handling!public! !
stopHeartbeat!event handling!public! !
updateCaption!public! !
!

!JadeTranscript class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 1421 901 549 nil nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 592 nil nil nil 7 nil nil nil 592 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.JadeToolsToolBarPresenter) #resource_Default_view nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1 1 498 1389 51 592 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 946 #fixedParentRight 1 946 #fixedParentTop 1 946 #fixedViewTop 51 410 ##(Smalltalk.CardContainer) 34 16 nil 416 34 2 8 1140850688 131073 1024 nil 480 nil 7 nil nil nil 1024 656710 1 ##(Smalltalk.CardLayout) 138 144 34 6 721414 ##(Smalltalk.Association) 590662 1 ##(Smalltalk.CardLabel) 8 'Transcript' 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 7 1 16 8 'doIt' 8 'CardLabel text: ''Transcript'' iconBlock: [Icon fromId: ''TranscriptShell.ico'']' 8 #[45 30 35 113 47 32 180 106 195 105] 983558 ##(Smalltalk.VariableBinding) #CardLabel 1184 1216 1346 #Icon ##(Smalltalk.Icon) 8 'TranscriptShell.ico' #fromId: #text:iconBlock: 1248 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 1024 34 2 8 1140916224 131073 1408 nil 480 nil 5 nil nil nil 1408 658 ##(Smalltalk.TranscriptPresenter) #resource_Default_view nil 690 138 144 34 1 754 #createAt:extent: 34 2 498 9 53 498 1373 673 1408 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 178 2 0 0 106 1 0 0] 880 896 nil 27 1154 1186 8 'History' 1234 0 nil 1266 7 1 16 8 'doIt' 8 'CardLabel text: ''History'' iconBlock: [Icon fromId: ''MethodHistory.ico'']' 8 #[45 30 35 113 47 32 180 106 195 105] 1360 1664 1376 8 'MethodHistory.ico' #fromId: #text:iconBlock: 1680 11 1 nil nil 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 1024 34 2 8 1143017796 1025 1776 nil 480 nil 5 nil nil nil 1776 nil 8 1959998768 852486 ##(Smalltalk.NullConverter) nil nil 11 690 138 144 34 2 754 #createAt:extent: 34 2 498 9 53 498 1373 673 1776 754 #setMarginWidths: 34 1 8 #(3 3) 1776 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 178 2 0 0 106 1 0 0] 8 #() 896 nil 27 1154 1186 8 'Stone' 1234 0 nil 1266 7 1 16 8 'doIt' 8 'CardLabel text: ''Stone'' iconBlock: [Icon fromFile: ''icons\GS32.ico'']' 8 #[45 30 35 113 47 32 180 106 195 105] 1360 2128 1376 8 'icons\GS32.ico' #fromFile: #text:iconBlock: 2144 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 1024 34 2 8 1140850688 131073 2240 nil nil nil 5 nil nil nil 2240 658 ##(Smalltalk.StoneInfoPresenter) #resource_Default_view nil 690 138 144 34 1 754 #createAt:extent: 34 2 498 9 53 498 1373 673 2240 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 178 2 0 0 106 1 0 0] 880 896 nil 27 1154 1186 8 'My Session' 1234 0 nil 1266 7 1 16 8 'doIt' 8 'CardLabel text: ''My Session'' iconBlock: [Icon fromId: ''SMALLTALKOPTIONSFOLDER.ICO'']' 8 #[45 30 35 113 47 32 180 106 195 105] 1360 2496 1376 8 'SMALLTALKOPTIONSFOLDER.ICO' #fromId: #text:iconBlock: 2512 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 1024 34 2 8 1140850688 131073 2608 nil nil nil 5 nil nil nil 2608 658 ##(Smalltalk.MySessionPresenter) #resource_Default_view nil 690 138 144 34 1 754 #createAt:extent: 34 2 498 9 53 498 1373 673 2608 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 178 2 0 0 106 1 0 0] 880 896 nil 27 1154 1186 8 'All Sessions' 1234 0 nil 1266 7 1 16 8 'doIt' 8 'CardLabel text: ''All Sessions'' iconBlock: [Icon fromId: ''ListView.ico'']' 8 #[45 30 35 113 47 32 180 106 195 105] 1360 2864 1376 8 'ListView.ico' #fromId: #text:iconBlock: 2880 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 1024 34 2 8 1140850688 131073 2976 nil nil nil 5 nil nil nil 2976 658 ##(Smalltalk.AllSessionsPresenter) #resource_Default_view nil 690 138 144 34 1 754 #createAt:extent: 34 2 498 9 53 498 1373 673 2976 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 178 2 0 0 106 1 0 0] 880 896 nil 27 1154 1186 8 'Workspace' 1234 0 nil 1266 7 1 16 8 'doIt' 8 'CardLabel text: ''Workspace'' iconBlock: [Icon fromId: ''SmalltalkWorkspace.ico'']' 8 #[45 30 35 113 47 32 180 106 195 105] 1360 3232 1376 8 'SmalltalkWorkspace.ico' #fromId: #text:iconBlock: 3248 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 1024 34 2 8 1140850688 131073 3344 nil 480 nil 7 nil nil nil 3344 658 ##(Smalltalk.TranscriptPresenter) #resource_Default_view nil 690 138 144 34 1 754 #createAt:extent: 34 2 498 9 53 498 1373 673 3344 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 178 2 0 0 106 1 0 0] 880 896 nil 27 3344 nil nil nil 170 192 34 12 1408 8 'Transcript' 2240 8 'Stone' 3344 8 'codePane' 2976 8 'All Sessions' 1776 8 'history' 2608 8 'My Session' nil 410 ##(Smalltalk.TabView) 34 23 nil 1024 34 2 8 1140916736 1 3696 590662 2 ##(Smalltalk.ListModel) 138 144 34 6 1200 1648 2112 2480 2848 3216 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 #face3d nil 1 nil nil nil 3696 nil 8 1959710448 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #smallIcons 690 138 144 34 3 754 #createAt:extent: 34 2 498 1 1 498 1389 733 3696 754 #setSingleSelection: 8 #(6) 3696 754 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3696 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 110 1 0 0] 8 #() 896 nil 27 690 138 144 34 1 754 #createAt:extent: 34 2 498 1 51 498 1389 733 1024 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 182 2 0 0 135 1 0 0] 34 7 1408 1776 2240 2608 2976 3344 3696 896 nil 27 914 960 1 976 1 992 51 946 #fixedParentBottom 1 170 192 34 4 592 8 'Toolbar' 1024 8 'cardContainer' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 5 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New Workspace' 9373 1 nil nil nil 4498 1 4530 #fileOpen 8 '&Open Workspace...' 9375 1 nil nil nil 4498 1 4530 #fileSave 8 '&Save' 9383 1 nil nil nil 4498 1 4530 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 4498 1 4530 #fileRevert 8 '&Revert' 1025 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4498 1 4530 #resetCursor 8 'Reset &Cursor' 1025 1 nil nil nil 4498 1 4530 #fileInPharo 8 'Translate Pharo to Topaz...' 1 1 nil nil nil 4770 4097 4498 1 4530 #exit 8 'E&xit Jade' 17639 1 nil nil nil 8 '&File' nil 1 nil nil 14689 nil nil 4450 nil true 34 15 4498 1 4530 #undo 8 '&Undo' 9397 1 nil nil nil 4498 1 4530 #redo 8 'R&edo' 9395 1 nil nil nil 4770 4097 4498 1 4530 #editCut 8 'Cu&t' 9393 1 nil nil nil 4498 1 4530 #editCopy 8 '&Copy' 9351 1 nil nil nil 4498 1 4530 #editPaste 8 '&Paste' 9389 1 nil nil nil 4498 1 4530 #editSelectAll 8 'Select &All' 9347 1 nil nil nil 4498 1 4530 #editDelete 8 '&Delete' 1629 1 nil nil nil 4770 4097 4498 1 4530 #editFind 8 '&Find...' 9357 1 nil nil nil 4498 1 4530 #editFindNext 8 'Find &Next' 1253 1 nil nil nil 4498 1 4530 #editReplace 8 '&Replace...' 9361 1 nil nil nil 4770 4097 4498 1 4530 #addQuotesToSelection 8 'Add &Quotes' 1 1 nil nil nil 4498 1 4530 #removeQuotesFromSelection 8 'Re&move Quotes' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil 14715 nil nil 4450 nil true 34 10 4498 1 4530 #jadeBrowseClasses 8 '&Browse Classes' 9349 1 nil nil nil 4498 1 4530 #browseMonticelloRepositories 8 'Browser &Monticello Repositories' 9371 1 nil nil nil 4498 1 4530 #jadeBrowseObjectLog 8 'Browse &Object Log' 9369 1 nil nil nil 4498 1 4530 #browseProcesses 8 'Browse &Processes' 9377 1 nil nil nil 4498 1 4530 #jadeBrowseTests 8 'Browse SUnit &Tests' 9385 1 nil nil nil 4498 1 4530 #autocompletion 8 'Configure Autocompletion' 1 1 nil nil nil 4498 1 4530 #profStef 8 'Prof&Stef Tutorial' 1 1 nil nil nil 4770 4097 4498 1 4530 #inspectOop 8 'Inspect Oop ...' 1 1 nil nil nil 4498 1 4530 #describeErrorNumber 8 'Description for Error Number ...' 1025 1 nil nil nil 8 '&Browse' nil 134217729 nil nil 14735 nil nil 4450 nil true 34 13 4498 1 4530 #stopHeartbeat 8 'Stop Idle Session Check' 1 1 nil nil nil 4498 1 4530 #sleepAndCommit 8 '&Sleep and Commit' 1 1 nil nil nil 4498 1 4530 #abortTransaction 8 '&Abort Transaction' 1 1 nil nil nil 4498 1 4530 #commitTransaction 8 '&Commit Transaction' 1 1 nil nil nil 4770 4097 4498 1 4530 #jadeInspect 8 '&Inspect' 9379 1 nil nil nil 4498 1 4530 #jadeDisplay 8 '&Display' 9353 1 nil nil nil 4498 1 4530 #jadeExecute 8 '&Execute' 9355 1 nil nil nil 4498 1 4530 #jadeDebug 8 'Debu&g' 9359 1 nil nil nil 4498 1 4530 #fileIn 8 'Fi&le In' 1 1 nil nil nil 4770 4097 4498 1 4530 #fileOutJadeServer 8 '&File Out JadeServer' 1 1 nil nil nil 4498 1 4530 #addJadeServerToUserGlobals 8 'Add JadeServer to UserGlobals' 1 1 nil nil nil 8 '&Jade' nil 1 nil nil 14759 nil nil 4450 nil true 34 1 4498 1 4530 #aboutJade 8 '&About Jade' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 14763 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'icons\GS32.ico' nil 6866 nil true 6912 8 'icons\GS16.ico' nil nil nil 1 nil nil 690 138 144 34 2 754 #createAt:extent: 34 2 498 5119 21 498 1421 901 416 754 #text: 34 1 8 'Jade Session' 416 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 197 12 0 0 204 1 0 0] 34 2 592 1024 896 nil 27 )! !
!JadeTranscript class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

