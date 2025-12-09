"Filed out from Dolphin Smalltalk"!

JadeShell subclass: #JadeMethodListBrowser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

JadeMethodListBrowser guid: (GUID fromString: '{046cebd5-f142-4382-99ff-b3fd8b8032b9}')!

JadeMethodListBrowser comment: ''!

!JadeMethodListBrowser categoriesForClass!Unclassified! !

!JadeMethodListBrowser methodsFor!

defaultPresenterName

	^JadeMethodListPresenter getJadeShellViewName
!

presenterClass

	 "^JadeMethodListPresenter."

	"^JadeTreeMethodListPresenter."

	^JadeMethodListPresenter getJadeMethodBrowserPresenterClass
!

shellName

	^'Method List Browser'.
!

statusBarText: aString

	(self view viewNamed: 'statusBarField') model: (ValueHolder with: aString).
!

switchToListView

	JadeMethodListPresenter setListView.

	self view destroy.!

switchToTreeView

	JadeMethodListPresenter setTreeView.

	self view destroy.
! !

!JadeMethodListBrowser categoriesForMethods!
defaultPresenterName!public! !
presenterClass!overrides!private! !
shellName!overrides!private! !
statusBarText:!private! !
switchToListView!public! !
switchToTreeView!public! !
!

!JadeMethodListBrowser class methodsFor!

resource_List_view
	"Answer the literal data from which the 'List view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_List_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 1201 801 517 nil nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 592 nil 480 nil 7 nil nil nil 592 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.JadeMethodListPresenter) #resource_Default_view nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 72 2 0 0 83 1 0 0] 193 624 8 '' 592 3 8 #() 498 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 962 #fixedParentRight 1 962 #fixedParentTop 1 962 #fixedParentBottom -43 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1409286412 1 1040 nil 480 nil 7 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1040 nil 8 1893716944 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 1040 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 1266 #iconImageIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) 8 'statusBarField' nil nil nil 34 1 1248 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 1040 nil nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[0 0 0 0 83 1 0 0 72 2 0 0 105 1 0 0] 193 1072 8 '' 1040 3 8 #() 498 193 193 nil 29 930 976 1 992 1 1024 -43 962 #fixedViewTop 45 170 192 34 2 1040 8 'statusBar' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 690 138 144 34 1 754 #createWindow: 34 1 802 590342 ##(Smalltalk.Rectangle) 498 5119 21 498 6319 821 193 448 8 'Jade Method List Browser' 416 1 34 2 592 1040 498 193 193 nil 27 )!

resource_Tree_view
	"Answer the literal data from which the 'Tree view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Tree_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 1201 801 517 nil nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 592 nil 480 nil 7 nil nil nil 592 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.JadeTreeMethodListPresenter) #resource_Default_view nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 72 2 0 0 83 1 0 0] 193 624 8 '' 592 3 8 #() 498 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 962 #fixedParentRight 1 962 #fixedParentTop 1 962 #fixedParentBottom -43 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1409286412 1 1040 nil 480 nil 7 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1040 nil 8 1893716944 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 1040 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 1266 #iconImageIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) 8 'statusBarField' nil nil nil 34 1 1248 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 1040 nil nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[0 0 0 0 83 1 0 0 72 2 0 0 105 1 0 0] 193 1072 8 '' 1040 3 8 #() 498 193 193 nil 29 930 976 1 992 1 1024 -43 962 #fixedViewTop 45 170 192 34 2 1040 8 'statusBar' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 690 138 144 34 1 754 #createWindow: 34 1 802 590342 ##(Smalltalk.Rectangle) 498 5119 21 498 6319 821 193 448 8 'Jade Method List Browser' 416 1 34 2 592 1040 498 193 193 nil 27 )!

showOnSession: aGciSession

	aGciSession hasServer ifFalse: [
		MessageBox
			warning: 'Server initialization failed at login.'
			caption: 'Unable to Open Browser'.
	].
	^self new 
		gciSession: aGciSession;
		createView: JadeMethodListPresenter getJadeShellViewName;
		showShell;
		yourself.
! !

!JadeMethodListBrowser class categoriesForMethods!
resource_List_view!public!resources-views! !
resource_Tree_view!public!resources-views! !
showOnSession:!public! !
!

