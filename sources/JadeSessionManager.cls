"Filed out from Dolphin Smallalk"!

RuntimeSessionManager subclass: #JadeSessionManager
	instanceVariableNames: ''
	classVariableNames: 'Version'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeSessionManager guid: (GUID fromString: '{8d7a4642-b8e1-43ea-94d5-e13390ca1f79}')!
JadeSessionManager comment: ''!
!JadeSessionManager categoriesForClass!Unclassified! !
!JadeSessionManager methodsFor!

defaultResLibPath
	"Answer the path of the development resource library."

	^'bin\Jade'!

main
"
	JadeSessionManager basicNew main.
"
	Keyboard default isShiftDown 
		ifTrue: [self mainShellClass show: 'Compact view']
		ifFalse: [self mainShellClass show].
!

pause

	Keyboard default isShiftDown ifTrue: [self error: 'Generate walkback!!'].
!

version

	^Version notNil 
		ifTrue: [Version]
		ifFalse: ['(Development)'].
!

windowSystemStartup

	ScintillaLibrary open: 'bin\SciLexer.dll'.		"Since this isn't adjacent to the executable, it needs a path to find it"
	super windowSystemStartup.
! !
!JadeSessionManager categoriesForMethods!
defaultResLibPath!public! !
main!public! !
pause!public! !
version!public! !
windowSystemStartup!public! !
!

!JadeSessionManager class methodsFor!

getVersion
"
	JadeSessionManager getVersion.
"
	| string1 string2 |
	File workingDirectory: SessionManager current imageBase.
	string1 := [self gitDescribe: '.'] on: ExternalProcessExecuteError do: [:ex | ex return: '???'].
	string2 := [self gitDescribe: '..'] on: ExternalProcessExecuteError do: [:ex | ex return: '???'].
	^(ReadStream on: string1) nextLine , ' (Dolphin ' , (ReadStream on: string2) nextLine , ')'
!

gitDescribe: directoryString

	| outputPipe process |
	process := ExternalProcess new.
	process directory: directoryString.
	process commandLine: 'git describe'.
	outputPipe := process stdoutPipe.
	process executeSync.
	[process isTerminated] whileFalse: [].
	^outputPipe readStream contents
!

mainShellClass

	^JadeLoginShell.
!

setVersion

	Version := self getVersion.!

version

	^Version notNil 
		ifTrue: [Version]
		ifFalse: ['Development'].
! !
!JadeSessionManager class categoriesForMethods!
getVersion!public! !
gitDescribe:!public! !
mainShellClass!public! !
setVersion!public! !
version!public! !
!

