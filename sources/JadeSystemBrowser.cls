"Filed out from Dolphin Smalltalk"!

JadeShell subclass: #JadeSystemBrowser
	instanceVariableNames: 'cardsPresenter roundTripCount'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

JadeSystemBrowser guid: (GUID fromString: '{72210941-97b6-4113-8ec8-e23015415de6}')!

JadeSystemBrowser comment: ''!

!JadeSystemBrowser categoriesForClass!Unclassified! !

!JadeSystemBrowser methodsFor!

abortTransaction

	self isOkayToChange ifTrue: [
		gciSession abort.
		self update.
	].
!

addSystemBrowser

	self addSystemBrowserWithLayoutInfo: (self currentCard ifNotNil: [:currentCard | currentCard layoutInfo]).
!

addSystemBrowserForClass: anArray

	(JadeAutoSystemBrowserPresenter
		createIn: cardsPresenter 
		gciSession: gciSession)
		updateAfterFindClass: anArray
		isMeta: nil 
		selector: ''.
!

addSystemBrowserWithLayoutInfo: each

	JadeLog log: 'JadeSystemBrowserPresenter>>addSystemBrowserWithLayoutInfo:'.
	(JadeAutoSystemBrowserPresenter
		createIn: cardsPresenter 
		gciSession: gciSession)
		layoutInfo: each.
!

addWorkspace

	JadeWorkspace showOnSession: gciSession.
!

closeCard

	cardsPresenter view removeSubView: self currentCard view.!

closeRequested: anAssociation

	anAssociation value ifTrue: [
		self isOkayToChange ifTrue: [
			[self saveLayoutAndContents] on: Error do: [:ex | ex return].
		] ifFalse: [
			anAssociation value: false.
		].
	].
!

commitTransaction

	gciSession commit ifTrue: [
		Sound informationBeep.
		self update.
	] ifFalse: [
		MessageBox warning: 'Commit failed!!'.
	].
!

createComponents

	super createComponents.
	cardsPresenter := self add: Presenter new name: 'cardContainer'.
!

createSchematicWiring

	| toolbar |
	super createSchematicWiring.
	toolbar := self view viewNamed: 'leftToolbar'.
	cardsPresenter view 	when: #'currentCardChanged' 	send: #'update' 			to: self.
	self  				when: #'closeRequested:'		send: #'closeRequested:'	to: self.
	self  view 			when: #'viewActivated'		send: #'update'			to: self.
	toolbar			when: #dropDown: 			send: #onDropDown: 		to: self.!

currentCard

	^cardsPresenter view currentCard ifNotNil: [:cardView | cardView presenter].
!

handleInvalidSession

	| hadDialog |
	hadDialog := false.
	cardsPresenter view cards do: [:each | 
		(each presenter isKindOf: JadeSystemBrowserPresenter) ifTrue: [
			hadDialog := each presenter handleInvalidSession or: [hadDialog].
		].
	].
	hadDialog ifFalse: [
		MessageBox
			warning: 'All windows for this session will close due to unexpected logout.'
			caption: 'Invalid session!!'.
	].
	gciSession forceLogout.
!

initialize

	super initialize.
	roundTripCount := 0.!

isOkayToChange

	cardsPresenter view cards do: [:each | 
		each presenter isOkayToChange ifFalse: [^false].
	].
	^true.
!

jadeBrowseTests

	JadeSUnitBrowser showOnSession: gciSession.

!

layoutFilePath

	^SessionManager current imageBase , 'Jade System Browser Layout.stb'!

logoutRequested: aValueHolder
	"Opportunity to save changes."

	self closeRequested: aValueHolder.
!

maximizeCode

	(self currentCard class == JadeAutoSystemBrowserPresenter) ifFalse: [^self].

	self currentCard bottomArrangement 
	ifNil: [
		self currentCard bottomArrangement: (self currentCard view viewNamed: 'textAreaTabs') arrangement.
		(self currentCard view viewNamed: 'textAreaTabs') arrangement: 100]
	ifNotNil: [:value | 
		(self currentCard view viewNamed: 'textAreaTabs') arrangement: self currentCard bottomArrangement.
		self currentCard bottomArrangement: nil].

	self currentCard view invalidate.!

moveCardLeft

	| cardView nextSibling |
	cardView := self currentCard view.
	nextSibling := cardView previousSiblingView.
	nextSibling notNil ifTrue: [nextSibling := nextSibling previousSiblingView].
	nextSibling notNil ifTrue: [cardView zOrderAfter: nextSibling] ifFalse: [cardView zOrderTop]!

moveCardRight

	| cardView nextSibling |
	cardView := self currentCard view.
	nextSibling := cardView nextSiblingView.
	nextSibling notNil ifTrue: [cardView zOrderAfter: nextSibling].
!

onDropDown: aToolbarButton 
	"Private - The receiver's toolbar has sent a notification that a button's drop-down arrow
	has been pressed. Generate and pop-up the appropriate menu."
	| popup |

	aToolbarButton command == #historyBack ifTrue: [popup :=  self currentCard historyBackMenu].
	aToolbarButton command == #historyForward ifTrue: [popup := self currentCard historyForwardMenu].
	popup queryAllFromView: self view.
	popup showIn: self position: aToolbarButton screenRectangle bottomLeft.

	^0!

onViewOpened

	super onViewOpened.
	cardsPresenter model: gciSession.
	self restoreLayoutAndContents.
!

queryCommand: aCommandQuery

	(#(#'closeCard' #'moveCardLeft' #'moveCardRight') includes: aCommandQuery command)  ifTrue: [
		aCommandQuery isEnabled: 1 < cardsPresenter view cards size. 
		^true.
	].
	^super queryCommand: aCommandQuery.

!

renameSelection

	MessageBox notify: 'Sorry, we are not yet prepared to handle this feature!!'.
	SessionManager current pause.
!

restoreLayoutAndContents

	self restoreLayoutAndContentsFromFile ifFalse: [
		self view position: 115 @ 70.
		self addSystemBrowserWithLayoutInfo: nil.
	].
!

restoreLayoutAndContentsFromFile

	| path file bytes data |
	path := self layoutFilePath.
	(File exists: path) ifFalse: [^false].
	[
		file := File 
			open: path
			mode: #read.
		bytes := ByteArray new: file size.
		file read: bytes; close.
		data := Object fromBinaryStoreBytes: bytes.
		(data at: 1) == 1 ifFalse: [self error: 'Wrong version!!!!'].
		(data at: 2) top < 0 ifTrue: [self error: 'Invalid position!!!!'].
		self view rectangle: (data at: 2).
		(data at: 3) do: [:each | 
			self addSystemBrowserWithLayoutInfo: each.
		].
		^true.
	] on: Error do: [:ex | 
		File delete: path. 
		^false
	].!

saveLayoutAndContents

	| data |
	data := OrderedCollection new
		add: 1;	"file version number"
		add: self view rectangle;
		add: (cardsPresenter view cards collect: [:each | each presenter layoutInfo]);
		yourself.
	(File 
		open: self layoutFilePath
		mode: #truncate 
		check: false)
		write: data binaryStoreBytes;
		close.
!

selectClass: classString selector: methodString

	JadeLog log: 'JadeSystemBrowser>>selectClass - ' , classString , ' selector: ' , methodString.
	self currentCard
		selectClass: classString 
		selector: methodString.
!

shellName

	^'System Browse'.
!

statusBarServerRequestText: aString

	roundTripCount := roundTripCount + 1.
	self statusBarText: 'Server request #' , roundTripCount printString , '; ' , aString.
!

statusBarText: aString

	(self view viewNamed: 'statusBarField') model: (ValueHolder with: aString).
!

update

	self currentCard ifNotNil: [:currentCard | currentCard onSetFocus].
! !

!JadeSystemBrowser categoriesForMethods!
abortTransaction!public! !
addSystemBrowser!public! !
addSystemBrowserForClass:!public! !
addSystemBrowserWithLayoutInfo:!public! !
addWorkspace!public! !
closeCard!public! !
closeRequested:!public! !
commitTransaction!public! !
createComponents!public! !
createSchematicWiring!history!public! !
currentCard!public! !
handleInvalidSession!public! !
initialize!public! !
isOkayToChange!public! !
jadeBrowseTests!public! !
layoutFilePath!public! !
logoutRequested:!public! !
maximizeCode!public! !
moveCardLeft!public! !
moveCardRight!public! !
onDropDown:!history!public! !
onViewOpened!public! !
queryCommand:!public! !
renameSelection!public! !
restoreLayoutAndContents!public! !
restoreLayoutAndContentsFromFile!public! !
saveLayoutAndContents!public! !
selectClass:selector:!public! !
shellName!overrides!private! !
statusBarServerRequestText:!public! !
statusBarText:!public! !
update!public! !
!

!JadeSystemBrowser class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 1801 1201 517 nil nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 8 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1409288972 131137 592 nil 480 nil 519 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 592 480 8 1893334752 170 192 8 #() nil nil nil 170 192 34 18 10473 1115718 2 ##(Smalltalk.ToolbarIconButton) 592 1 1180998 4 ##(Smalltalk.CommandDescription) #commitTransaction 8 'Commit Transaction' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Snapshot.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 10473 nil nil 10487 818 592 17 850 #historyForward 8 'History Forward' 1 1 898 nil true 944 8 'HistoryForward.ico' 992 10487 nil nil 10483 818 592 1 850 #jadeBrowseTests 8 'Open SUnit Browser' 1 1 898 nil true 944 8 'TestRunner.ico' 992 10483 nil nil 10479 818 592 1 850 #browseUsers 8 'Browse Users' 1 1 898 nil true 944 8 'MethodProtocol.ico' 992 10479 nil nil 10475 818 592 1 850 #addWorkspace 8 'Add Workspace' 1 1 898 nil true 944 8 'NewWorkspace.ico' 992 10475 nil nil 10471 818 592 1 850 #abortTransaction 8 'Abort Transaction' 1 1 898 nil true 944 8 'Panic.ico' 992 10471 nil nil 10485 818 592 17 850 #historyBack 8 'History Back' 1 1 898 nil true 944 8 'HistoryBack.ico' 992 10485 nil nil 10481 818 592 1 850 #maximizeCode 8 'Maximize Code' 1 1 898 nil true 944 8 'Shell.ico' 992 10481 nil nil 10477 818 592 1 850 #addSystemBrowser 8 'Add System Browser' 1 1 898 nil true 944 8 'SystemBrowserShell.ico' 992 10477 nil nil 34 13 1344 832 1049158 1 ##(Smalltalk.ToolbarSeparator) 592 1 1264 1584 1184 1682 592 1 1504 1682 592 1 1104 1682 592 1 1424 1024 nil nil 9 nil #smallIcons 498 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[255 255 255 255 0 0 0 0 36 3 0 0 25 0 0 0] 193 624 8 '' 592 3 8 #() 498 193 193 nil 31 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft -1 2082 #fixedParentRight -159 2082 #fixedParentTop 1 2082 #fixedViewTop 51 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1409288972 131137 2160 nil 480 nil 519 nil 658 nil true 690 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2160 480 8 1893334752 170 192 768 nil nil nil 170 192 34 6 10493 818 2160 1 850 #closeCard 8 'Close This Card' 1 1 788806 2 ##(Smalltalk.TextTileIcon) $✖ nil nil nil nil nil 1 nil nil 10493 nil nil 10491 818 2160 1 850 #moveCardRight 8 'Move Card Right' 1 1 2386 $▶ 8 'Cambria' nil 262406 ##(Smalltalk.ARGB) 8 4281833960 nil nil 1 nil nil 10491 nil nil 10489 818 2160 1 850 #moveCardLeft 8 'Move Card Left' 1 1 2386 $◀ 8 'Cambria' nil 2498 8 4281833704 nil nil 1 nil nil 10489 nil nil 34 4 1682 2160 1 2544 2416 2336 nil nil 9 nil #smallIcons 498 45 45 nil 1778 1 1 1 1810 138 144 34 1 1874 #createWindow: 34 1 1922 1954 8 #[36 3 0 0 0 0 0 0 116 3 0 0 25 0 0 0] 193 2192 8 '' 2160 3 8 #() 498 193 193 nil 31 2050 2112 -159 2082 #fixedViewLeft 161 2128 1 2144 51 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1409286412 1 2928 nil 480 nil 7 nil 658 nil true 690 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2928 nil 8 1892864976 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 2928 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 3122 #iconImageIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) 8 'statusBarField' nil nil nil 34 1 3104 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2928 nil nil 1810 138 144 34 1 1874 #createWindow: 34 1 1922 1954 8 #[0 0 0 0 7 2 0 0 116 3 0 0 29 2 0 0] 193 2960 8 '' 2928 3 8 #() 498 193 193 nil 29 2050 2096 1 2112 1 2082 #fixedParentBottom -43 3488 1 410 ##(Smalltalk.CardContainer) 34 16 nil 416 34 2 8 1409286144 131073 3504 nil 480 nil 1031 nil nil nil 3504 656710 1 ##(Smalltalk.CardLayout) 138 144 768 nil nil nil nil 170 192 768 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3504 34 2 8 1140916736 1 3632 590662 2 ##(Smalltalk.ListModel) 138 144 768 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 3632 nil 8 1893031264 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 ##(Smalltalk.ListControlView) #defaultGetTextBlock 575230339 8 #[30 105 226 0 106] #displayString 3808 7 257 nil nil 3216 nil nil nil nil nil #noIcons nil nil nil nil nil 1810 138 144 34 2 1874 #createWindow: 34 1 1922 1954 8 #[0 0 0 0 0 0 0 0 124 3 0 0 242 1 0 0] 193 3664 8 '' 3632 1874 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3632 3 8 #() 498 193 193 nil 27 1810 138 144 34 1 1874 #createWindow: 34 1 1922 1954 8 #[252 255 255 255 25 0 0 0 120 3 0 0 11 2 0 0] 193 3536 8 '' 3504 3 34 1 3632 498 193 193 nil 27 2050 2096 -7 2112 9 2128 51 3488 -35 170 192 34 8 592 8 'leftToolbar' 2160 8 'rightToolbar' 2928 8 'statusBar' 3504 8 'cardContainer' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 265030 4 ##(Smalltalk.Menu) nil true 34 1 984134 2 ##(Smalltalk.CommandMenuItem) 1 850 #close 8 'Exit' 1025 1 nil nil nil 8 'Jade' nil 134217729 nil nil 10497 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 1810 138 144 34 1 1874 #createWindow: 34 1 1922 590342 ##(Smalltalk.Rectangle) 498 5119 21 498 6919 1221 193 448 8 'Jade System Browser' 416 1 34 4 592 2160 3504 2928 498 193 193 nil 27 )! !

!JadeSystemBrowser class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

