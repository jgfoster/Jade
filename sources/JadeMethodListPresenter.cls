﻿"Filed out from Dolphin Smalltalk"!

JadeBrowserPresenter subclass: #JadeMethodListPresenter
	instanceVariableNames: 'methodListPresenter methodSourcePresenter searchBlock'
	classVariableNames: 'JadeMethodBrowserPresenterClass'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

JadeMethodListPresenter guid: (GUID fromString: '{bcf7edb6-114a-4e67-84d3-6fecd6c5ae0c}')!

JadeMethodListPresenter comment: ''!

!JadeMethodListPresenter categoriesForClass!Unclassified! !

!JadeMethodListPresenter methodsFor!

browse: performSelector gsMethod: aGsMethod

	| string |
	string := self gciSession 
		serverPerform: performSelector
		with: aGsMethod.
	self browseMethodsFromString: string.
!

browse: performSelector method: aGsMethodOrString

	| string |
	(aGsMethodOrString isKindOf: String) ifTrue: [
		self browse: performSelector methodSelector: aGsMethodOrString.
		string := aGsMethodOrString.
	] ifFalse: [
		self browse: performSelector gsMethod: aGsMethodOrString.
		string := aGsMethodOrString name.
	].
	self selecting: string.
!

browse: performSelector methodSelector: aString

	| string |
	string := self gciSession 
		serverPerform: performSelector
		with: aString.
	self browseMethodsFromString: string.
!

browseImplementorsOf: aGsMethod

	self
		browse: #'implementorsOf:' 
		method: aGsMethod.
!

browseMethods: aGsMethodColl

	| string |
	string := self gciSession 
		serverPerform: #streamOfMethods:
		with: aGsMethodColl.
	self browseMethodsFromString: string.
!

browseMethodsContaining: aString

	self
		browse: #'methodsContaining:' 
		method: aString.
!

browseMethodsFromString: aString

	| list |
	list := GsMethod2
		listFromString: aString
		session: self gciSession.
	methodListPresenter list: list asSortedCollection.
	list notEmpty ifTrue: [
		methodListPresenter selectFirstMethod.
	].
!

browseMethodsFromString: aString methodName: methodName
	| list |

	list := GsMethod2
		listFromString: aString
		session: self gciSession.
	methodListPresenter list: list asSortedCollection.
	list notEmpty ifTrue: [
		methodListPresenter selectFirstMethod.
	].!

browseMethodsFromString: aString methodName: methodName type: browseType
	| list |

	list := GsMethod2
		listFromString: aString
		session: self gciSession.
	methodListPresenter list: list asSortedCollection.
	list notEmpty ifTrue: [
		methodListPresenter selectFirstMethod.
	].!

browseSendersOf: aGsMethodOrString

	self
		browse: #'sendersOf:' 
		method: aGsMethodOrString.
!

codePresenterIsMethod

	^true!

createComponents

	super createComponents.
	methodListPresenter 	:= self add: MethodListPresenter	new name: 'methodList'.
	methodSourcePresenter	:= (self add: MethodSourcePresenter	new name: 'methodSource') menuTitle: '&Method Source'; yourself.
!

createSchematicWiring

	super createSchematicWiring.
	methodListPresenter
		when: #'methodSelectionChanged'	send: #'updateSource'		to: self;
		when: #'selectionChanging:'		send: #'selectionChanging:'	to: self;
		when: #'leftButtonPressed:'			send: #'onLeftButtonPressed:'	to: self;
		yourself.
	methodSourcePresenter
		when: #'needUser'				send: #'userSelection'		to: self;
		when: #'savedMethod:inClass:' 		send: #'doSearch'			to: self;
		yourself.
!

doSearch

	searchBlock notNil ifTrue: [searchBlock value].
!

gciSession: aGciSession

	super gciSession: aGciSession.
	methodListPresenter gciSession: aGciSession .
	methodSourcePresenter gciSession: aGciSession.
!

getSelectedMethod

	^methodListPresenter selectedMethod!

getSelectedMethodName

	^self getSelectedMethod name!

jadeMenuStrings

	^#(
		'&Jade'
		'&Abort Transaction//abortTransaction'
		'&CommitTransaction//commitTransaction'
		'-'
		'&New Worspace/Ctrl+N/newWorkspace'
		'&Open System Browser/Ctrl+B/openSystemBrowser'
		'-'
		'E&xit/Shift+F4/exit'
	).
!

methodListPresenter

	^methodListPresenter!

onLeftButtonPressed: aMouseEvent

	[self doSearch] forkAt: Processor userBackgroundPriority.
!

onViewOpened

	super onViewOpened.
	[methodSourcePresenter addMenu] forkAt: Processor userBackgroundPriority.
!

searchFor: aString

	| sourceView selectionRange textRange found |
	sourceView := methodSourcePresenter view viewNamed: 'document'.
	selectionRange := sourceView selectionRange.
	textRange := sourceView textRange.
	found := sourceView
		find: aString
		range: (selectionRange stop + 1 to: textRange stop)
		flags: 4 + 2. "SCFIND_MATCHCASE + SCFIND_WHOLEWORD"
	0 < found stop ifTrue: [
		sourceView
			selectionStart: found start 
			end: found stop.
		sourceView ensureVisible: found stop.
	].
!

selectedClass

	| gsMethod |
	(gsMethod := methodListPresenter selectionOrNil) isNil ifTrue: [^nil].
	^gsMethod gsClass.
!

selectFirstMethod

	methodListPresenter selectFirstMethod.
!

selecting: aString

	searchBlock := [self searchFor: aString].
	self doSearch.
!

updateMenuBar: aMenuBar

	| menu |
	menu := Menu fromStrings: self jadeMenuStrings.
	aMenuBar addItem: menu.
	methodListPresenter updateMenuBar: aMenuBar.
!

updateSaveMethodOop: anInteger

	| newGsMethod oopType |
 	methodListPresenter selectedMethod isNil ifTrue: [^self].
	(anInteger isKindOf: Integer) ifFalse: [self error: 'Expected an Integer, but got ' , anInteger printString].
	((oopType := gciSession oopTypeWithOop: anInteger) isKindOf: ExternalInteger) ifFalse: [self error: 'Expected an OopType but got ' , oopType printString]. 
	newGsMethod := methodListPresenter selectedMethod copy
		oopType: oopType;
		yourself.
	methodListPresenter primaryPresenter model add: newGsMethod.

 	methodListPresenter primaryPresenter model remove: methodListPresenter selectedMethod ifAbsent: [].

	methodSourcePresenter gsMethod: (GsMethod fromGsMethod2: newGsMethod). "fix #266"
	methodListPresenter primaryPresenter selection: newGsMethod.
	methodListPresenter primaryPresenter model list reSort. "to preserve the original order"!

updateSource
"
	Triggered by #methodSelectionChanged event.
"
	| gsMethod2 gsMethod |
	(gsMethod2 := methodListPresenter selectedMethod) ifNil: [
		methodSourcePresenter gsMethod: nil.
		^self.
	].
	gsMethod := GsMethod fromGsMethod2: gsMethod2.
	methodSourcePresenter gsMethod: gsMethod.
	self doSearch.
	methodSourcePresenter documentPresenter lastGsShape: (self registry getClass: methodListPresenter selectedMethod gsClass name).! !

!JadeMethodListPresenter categoriesForMethods!
browse:gsMethod:!public! !
browse:method:!public! !
browse:methodSelector:!public! !
browseImplementorsOf:!public! !
browseMethods:!public! !
browseMethodsContaining:!public! !
browseMethodsFromString:!public! !
browseMethodsFromString:methodName:!public! !
browseMethodsFromString:methodName:type:!public! !
browseSendersOf:!public! !
codePresenterIsMethod!public! !
createComponents!public! !
createSchematicWiring!public! !
doSearch!public! !
gciSession:!public! !
getSelectedMethod!public! !
getSelectedMethodName!public! !
jadeMenuStrings!public! !
methodListPresenter!public! !
onLeftButtonPressed:!public! !
onViewOpened!public! !
searchFor:!public! !
selectedClass!public! !
selectFirstMethod!public! !
selecting:!public! !
updateMenuBar:!public! !
updateSaveMethodOop:!public! !
updateSource!public! !
!

!JadeMethodListPresenter class methodsFor!

getJadeMethodBrowserPresenterClass

	JadeMethodBrowserPresenterClass ifNil: [JadeMethodBrowserPresenterClass := JadeMethodListPresenter].

	^JadeMethodBrowserPresenterClass!

getJadeShellViewName

	^(self getJadeMethodBrowserPresenterClass == JadeMethodListPresenter) 
	ifTrue: ['List view']
	ifFalse: ['Tree view']!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 0 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 560 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 560 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.MethodListPresenter)  8 #resource_MultiClass_view 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 882 1201 351 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 2 0 0 175 0 0 0] 98 0 882 193 193 0 27 9 410 576 98 14 0 416 98 2 8 1140850688 131073 1008 0 642 672 0 5 0 0 0 1008 690 8 ##(Smalltalk.MethodSourcePresenter)  8 #resource_Default_view 0 754 202 208 98 1 818 848 98 2 882 1 361 882 1201 441 1008 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 180 0 0 0 88 2 0 0 144 1 0 0] 976 992 0 27 11 16 234 256 98 4 560 8 'methodList' 1008 8 'methodSource' 0 754 202 208 98 1 818 848 98 2 882 2799 21 882 1201 801 416 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 207 7 0 0 154 1 0 0] 98 3 560 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 1504 0 642 8 4278190080 0 517 0 0 0 1504 754 202 208 98 1 818 848 98 2 882 1 351 882 1201 11 1504 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 175 0 0 0 88 2 0 0 180 0 0 0] 98 0 992 0 27 1008 992 0 27 )!

setJadeMethodBrowserPresenterClass: aJadeMethodListPresenterClass

	JadeMethodBrowserPresenterClass := aJadeMethodListPresenterClass!

setListView

	self setJadeMethodBrowserPresenterClass: JadeMethodListPresenter!

setTreeView

	self setJadeMethodBrowserPresenterClass: JadeTreeMethodListPresenter! !

!JadeMethodListPresenter class categoriesForMethods!
getJadeMethodBrowserPresenterClass!public! !
getJadeShellViewName!public! !
resource_Default_view!public!resources-views! !
setJadeMethodBrowserPresenterClass:!public! !
setListView!public! !
setTreeView!public! !
!

