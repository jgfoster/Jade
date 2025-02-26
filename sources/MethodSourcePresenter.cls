﻿"Filed out from Dolphin Smalltalk"!

CodeSourcePresenter subclass: #MethodSourcePresenter
	instanceVariableNames: 'currentSelector gsMethod originalSource'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MethodSourcePresenter guid: (GUID fromString: '{4eda4c47-5b55-436d-b9e2-ef2042660a98}')!

MethodSourcePresenter comment: ''!

!MethodSourcePresenter categoriesForClass!Unclassified! !

!MethodSourcePresenter methodsFor!

canSetBreakpoints

	^true.
!

clearBreakAtStepPoint: anInteger

	gsMethod clearBreakAtStepPoint: anInteger.
	self updateMethodStepPoints.
!

codePresenterIsMethod

	^true!

createSchematicWiring

	super createSchematicWiring.
	documentPresenter
		when: #'hoverStart:'				send: #'hoverStart:'			to: self;
		when: #'hoverEnd:'				send: #'hoverEnd:'			to: self;
		when: #'aboutToDisplayMenu:'		send: #'methodMenu:'		to: self;
		"when: #'leftButtonDoubleClicked:'	send: #'methodDoubleClicked:'	to: self;
		when: #'valueChanged'			send: #'methodValueChanged'	to: self;"
		when: #'focusLost'				send: #'cancelCallTip'			to: documentPresenter view;
		yourself.
!

defaultMethod

^'methodSelector
	"method comment"

	| temps |
	^self yourself.
'.
!

editMenuStrings

	false ifTrue: [
		self fileSave; undo; redo; cutSelection; copySelection; pasteClipboard; clearSelection; selectAll; editFind; editFindNext; editReplace; 
			jadeDisplay; jadeExecute; jadeInspect; browseSelectedClass.
	].
	^#(
		'&Edit'
		'&Save/Ctrl+S/fileSave'
		'-'
		'&Undo/Ctrl+Z/undo'
		'&Redo/Ctrl+Y/redo'
		'-'
		'&Reformat Source/Ctrl+R/reformatSource'
		'-'
		'&Cu&t/Ctrl+X/cutSelection'
		'&Copy/Ctrl+C/copySelection'
		'&Paste/Ctrl+V/pasteClipboard'
		'&Delete/Delete/clearSelection'
		'-'
		'Select &All/Ctrl+A/selectAll'
		'-'
		'&Find/Ctrl+F/editFind'
		'Find &Next/F3/editFindNext'
		'&Replace/Ctrl+H/editReplace'
		'-'
		'Display/Ctrl+D/jadeDisplay'
		'Execute/Ctrl+E/jadeExecute'
		'Inspect/Ctrl+Q/jadeInspect'
		'Browse Class/Ctrl+B/browseSelectedClass'
	).
!

fileSave
		"Answer whether the save succeeded (false means to stay on the window and cancel any attempt to leave)"

	| user theClass newSelector category string stream list warnings errors index a b c methodExists line newOop |
	(theClass := gsMethod behavior) isNil ifTrue: [^true].
	newSelector := self newSelector.
	currentSelector = newSelector ifFalse: [
		methodExists := gciSession
			serverPerform: #'class:includesSelector:'
			with: theClass
			with: (gciSession encode: newSelector).
		methodExists ifTrue: [
			(MessageBox confirm: 'Replace method?' caption: 'Method already exists!!') ifFalse: [^self].
		].
	].
	user := self trigger: #'needUser'.
	(category := gsMethod category) isNil ifTrue: [self error: 'We need a method category!!?'].
	string := gciSession
		serverPerform: #'compileMethod:behavior:user:inCategory:'
		with: (gciSession encode: documentPresenter value)
		with: theClass 
		with: user 
		with: category.
	string := gciSession decode: string.
	stream := ReadStream on: string.
	(line := stream nextLine) notEmpty ifTrue: [
		| pieces |
		pieces := line subStrings: Character tab.
		newOop := (pieces at: 1) asNumber. 
		(newOop isKindOf: Integer) ifFalse: [self error: 'Expected an Integer but got ' , newOop printString].
		newSelector := pieces at: 2.
		documentPresenter isModified: false.
		self 
			trigger: #'savedMethod:inClass:' 
			with: newSelector
			with: theClass.
		parentPresenter updateSaveMethodOop: newOop.
	].
	(list := stream upToEnd subStrings: Character lf) isEmpty ifTrue: [^true].
	warnings := list select: [:each | each beginsWith: 'WARNING:'].
	warnings := warnings collect: [:each | each copyFrom: 10 to: each size].
	warnings notEmpty ifTrue: [
		ChoicePrompter
			choices: warnings
			caption: 'Compile warnings'.
	].
	errors := list select: [:each | each beginsWith: 'ERROR:'].
	errors isEmpty ifTrue: [^true].
	list := errors first subStrings: Character tab.
	string := documentPresenter value.
	index := (list at: 3) asNumber - 1.
	a := (string copyFrom: 1 to: index) "replaceLfWithCrLf".
	b := (list at: 4) "replaceLfWithCrLf".
	c := (string copyFrom: index + 1 to: string size) "replaceLfWithCrLf".
	index := a size + 1.
	string := a , b , c.
	documentPresenter value: string.
	documentPresenter view
		selectionStart: index 
		length: b size.
	^false.
!

gsMethod: aGsMethod
	gsMethod := aGsMethod.
	self update.!

hoverEnd: anObject

	documentPresenter view cancelCallTip.!

hoverStart: aPoint

	| charIndex indicator |
	charIndex := documentPresenter view charNearestPosition: aPoint.
	indicator := documentPresenter view indicators
		detect: [:each | each range includes: charIndex]
		ifNone: [^self].
	documentPresenter view 
		showCallTip: indicator tag
		at: charIndex.
!

isOkayToChange

	documentPresenter isModified ifTrue: [
		documentPresenter ensureVisible.
		gciSession isValidSession
			ifTrue: [(MessageBox confirm: 'Stay on unsaved method?' caption: 'Method has unsaved changes!!') ifTrue: [^false]]
			ifFalse: [(MessageBox confirm: 'Copy changes to Clipboard?' caption: 'Method has unsaved changes!!') ifTrue: [documentPresenter selectAll; copySelection]].
		documentPresenter isModified: false.
	].
	^true!

methodDoubleClicked: anObject

	| range string |
	range := documentPresenter view selectionRange.
	string := documentPresenter value.
	string size = range stop ifTrue: [^self].
	(string at: range stop + 1) = $: ifFalse: [^self].
	range stop: range stop + 1.
	documentPresenter view selectionRange: range.
!

methodMenu: aMenu

	| properSize |
	properSize := self editMenuStrings size - 1.
	[
		properSize < aMenu items size.
	] whileTrue: [
		aMenu removeItemAt: aMenu items size.
	].
	self methodMenuBreak: aMenu.
!

methodMenuBreak: aMenu

	| desc command message selector stepPoint |
	documentPresenter view isModified ifTrue: [^self].
	stepPoint := self stepPointAt: documentPresenter view cursorPosition.
	stepPoint isNil ifTrue: [^self].
	(gsMethod breakPoints includes: stepPoint) ifTrue: [
		selector := #'clearBreakAtStepPoint:'.
		desc := 'Clear break at step point ' , stepPoint printString.
	] ifFalse: [
		selector := #'setBreakAtStepPoint:'.
		desc := 'Break at step point ' , stepPoint printString.
	].
	command := MessageSend 
		receiver: self 
		selector: selector 
		arguments: (Array with: stepPoint).
	aMenu 
		addSeparator;
		addCommand: command description: desc;
		yourself.
	(message := (gsMethod stepPoints at: stepPoint) value) isEmpty ifTrue: [^self].
	command := MessageSend
		receiver: self 
		selector: #'browseImplementorsOf:' 
		argument: message.
	aMenu
		addCommand: command
		description: 'Browse Implementors of #' , message printString.
	command := MessageSend
		receiver: self 
		selector: #'browseSendersOf:' 
		argument: message.
	aMenu
		addCommand: command
		description: 'Browse Senders of #' , message printString.
!

methodSource

	^documentPresenter value.
!

newSelector

	| string index list stream |
	string := documentPresenter value.
	#($" $| $. $;) do: [:each | 
		index := string indexOf: each.
		2 < index ifTrue: [string := string copyFrom: 1 to: index - 1].
	].
	list := string subStrings.
	string first isPunctuation ifTrue: [^list first asSymbol].
	list first last = $: ifFalse: [^list first asSymbol].
	stream := WriteStream on: String new.
	index := 1.
	[
		index < list size and: [(list at: index) last = $:].
	] whileTrue: [
		stream nextPutAll: (list at: index).
		index := index + 2.
	].
	^stream contents asSymbol.


!

onViewOpened

	super onViewOpened.
	documentPresenter view contextMenu: (Menu fromStrings: self editMenuStrings).
	self 
		updateCodeFont;
		setDefaultMethod;
		yourself.
!

setBreakAtStepPoint: anInteger

	gsMethod setBreakAtStepPoint: anInteger.
	self updateMethodStepPoints.
!

setDefaultMethod

	documentPresenter 
		value: self defaultMethod;
		isModified: false;
		isReadOnly: false;
		yourself.
!

setEmptyMethod

	self statusBarText: ''.
	documentPresenter 
		value: '';
		isModified: false;
		isReadOnly: true;
		selectionRange: (1 to: 0);
		yourself.
!

showStepPoint: anInteger

	| lineNumber range stepPoint |
	stepPoint := gsMethod stepPoints at: anInteger.
	documentPresenter view selectionRange: stepPoint key.
	(range := documentPresenter view selectionRange) isEmpty ifTrue: [^self].
	lineNumber := documentPresenter view lineFromPosition: range first.
	lineNumber := lineNumber - 4 max: 1.
	documentPresenter view lineScroll: lineNumber.
!

stepPointAt: aPoint

	| charIndex stepPoints |
	stepPoints := gsMethod stepPoints.
	charIndex := documentPresenter view charNearestPosition: aPoint.
	stepPoints size to: 1 by: -1 do: [:stepPoint | 
		| range |
		range := (stepPoints at: stepPoint) key.
		(range start <= charIndex and: [charIndex <= range stop]) ifTrue: [
			^stepPoint.
		].
	].
	^nil.
!

update

	| newSource string |
	documentPresenter view cancelCallTip.
	newSource := gsMethod ifNil: [''] ifNotNil: [gsMethod source].
	documentPresenter view isModified ifTrue: [
		newSource = originalSource ifTrue: [^self].
		(MessageBox confirm: 'Copy changes to clipboard?' caption: 'Method has unsaved changes!!') ifTrue: [
			originalSource value copyToClipboard.
		].
	].
	self setEmptyMethod.
	gsMethod ifNil: [^self].
	string := "package" ' -- ' , gsMethod category , ' -- ' "mcTimestamp".
	self statusBarText: string.
	originalSource := newSource.
	documentPresenter 
		value: originalSource;
		isModified: false;
		isReadOnly: gsMethod isReadOnly;
		yourself.
	documentPresenter view 
		backcolor: JadeTextStyles default colorForNoEdits;
		isEnabled: true;
		yourself.
	self updateMethodStepPoints.
	currentSelector := gsMethod selector.
!

updateMethodStepPoints

	| breakPoints indicators stepPoints unimplementedSelectors |
	breakPoints := gsMethod breakPoints.
	stepPoints := gsMethod stepPoints.
	unimplementedSelectors := gsMethod unimplementedSelectors.
	documentPresenter view clearContainerIndicators.
	indicators := OrderedCollection new.
	1 to: stepPoints size do: [:stepPoint |
		| range string styleName |
		range := (stepPoints at: stepPoint) key.
		(unimplementedSelectors at: range start ifAbsent: [nil]) ifNotNil: [:value | 
			styleName := 10.
			string := 'No implementors of #' , value printString , ' (found at step point #' , stepPoint printString , ')'.
		] ifNil: [
			styleName := (breakPoints includes: stepPoint) ifTrue: [9] ifFalse: [8].
			string := ((breakPoints includes: stepPoint) ifTrue: ['Break at '] ifFalse: ['']) , 'step point #' , stepPoint printString.
		].
		indicators add: (ScintillaIndicator
			styleName: styleName 
			range: range 
			tag: string).
	].
	documentPresenter view indicators: indicators.
! !

!MethodSourcePresenter categoriesForMethods!
canSetBreakpoints!Breakpoints!public! !
clearBreakAtStepPoint:!public! !
codePresenterIsMethod!public! !
createSchematicWiring!Jade!private! !
defaultMethod!public! !
editMenuStrings!Jade!private! !
fileSave!public! !
gsMethod:!public! !
hoverEnd:!Jade!private! !
hoverStart:!Jade!private! !
isOkayToChange!Jade!private! !
methodDoubleClicked:!Jade!private! !
methodMenu:!Jade!private! !
methodMenuBreak:!Jade!private! !
methodSource!public! !
newSelector!public! !
onViewOpened!public! !
setBreakAtStepPoint:!public! !
setDefaultMethod!public! !
setEmptyMethod!public! !
showStepPoint:!public! !
stepPointAt:!Jade!private! !
update!public! !
updateMethodStepPoints!public! !
!

!MethodSourcePresenter class methodsFor!

publishedEventsOfInstances
    
    	^super publishedEventsOfInstances
			add: #'needUser';
			add: #'savedMethod:inClass:';
			yourself.
! !

!MethodSourcePresenter class categoriesForMethods!
publishedEventsOfInstances!public! !
!

