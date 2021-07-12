"Filed out from Dolphin Smallalk"!

TwinLevelInspector subclass: #JadeTwinLevelInspector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeTwinLevelInspector guid: (GUID fromString: '{558eb5e8-7993-43e2-b4e3-19bf52deb555}')!
JadeTwinLevelInspector comment: ''!
!JadeTwinLevelInspector categoriesForClass!Unclassified! !
!JadeTwinLevelInspector methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	contentsPresenter := self add: ListPresenter new name: 'contents'.
	inspectorPresenter := self add: JadePropertyInspector new name: 'inspector'.
	inspectorPresenter
		isRootAspectVisible: false;
		isSingleLevelOnly: true!

openCustomPopUpFor: aSymbol ifNone: aNiladicValuable 

	self selectionOrNil ifNil: [^self].

	self selectionOrNil openCustomPopUpFor: aSymbol ifNone: aNiladicValuable ! !
!JadeTwinLevelInspector categoriesForMethods!
createComponents!private! !
openCustomPopUpFor:ifNone:!public! !
!

