"Filed out from Dolphin Smalltalk"!

JadeShell subclass: #ObjectLogBrowser
	instanceVariableNames: 'listPresenter fatalPresenter errorPresenter warningPresenter infoPresenter debugPresenter tracePresenter transcriptPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ObjectLogBrowser guid: (GUID fromString: '{d6406bca-c1b0-4a7b-81cf-66ac7ab28e63}')!

ObjectLogBrowser comment: ''!

!ObjectLogBrowser categoriesForClass!Unclassified! !

!ObjectLogBrowser methodsFor!

commit

	self 
		commitTransaction;
		update;
		yourself.
 !

commitTransaction

	gciSession commit ifTrue: [
		Sound informationBeep.
		self update.
	] ifFalse: [
		MessageBox warning: 'Commit failed!!'.
	].	self update.
!

createComponents

	super createComponents.
	listPresenter 				:= self add: ListPresenter 		new name: 'objectLog'.
	fatalPresenter 			:= self add: ValuePresenter 	new name: 'fatal'.
	errorPresenter 			:= self add: ValuePresenter 	new name: 'error'.
	warningPresenter 		:= self add: ValuePresenter	new name: 'warning'.
	infoPresenter 			:= self add: ValuePresenter 	new name: 'info'.
	debugPresenter 		:= self add: ValuePresenter 	new name: 'debug'.
	tracePresenter 			:= self add: ValuePresenter 	new name: 'trace'.
	transcriptPresenter 	:= self add: ValuePresenter 	new name: 'transcript'.
!

createSchematicWiring

	super createSchematicWiring.
	listPresenter	when: #'actionPerformed' send: #'open' to: self.!

debug: anArray

	| oopType |
	oopType := gciSession oopTypeWithOop: (anArray at: 9) asNumber.
	JadeDebugger 
		openOn: (GsProcess session: gciSession oopType: oopType) 
		message: (anArray at: 8)
		terminateOnClose: false.
!

delete

	| stream |
	stream := (WriteStream on: String new)
		nextPutAll: 'objectLog'; tab;
		nextPutAll: 'delete'; tab;
		yourself.
	listPresenter selections do: [:each | 
		stream nextPutAll: (each at: 1); tab.
	].
	stream lf; nextPutAll: self requestString.
	self updateA: stream contents.
!

onViewOpened

	super onViewOpened.
	fatalPresenter 			value: true.
	errorPresenter  		value: true.
	warningPresenter  	value: true.
	infoPresenter  			value: false.
	debugPresenter  		value: true.
	tracePresenter  		value: false.
	transcriptPresenter  	value: true.
	self update.
!

open

	listPresenter selections do: [:each | 
		(each at: 9) = '0' ifTrue: [
			self viewEntry: each.
		] ifFalse: [
			self debug: each.
		].
	].
!

queryCommand: aCommandQuery

	(aCommandQuery commandSymbol = #'debug') ifTrue: [
		aCommandQuery isEnabled: (listPresenter selections size = 1 and: [(listPresenter selection at: 2) = 'WAObjectLogEntry']).
		^true.
	].
	(aCommandQuery commandSymbol = #'delete') ifTrue: [
		aCommandQuery isEnabled: listPresenter hasSelection.
		^true.
	].
	^super queryCommand: aCommandQuery.
!

requestString 

	| stream |
	stream := (WriteStream on: String new)
		nextPutAll: 'objectLog'; tab;
		nextPutAll: 'list'; tab;
		yourself.
	fatalPresenter 			value ifTrue: [stream nextPut: $1].
	errorPresenter  		value ifTrue: [stream nextPut: $2].
	warningPresenter		value ifTrue: [stream nextPut: $3].
	infoPresenter  			value ifTrue: [stream nextPut: $4].
	debugPresenter  		value ifTrue: [stream nextPut: $5].
	tracePresenter  		value ifTrue: [stream nextPut: $6].
	transcriptPresenter  	value ifTrue: [stream nextPut: $7].
	stream tab.
	^stream contents.
!

shellName 

	^'Object Log'
!

statusBarText: aString

	(self view viewNamed: 'statusBarField') model: (ValueHolder with: aString).
!

update 

	self updateA: self requestString.
!

updateA: aString

	| time1 time2 time3 string stream |
	time1 := Time millisecondsToRun: [
		string := gciSession encode: '0 ' , aString.
		string := gciSession 
			serverPerform: #'systemBrowser:' 
			with: string.
		string := gciSession decode: string.
	].
	time2 := Time millisecondsToRun: [
		| x |
		stream := ReadStream on: string.
		time3 := stream nextLine asNumber.
		(x := stream nextLine) isEmpty ifTrue: [
			MessageBox notify: 'ObjectLogEntry class not found!!'.
			[
				self view close.
			] forkAt: Processor userBackgroundPriority.
			^self.
		].
		x = 'objectLog' ifFalse: [self error: 'unexpected response: ' , x printString].
		self updateB: stream.
	].

	self statusBarText:
		'Found ' , listPresenter list size printString , ' entries; ' , 
		'server took ' , time3 printString , 'ms; ' , 
		'network took ' , (time1 - time3) printString , 'ms; ' , 
		'client took ' , time2 printString , 'ms; ' , 
		'total of ' , (time1 + time2) printString , 'ms'.

!

updateB: stream
		"oop class pid stamp label priority tag object"
	| list |
	list := OrderedCollection new.
	[
		stream atEnd not.
	] whileTrue: [
		| array |
		array := (stream nextLine subStrings: Character tab) collect: [:each | each = 'nil' ifTrue: [''] ifFalse: [each]].
		array size < 8 ifTrue: [self error: 'Not enough data from the server!!'. array := array , #('' '' '' '' '' '' '' '' '')].
		list add: array.
	].
	listPresenter list: list.
!

viewEntry: anArray

	ObjectLogEntryViewer showOn: gciSession -> anArray.
! !

!ObjectLogBrowser categoriesForMethods!
commit!public! !
commitTransaction!public! !
createComponents!public! !
createSchematicWiring!public! !
debug:!public! !
delete!public! !
onViewOpened!public! !
open!public! !
queryCommand:!public! !
requestString!public! !
shellName!public! !
statusBarText:!public! !
update!public! !
updateA:!public! !
updateB:!public! !
viewEntry:!public! !
!

!ObjectLogBrowser class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 1601 1201 517 nil nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 22 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 592 nil nil nil 7 nil nil nil 592 nil 8 1894093872 1180998 4 ##(Smalltalk.CommandDescription) #update 8 'Update' 1 1 nil nil true nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[202 2 0 0 0 0 0 0 16 3 0 0 21 0 0 0] 193 624 8 'Update' 592 3 8 #() 498 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentRight -139 994 #fixedViewLeft 141 994 #fixedParentTop 1 994 #fixedViewTop 43 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1072 nil nil nil 7 nil nil nil 1072 nil 8 1894093872 674 #commit 8 'Commit' 1 1 nil nil false nil nil nil 722 138 144 34 2 786 #createWindow: 34 1 834 866 8 #[122 2 0 0 0 0 0 0 192 2 0 0 21 0 0 0] 193 1104 8 'Commit' 1072 786 #isEnabled: 8 #(false) 1072 3 8 #() 498 193 193 nil 29 962 1008 -299 1024 141 1040 1 1056 43 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1409363203 1 1408 721990 2 ##(Smalltalk.ValueHolder) nil false 1114118 ##(Smalltalk.NeverSearchPolicy) true nil nil 7 nil nil nil 1408 nil 8 1894093872 852486 ##(Smalltalk.NullConverter) nil nil nil 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[75 0 0 0 0 0 0 0 150 0 0 0 21 0 0 0] 193 1440 8 'Error' 1408 3 8 #() 498 193 193 nil 27 962 994 #fixedParentLeft 151 1024 151 1040 1 1056 43 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1409363203 1 1792 1474 nil false 1520 true nil nil 7 nil nil nil 1792 nil 8 1894093872 1554 nil nil nil 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[44 1 0 0 0 0 0 0 119 1 0 0 21 0 0 0] 193 1824 8 'Debug' 1792 3 8 #() 498 193 193 nil 27 962 1776 601 1024 151 1040 1 1056 43 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1409286412 1 2096 nil 480 nil 7 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2096 nil 8 1893716944 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 2096 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 2322 #iconImageIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) 8 'statusBarField' nil nil nil 34 1 2304 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2096 nil nil 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[0 0 0 0 7 2 0 0 16 3 0 0 29 2 0 0] 193 2128 8 '' 2096 3 8 #() 498 193 193 nil 29 962 1776 1 1008 1 994 #fixedParentBottom -43 1056 45 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1409363203 1 2704 1474 nil false 1520 true nil nil 7 nil nil nil 2704 nil 8 1894093872 1554 nil nil nil 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[150 0 0 0 0 0 0 0 225 0 0 0 21 0 0 0] 193 2736 8 'Warning' 2704 3 8 #() 498 193 193 nil 27 962 1776 301 1024 151 1040 1 1056 43 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1409363203 1 3008 1474 nil nil 1520 false nil nil 7 nil nil nil 3008 nil 8 1894093872 1554 nil nil nil 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[196 1 0 0 2 0 0 0 30 2 0 0 21 0 0 0] 193 3040 8 'Transcript' 3008 3 8 #() 498 193 193 nil 27 962 1776 905 1024 181 1040 5 1056 39 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1409355849 1025 3312 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 674 #delete 8 '&Delete' 1629 1 nil nil nil 3522 1 674 #open 8 'Debu&g' 9353 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3312 nil 8 1894143520 2322 #displayString 8 #() nil 2416 nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 1 83886081 3696 8 'doIt' 8 '[:each | each at: 2]' 8 #[29 105 17 64 148 106] 3712 7 257 nil nil nil nil nil 138 144 34 6 920646 5 ##(Smalltalk.ListViewColumn) 8 'Stamp' 351 #left 2322 #displayString 8 #() 2322 #<= 3904 3698 0 nil 3730 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each at: 4]' 8 #[29 105 17 214 4 148 106] 3936 7 257 nil nil 3312 nil 1 nil nil 3842 8 'PID' 101 #right 2322 #displayString 3904 2322 #<= 3904 3698 0 nil 3730 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each at: 3]' 8 #[29 105 17 214 3 148 106] 4080 7 257 nil nil 3312 nil 1 nil nil 3842 8 'Label' 241 #left 2322 #displayString 3904 2322 #<= 3904 3698 0 nil 3730 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each at: 5]' 8 #[29 105 17 214 5 148 106] 4224 7 257 nil nil 3312 nil 1 nil nil 3842 8 'Type' 161 #left 2322 #displayString 3904 2322 #<= 3904 3698 0 nil 3730 3 1 3696 8 'doIt' 8 '[:each | #(''fatal'' ''error'' ''warn'' ''info'' ''debug'' ''trace'' ''transcript'') at: (each at: 6) asNumber]' 8 #[31 105 29 17 214 6 148 159 148 106] 34 7 8 'fatal' 8 'error' 8 'warn' 8 'info' 8 'debug' 8 'trace' 8 'transcript' #asNumber 4368 7 257 nil nil 3312 nil 1 nil nil 3842 8 'Tag' 101 #left 2322 #displayString 3904 2322 #<= 3904 3698 0 nil 3730 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each at: 7]' 8 #[29 105 17 214 7 148 106] 4640 7 257 nil nil 3312 nil 1 nil nil 3842 8 'Object' 611 #left 2322 #displayString 3904 2322 #<= 3904 3698 0 nil 3730 1 83886081 3696 8 'doIt' 8 '[:each | each at: 8]' 8 #[29 105 17 214 8 148 106] 4784 7 257 nil nil 3312 nil 3 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 722 138 144 34 2 786 #createWindow: 34 1 834 866 8 #[0 0 0 0 22 0 0 0 16 3 0 0 7 2 0 0] 193 3344 8 'Stamp' 3312 786 #contextMenu: 34 1 3488 3312 3 8 #() 498 193 193 nil 35 962 1776 1 1008 1 1040 45 2688 -43 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1409363203 1 5104 1474 nil false 1520 false nil nil 7 nil nil nil 5104 nil 8 1894093872 1554 nil nil nil 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[225 0 0 0 0 0 0 0 44 1 0 0 21 0 0 0] 193 5136 8 'Info' 5104 3 8 #() 498 193 193 nil 27 962 1776 451 1024 151 1040 1 1056 43 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1409363203 1 5408 1474 nil nil 1520 false nil nil 7 nil nil nil 5408 nil 8 1894093872 1554 nil nil nil 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[119 1 0 0 0 0 0 0 194 1 0 0 21 0 0 0] 193 5440 8 'Trace' 5408 3 8 #() 498 193 193 nil 27 962 1776 751 1024 151 1040 1 1056 43 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1409363203 1 5712 1474 nil false 1520 true nil nil 7 nil nil nil 5712 nil 8 1894093872 1554 nil nil nil 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[5 0 0 0 0 0 0 0 75 0 0 0 21 0 0 0] 193 5744 8 'Fatal' 5712 3 8 #() 498 193 193 nil 27 962 1776 11 1024 141 1040 1 1056 43 170 192 34 18 1792 8 'debug' 1408 8 'error' 3008 8 'transcript' 3312 8 'objectLog' 2704 8 'warning' 2096 8 'statusBar' 5104 8 'info' 5712 8 'fatal' 5408 8 'trace' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 3474 nil true 34 2 3522 1 674 #delete 8 '&Delete' 1629 1 nil nil nil 3522 1 674 #debug 8 'Debu&g' 9353 1 nil nil nil 8 'Entry' nil 134217729 nil nil 16937 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 11999 nil nil nil nil 1 nil 193 722 138 144 34 1 786 #createWindow: 34 1 834 590342 ##(Smalltalk.Rectangle) 498 5119 21 498 6719 1221 193 448 8 'Object Log' 416 1 34 11 5712 1408 2704 5104 1792 5408 3008 1072 592 3312 2096 498 193 193 nil 27 )! !

!ObjectLogBrowser class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

