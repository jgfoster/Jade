﻿"Filed out from Dolphin Smalltalk"!

Shell subclass: #JadeShell
	instanceVariableNames: 'gciSession myPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

JadeShell guid: (GUID fromString: '{d1d000ee-0b26-4af9-8c27-396116cb864d}')!

JadeShell comment: ''!

!JadeShell categoriesForClass!Unclassified! !

!JadeShell methodsFor!

createComponents

	super createComponents.
	self presenterClass ifNotNil: [:class | myPresenter := self add: class new name: 'myPresenter'].
!

gciSession

	^gciSession!

gciSession: aGciSession

	gciSession := aGciSession.
	myPresenter notNil ifTrue: [myPresenter gciSession: aGciSession].
	gciSession
		when: #'logoutRequested:'	send: #'logoutRequested:'	to: self;
		when: #'logoutPending'	send: #'exit'			to: self;
		yourself.
!

logoutRequested: aValueHolder
	"Private - Opportunity to save changes."

	aValueHolder value: true.
!

onViewClosed

	gciSession notNil ifTrue: [
		| temp |
		temp := gciSession.
		gciSession := nil.
		temp removeEventsTriggeredFor: self.
	].
	super onViewClosed.
!

onViewOpened
	"If we have a presenter that is responsible for the entire window, then let it set up the MenuBar"

	super onViewOpened.
	[
		| menuBar |
		menuBar := self view menuBar.
		menuBar isNil ifTrue: [menuBar := MenuBar new].
		myPresenter notNil ifTrue: [myPresenter updateMenuBar: menuBar].
		self view menuBar: menuBar.
	] on: Error do: [:ex | 
		SessionManager current logError: ex.
		MessageBox
			notify: ex description 
			caption: 'Unable to Open ' , self class name.
		SessionManager current pause.
		self view close.
	].

!

presenterClass

	^nil.
!

primaryPresenter

	^myPresenter!

shellName

	^'Jade Shell'.
!

updateCaption

	self caption: (gciSession titleBarFor: self shellName).
! !

!JadeShell categoriesForMethods!
createComponents!private! !
gciSession!private! !
gciSession:!private! !
logoutRequested:!private! !
onViewClosed!private! !
onViewOpened!private! !
presenterClass!overrides!private! !
primaryPresenter!public! !
shellName!overrides!private! !
updateCaption!overrides!private! !
!

!JadeShell class methodsFor!

icon

	^Icon fromFile: 'icons\GS32.ico'.
!

showOnSession: aGciSession

	aGciSession hasServer ifFalse: [
		MessageBox
			warning: 'Server initialization failed at login.'
			caption: 'Unable to Open Browser'.
	].
	^self new 
		gciSession: aGciSession;
		createView: self defaultView;
		showShell;
		yourself.
! !

!JadeShell class categoriesForMethods!
icon!public! !
showOnSession:!public! !
!

