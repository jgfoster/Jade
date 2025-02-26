﻿"Filed out from Dolphin Smalltalk"!

JadeWorkspace subclass: #GsProfStef
	instanceVariableNames: 'dictionaryName index tutorial'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'current'!

GsProfStef guid: (GUID fromString: '{494f1fe2-2494-4841-961a-12238584c390}')!

GsProfStef comment: ''!

!GsProfStef categoriesForClass!Unclassified! !

!GsProfStef methodsFor!

executeSelectionOrLine

	[
		^super executeSelectionOrLine
	] on: GsClientForwarderSend do: [:ex | 
		ex halt.
	].!

first
	index := 1.
	self updateLesson.
!

goto: anInteger
	anInteger <= tutorial size ifTrue: [index := anInteger].
	self updateLesson.
!

initialize

	super initialize.
	tutorial := GemStoneSyntaxTutorial new.
	index := 1.
!

lesson

	^tutorial lessonAt: index
!

next
	index < tutorial size ifTrue: [index := index + 1].
	self updateLesson.
!

onCloseRequested

	codePane isModified: false.
	self gciSession 
		serverPerform: #removeProfStef;
		commit;
		yourself.
	^super onCloseRequested!

onViewDestroyed

	self class clearCurrent.
	super onViewDestroyed.
!

onViewOpened

	super onViewOpened.
	self view extent: 700 @ 700.
	dictionaryName := gciSession serverPerform: #'addProfStef'.
	(dictionaryName isKindOf: String) ifFalse: [self error: 'Expected a String as the dictionary name, but got ' , dictionaryName printString].
	(gciSession indexOfClientForwarder: self class) == 3 	"This registers the object if it isn't present"
		ifFalse: [self error: 'GsProfStef should be the third client forwarder!!'].
	self updateLesson.
!

previous
	1 < index ifTrue: [index := index - 1].
	self updateLesson.
!

updateCaption

	self caption: self lesson title , ' (' , index printString , '/' , tutorial size printString , ')'.
!

updateLesson

	| string |
	string := self lesson contents
		copyReplaceAll: '<DICT>'
		with: dictionaryName.
	codePane isModified: false.
	codePane text: string.
	self updateCaption.
! !

!GsProfStef categoriesForMethods!
executeSelectionOrLine!public! !
first!public! !
goto:!public! !
initialize!public! !
lesson!public! !
next!public! !
onCloseRequested!public! !
onViewDestroyed!public! !
onViewOpened!public! !
previous!public! !
updateCaption!private!updating! !
updateLesson!public! !
!

!GsProfStef class methodsFor!

clearCurrent

	current := nil.
!

current

	1 == 1 ifFalse: [self previous].	"send this message to avoid having it stripped!!"
	1 == 1 ifFalse: [self goto: 1].	"send this message to avoid having it stripped!!"
	^current!

first
	"Move to the first lesson. We post to the input queue to avoid issues
	if the user has chosen to display a result - we don't want this
	inserted in our new contents."

	[self current first] postToInputQueue.
	^self current gciSession oopIllegal!

go
	self first.
	^true
!

goto: anInteger

	[self current goto: anInteger] postToInputQueue.
	^self current gciSession oopIllegal!

icon
	"Answers an Icon that can be used to represent this class."

	^##(TextTileIcon text: $\x1F393
		color: (Color
				r: 221
				g: 84
				b: 140))
		textcolor: Color white;
		yourself!

next
	"Move to the next lesson. We post to the input queue to avoid issues
	if the user has chosen to display a result - we don't want this
	inserted in our new contents."

	[self current next] postToInputQueue.
	^self current gciSession oopIllegal!

previous
	"Move to the previous lesson. We post to the input queue to avoid issues
	if the user has chosen to display a result - we don't want this
	inserted in our new contents."

	[self current previous] postToInputQueue.
	^self current gciSession oopIllegal!

showOnSession: aGciSession

	current ifNil: [
		current := super showOnSession: aGciSession.
	] ifNotNil: [
		current gciSession == aGciSession ifFalse: [
			MessageBox warning: 'Can have only one ProfStef open at a time!!'.
		] ifTrue: [
			current view activate.
			current first.
		].
	].! !

!GsProfStef class categoriesForMethods!
clearCurrent!public! !
current!public! !
first!navigation!public! !
go!navigation!public! !
goto:!navigation!public! !
icon!constants!public! !
next!navigation!public! !
previous!navigation!public! !
showOnSession:!public! !
!

