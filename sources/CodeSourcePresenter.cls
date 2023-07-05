"Filed out from Dolphin Smalltalk"!

JadePresenterA subclass: #CodeSourcePresenter
	instanceVariableNames: 'documentPresenter menuTitle environment'
	classVariableNames: 'CodeFont'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CodeSourcePresenter guid: (GUID fromString: '{549a5009-cdd1-42b3-8907-c3c5c1c9e532}')!
CodeSourcePresenter comment: 'model - the context in which code can be executed'!
!CodeSourcePresenter categoriesForClass!Unclassified! !
!CodeSourcePresenter methodsFor!

abortTransaction

	gciSession abort.
	Sound informationBeep.
!

addMenu

	| menuBar |
	menuBar := self view topShell view menuBar.
	self updateMenuBar: menuBar.
	self view topShell view menuBar: menuBar.
!

addMenuTo: aMenuBar

	self updateMenuBar: aMenuBar.
!

addQuotesToSelection

	documentPresenter view replaceSelection: documentPresenter selection printString.
!

browseImplementors

	self browseImplementorsOf: self currentSelector.!

browseSelectedClass

	| range string list assoc |
	range := documentPresenter view selectionRange.
	string := (documentPresenter value copyFrom: range start to: range stop) asCharacterCollection.
	list := self findClassList.
	assoc := list 
		detect: [:each | each key asCharacterCollection = string]
		ifNone: [^MessageBox warning: 'Class ' , string printString , ' not found!!!!' caption: 'Jade'].
	parentPresenter parentPresenter parentPresenter addSystemBrowserForClass: assoc value.
!

browseSenders

	self browseSendersOf: self currentSelector.!

clearBreakAtStepPoint: anInteger

	| method |
	(method := self trigger: #'needMethod') isNil ifTrue: [^self].
	method clearBreakAtStepPoint: anInteger.
!

clearSelection
	^self editDelete!

codeFont: aFont

	documentPresenter view font: aFont.
!

codePresenterIsMethod

	^false!

copySelection

	documentPresenter view
		copySelection;
		updateModel;
		yourself.
!

currentSelectionOrLine
	"answers CharacterCollection"
 
	| range |
	documentPresenter hasSelection ifFalse: [documentPresenter view selectCurrentLine].
	range := documentPresenter view selectionRange.
	^(documentPresenter value copyFrom: range start to: range stop) asCharacterCollection.
!

currentSelector

	| selection |
	selection := documentPresenter view selection.
	^[
		(SmalltalkParser parseMethod: selection) selector.
	] on: Error do: [:ex | 
		selection.
	]
!

cutSelection
	^self editCut!

documentPresenter

	^documentPresenter!

editCut

	documentPresenter view
		cutSelection;
		updateModel;
		yourself.
!

editDelete

	documentPresenter view
		clearSelection;
		updateModel;
		yourself.
!

editFind

	documentPresenter view editFind.
	self showSelection.
!

editFindNext

	documentPresenter view findNext.
	self showSelection.

!

editPaste

	documentPresenter view
		pasteClipboard;
		updateModel;
		yourself.
!

editReplace

	documentPresenter view
		findReplace;
		updateModel;
		yourself.
!

editSelectAll

	documentPresenter view selectAll.
!

environment: anInteger

	environment := anInteger.
!

executeSelectionOrLine

	| contextObject |
	contextObject := self topShell isJadeInspector 
		ifTrue: [self topShell contextObject] 
		ifFalse: [model].
	[
		^true -> (gciSession executeString: self currentSelectionOrLine fromContext: contextObject environment: environment).
	] on: GsCompileError do: [:ex | 
		^false -> ex list.
	].
	self error: 'How did we get here?'.
	^false -> #(nil).
!

fileSave
		"Private - Answer whether the save succeeded (false means to stay on the window and cancel any attempt to leave)"

	^parentPresenter fileSave!

findClassList
	"
	Array with: className with: dictionaryName with: catetory with: packageName.
"

	| string list |
	string := self gciSession serverPerform: #systemBrowser:
				with: (self gciSession encode: '0 findClass').
	string := self gciSession decode: string.
	list := (string subStringsTrimmingTrailingEmptyElement: Character lf)
				collect: [:each | each subStrings: Character tab].
	list := list copyFrom: 2 to: list size.
	list := list collect: [:each | each size < 3 ifTrue: [each , #('' '' '')] ifFalse: [each]].
	list := list collect: [:each | (each at: 1) -> each].
	^list!

handleInvalidSession

	documentPresenter view isModified ifFalse: [^false].
	self ensureVisible.
	documentPresenter ensureVisible.
	documentPresenter view isModified: false.
	(MessageBox confirm: 'Copy unsaved method to clipboard?' caption: 'Invalid Session!!') ifTrue: [
		documentPresenter value copyToClipboard.
	].
	^true
!

initialize

	super initialize.
	environment := 0.
!

isClassSelectedInEditor

	| range string |
	(range := documentPresenter view selectionRange) isEmpty ifTrue: [^false].
	string := (documentPresenter value copyFrom: range start to: range stop) asCharacterCollection.
	^(string allSatisfy: [:each | each isAlphaNumeric]) and: [string first isLetter and: [string first isUppercase]]
!

isModified

	^documentPresenter isModified!

isModified: aBoolean

	^documentPresenter isModified: aBoolean!

jadeDebug

	[
		gciSession 
			debugString: (gciSession encode: self currentSelectionOrLine) 
			fromContext: model 
			environment: environment.
	] on: GsCompileError do: [:ex | 
		self jadeExecute.
	].
!

jadeDisplay
  
	self jadeExecuteAndDisplay: true.
!

jadeExecute

	self jadeExecuteAndDisplay: false.
!

jadeExecuteAndDisplay: showResult 
  
	| result |
	result := self executeSelectionOrLine.
	result key ifTrue: [
		showResult ifTrue: [
			self showResult: result value.
		] ifFalse: [
			self setCaretToEndOfSelection.
		].
		^result value.
	] ifFalse: [
		self showCompileError: result value first.
		^self		"flag for compile error"
	].
!

menuTitle: aString

	menuTitle := aString.
!

mySave
!

pasteClipboard
	^self editPaste!

queryCommand: query

	(#(#'fileSave') includes: query commandSymbol) ifTrue: [
		query isEnabled: documentPresenter isModified.
		^true.
	].
	(#(#cutSelection #copySelection) includes: query commandSymbol) ifTrue: [
		query isEnabled: documentPresenter hasSelection.
		^true.
	].
	(query commandSymbol = #pasteClipboard) ifTrue: [
		query isEnabled: documentPresenter view canPaste.
		^true.
	].
	(query commandSymbol == #'browseSelectedClass') ifTrue: [
		query isEnabled: self isClassSelectedInEditor.
		^true
	].
	^super queryCommand: query.
!

removeMenu

	| menuBar item |
	(menuBar := self view topShell view menuBar) isNil ifTrue: [^self].
	item := menuBar items 
		detect: [:each | each text = self subMenuName]
		ifNone: [^self].
	menuBar removeItem: item.
	self view topShell view menuBar: menuBar.
!

removeQuotesFromSelection

	| string |
	string := documentPresenter view selection trimBlanks asCharacterCollection.
	(string size >= 2 and: [string first = $' and: [string last = $']]) ifFalse: [
		^MessageBox notify: 'Selection must begin and end with quote'.
	].
	string := string copyFrom: 2 to: string size - 1.
	string := string 
		copyReplaceAll: ''''''
		with: ''''.
	documentPresenter view replaceSelection: string asUtf8String.
!

selectAll
	^self editSelectAll!

selectionChanging: aSelectionChangingEvent 

	(documentPresenter view isKindOf: DeafObject) ifTrue: [^self].
	documentPresenter view isModified ifFalse: [^self].
	documentPresenter view ensureVisible.
	MessageBox 
		confirm: 'Save changes?' 
		onYes: 	[aSelectionChangingEvent value: self fileSave] 
		onNo: 	[documentPresenter view isModified: false] 
		onCancel: 	[aSelectionChangingEvent value: false].
!

setBreakAtStepPoint: anInteger

	| method |
	(method := self trigger: #'needMethod') isNil ifTrue: [^self].
	method setBreakAtStepPoint: anInteger.
	self trigger: #'breaksChanged'.
!

setCaretToEndOfSelection

	| textView |
	textView := documentPresenter view.
	textView caretPosition: textView selectionRange stop + 1.
!

setDocumentPresenterWith: aJadeGsClassShape

	documentPresenter lastGsShape: aJadeGsClassShape!

setFont

	| font |
	font := CodeFont notNil
		ifTrue: [FontDialog showModalOn: CodeFont]
		ifFalse: [FontDialog showModal].
	font notNil ifTrue: [
		self class codeFont: font.
	]
!

showCompileError: anArray

	| result string count textView selectionRange offset |
	textView := documentPresenter view.
	offset := anArray at: 2.
	result := anArray at: 3.
	selectionRange := textView selectionRange.
	string := textView value.
	string := string copyFrom: selectionRange start to: selectionRange stop.
	string := string copyFrom: 1 to: offset - 1.
	count := (string select: [:each | each = Character lf]) size.
	offset := offset + count.
	textView
		caretPosition: selectionRange start + offset - 1;
		replaceSelection: result;
		selectionStart: textView caretPosition - result size length: result size.
!

showResult: anObject

	| result textView |
	(gciSession isOopType: anObject) ifFalse: [
		result := ' ' , anObject printString.
	] ifTrue: [
		result := ' ' , (gciSession printString: anObject).
	].
	self setCaretToEndOfSelection.
	(textView := documentPresenter view)
		replaceSelection: result asUtf8String;
		selectionStart: textView caretPosition - result size length: result size.
!

showSelection

	| range lineNumber |
	(range := documentPresenter view selectionRange) isEmpty ifTrue: [^self].
	lineNumber := documentPresenter view lineFromPosition: range first.
	lineNumber := lineNumber - 4 max: 1.
	documentPresenter view lineScroll: lineNumber.
!

subMenuName

	^menuTitle.
!

subMenuPresenter

	^documentPresenter.
!

text: aString

	documentPresenter value: aString.
!

textStyles

	^documentPresenter view editStyles textStyles!

undo

	documentPresenter view undo!

update

	self subclassResponsibility.
!

updateCodeFont

	CodeFont notNil ifTrue: [
		documentPresenter view font: CodeFont.
	].
! !
!CodeSourcePresenter categoriesForMethods!
abortTransaction!Jade!public! !
addMenu!menus!public! !
addMenuTo:!menus!public! !
addQuotesToSelection!edit!private! !
browseImplementors!public! !
browseSelectedClass!public! !
browseSenders!public! !
clearBreakAtStepPoint:!Breakpoints!public! !
clearSelection!public! !
codeFont:!public! !
codePresenterIsMethod!public! !
copySelection!edit!private! !
currentSelectionOrLine!Jade!private! !
currentSelector!public! !
cutSelection!public! !
documentPresenter!public! !
editCut!edit!private! !
editDelete!edit!private! !
editFind!edit!private! !
editFindNext!edit!private! !
editPaste!edit!private! !
editReplace!edit!private! !
editSelectAll!edit!private! !
environment:!public! !
executeSelectionOrLine!Jade!private! !
fileSave!private! !
findClassList!public! !
handleInvalidSession!public! !
initialize!public! !
isClassSelectedInEditor!public! !
isModified!public! !
isModified:!public! !
jadeDebug!Jade!private! !
jadeDisplay!Jade!private! !
jadeExecute!Jade!private! !
jadeExecuteAndDisplay:!Jade!private! !
menuTitle:!menus!public! !
mySave!private! !
pasteClipboard!public! !
queryCommand:!public! !
removeMenu!menus!public! !
removeQuotesFromSelection!edit!private! !
selectAll!public! !
selectionChanging:!public! !
setBreakAtStepPoint:!Breakpoints!public! !
setCaretToEndOfSelection!Jade!private! !
setDocumentPresenterWith:!public! !
setFont!private! !
showCompileError:!Jade!private! !
showResult:!Jade!private! !
showSelection!edit!private! !
subMenuName!menus!public! !
subMenuPresenter!menus!public! !
text:!public! !
textStyles!public! !
undo!Jade!private! !
update!public! !
updateCodeFont!public! !
!

!CodeSourcePresenter class methodsFor!

codeFont

	^CodeFont.
!

codeFont: aFont

	CodeFont := aFont.
	self withAllSubclassesDo: [:eachClass | 
		eachClass allInstances do: [:each | 
			each codeFont: aFont.
		].
	].
	JadeTextDocument withAllSubclassesDo: [:eachClass | 
		eachClass allInstances do: [:each | 
			each updateCodeFont.
		].
	].
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140851500 131137 544 nil 327686 ##(Smalltalk.Color) #default nil 517 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 544 624 8 1960817936 170 192 8 #() 170 192 34 26 11915 1115206 1 ##(Smalltalk.ToolbarIconButton) 544 1 1180998 4 ##(Smalltalk.CommandDescription) #editPaste 8 'Paste' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditPaste.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 11915 11925 834 544 1 866 #editReplace 8 'Replace' 1 1 914 nil true 960 8 'FindNext.ico' 1008 11925 11909 834 544 1 866 #fileSave 8 'Save' 1 1 914 nil true 960 8 'FileSave.ico' 1008 11909 11919 834 544 1 866 #undo 8 'Undo' 1 1 914 nil true 960 8 'EditUndo.ico' 1008 11919 11903 834 544 1 866 #jadeExecute 8 'Evaluate Selection or Line' 1 1 914 nil true 960 8 'EvaluateIt.ico' 1008 11903 11913 834 544 1 866 #copySelection 8 'Copy' 1 1 914 nil true 960 8 'EditCopy.ico' 1008 11913 11923 834 544 1 866 #editFind 8 'Find' 1 1 914 nil true 960 8 'Find.ico' 1008 11923 11907 834 544 1 866 #jadeDebug 8 'Debug Selection or Line' 1 1 914 nil true 960 8 'Debugger.ico' 1008 11907 11917 834 544 1 866 #editDelete 8 'Delete' 1 1 914 nil true 960 8 'EditClear.ico' 1008 11917 11901 834 544 1 866 #jadeDisplay 8 'Print Result of Selection or Line' 1 1 914 nil true 960 8 'DisplayIt.ico' 1008 11901 11911 834 544 1 866 #editCut 8 'a CommandDescription(Cut)' 1 1 914 nil true 960 8 'EditCut.ico' 1008 11911 11921 834 544 1 866 #redo 8 'Redo' 1 1 914 nil true 960 8 'EditRedo.ico' 1008 11921 11905 834 544 1 866 #jadeInspect 8 'Inspect Selection or Line' 1 1 914 nil true 960 8 'InspectIt.ico' 1008 11905 34 16 1680 1280 1920 1520 1049158 1 ##(Smalltalk.ToolbarSeparator) 544 1 1120 2018 544 1 1760 1360 848 1600 1200 1840 2018 544 1 1440 1040 nil nil 1 nil 722 33 33 722 45 45 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 722 1 1 722 1001 51 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 244 1 0 0 25 0 0 0] 8 #() 722 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 2370 #fixedParentRight 1 2370 #fixedParentTop 1 2370 #fixedViewTop 51 410 ##(Smalltalk.ScintillaView) 34 65 nil 416 34 2 8 1445007428 1025 2448 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 624 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 24 984134 2 ##(Smalltalk.CommandMenuItem) 1 866 #fileSave 8 '&Save' 9383 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2626 1 866 #undo 8 '&Undo' 9397 1 nil nil nil 2626 1 866 #redo 8 'R&edo' 9395 1 nil nil nil 2690 4097 2626 1 866 #editCut 8 'Cu&t' 9393 1 nil nil nil 2626 1 866 #editCopy 8 '&Copy' 9351 1 nil nil nil 2626 1 866 #editPaste 8 '&Paste' 9389 1 nil nil nil 2626 1 866 #editDelete 8 'De&lete' 1629 1 nil nil nil 2626 1 866 #editSelectAll 8 'Select &All' 9347 1 nil nil nil 2690 4097 2626 1 866 #editFind 8 '&Find...' 9357 1 nil nil nil 2626 1 866 #editFindNext 8 'Find &Next' 9359 1 nil nil nil 2626 1 866 #editReplace 8 '&Replace...' 9361 1 nil nil nil 2690 4097 2626 1 866 #jadeInspect 8 '&Inspect' 9379 1 nil nil nil 2626 1 866 #jadeDisplay 8 '&Display' 9353 1 nil nil nil 2626 1 866 #jadeExecute 8 'Execute' 9355 1 nil nil nil 2626 1 866 #jadeDebug 8 'De&bug' 1025 1 nil nil nil 2690 4097 2626 1 866 #addQuotesToSelection 8 'Add &Quotes' 1 1 nil nil nil 2626 1 866 #removeQuotesFromSelection 8 'Re&move Quotes' 1 1 nil nil nil 2690 4097 2626 1 866 #fileIn 8 'File In' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil 642 nil true 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 86 101 114 100 97 110 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 722 193 193 nil 2448 nil 8 1963343336 852486 ##(Smalltalk.NullConverter) nil nil 9 477908401 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 610 #gray 610 #white 1 nil nil nil nil #callTip nil nil nil #normal 3778 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 784 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 2448 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 784 nil 170 176 784 9215 nil nil nil nil 610 #silver nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 170 192 34 4 #callTip 3792 #normal 3840 nil nil nil nil 208 nil 170 192 34 14 1 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 2448 196934 1 ##(Smalltalk.RGB) 65025 3 false 1 nil nil nil nil nil nil #secondarySelection 4210 23 2448 nil 15 nil #secondarySelection 31 nil nil nil nil nil 8 'indicator10' 4210 21 2448 610 #red 3 nil nil nil nil nil nil nil nil 3 4210 3 2448 610 #blue 5 false 3 nil nil nil nil nil nil 8 'indicator9' 4210 19 2448 610 #red 13 nil nil nil nil nil nil nil nil 8 'indicator8' 4210 17 2448 610 #silver 1 nil nil nil nil nil nil nil nil 5 4210 5 2448 610 #red 1 false 5 nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 3778 1027 4242 60239 4242 31326207 1 nil nil nil nil #Warning nil nil nil #Error 3778 1031 4242 335 4242 31317503 1 nil nil nil nil #Error nil nil nil #Notification 3778 1029 nil 4242 31185883 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 2114 138 144 34 10 2178 #createAt:extent: 34 2 722 1 51 722 1001 551 2448 2178 #contextMenu: 34 1 2592 2448 2178 #hoverTime: 8 #(200) 2448 2178 #caretPeriod: 8 #(530) 2448 2178 #sciSetEOLMode: 8 #(2) 2448 2178 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 2448 61 3 nil nil nil nil 4946 3 2448 1 nil 3 67108863 nil nil 4946 5 2448 1 nil 3 -67108863 nil nil 2448 2178 #tabWidth: 8 #(4) 2448 2178 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 2448 2178 #maxCompletionListHeight: 8 #(9) 2448 2178 #edgeColumn: 8 #(1) 2448 2258 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 244 1 0 0 44 1 0 0] 8 #() 2320 nil 33 2338 2384 1 2400 1 2370 #fixedPreviousBottom 1 2370 #fixedParentBottom 1 170 192 34 2 2448 8 'document' nil 2114 138 144 34 1 2178 #createAt:extent: 34 2 722 5119 21 722 1001 601 416 2258 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 243 11 0 0 54 1 0 0] 34 2 544 2448 2320 nil 27 )! !
!CodeSourcePresenter class categoriesForMethods!
codeFont!public! !
codeFont:!public! !
resource_Default_view!public!resources-views! !
!

