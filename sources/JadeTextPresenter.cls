"Filed out from Dolphin Smallalk"!

TextPresenter subclass: #JadeTextPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeTextPresenter guid: (GUID fromString: '{483a5019-ce38-4f6a-b12d-d39804fc00f4}')!
JadeTextPresenter comment: ''!
!JadeTextPresenter categoriesForClass!Unclassified! !
!JadeTextPresenter methodsFor!

onViewOpened

	super onViewOpened.
	(view isKindOf: ScintillaView) ifFalse: [^self].
	view textStyles: JadeTextStyles default textStyles.
!

selection

	^view selection.
! !
!JadeTextPresenter categoriesForMethods!
onViewOpened!public! !
selection!public! !
!

