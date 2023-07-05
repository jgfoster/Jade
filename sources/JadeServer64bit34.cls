"Filed out from Dolphin Smalltalk"!

JadeServer64bit33 subclass: #JadeServer64bit34
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeServer64bit34 guid: (GUID fromString: '{1fe2384e-a7cc-4e95-8b1e-52399b34f562}')!
JadeServer64bit34 comment: ''!
!JadeServer64bit34 categoriesForClass!Unclassified! !
!JadeServer64bit34 methodsFor!

_environmentSuperClassFor: aBehavior

	^aBehavior superclassForEnv: environment!

classOrganizer

	| org |
	^(org := classOrganizers at: environment + 1) notNil
		ifTrue: [org]
		ifFalse: [classOrganizers at: environment + 1 put: (ClassOrganizer newForEnvironment: environment)]
!

debugString: aString fromContext: anObject environment: anInteger
	"See String>>evaluateInContext:symbolList:"

	[
		^((self _decodeString: aString)
			_compileInContext: anObject 
			symbolList: self persistentSymbolList 
			oldLitVars: nil 
			environmentId: anInteger 
			flags: 0) 
			setBreakAtStepPoint: 1;
			_executeInContext: anObject
	] on: CompileWarning do: [:ex | 
		ex resume.
	].
!

executeString: aString fromContext: anObject environment: anInteger
	"See String>>evaluateInContext:symbolList:"

	[
		^((self _decodeString: aString)
			_compileInContext: anObject 
			symbolList: self persistentSymbolList 
			oldLitVars: nil 
			environmentId: anInteger 
			flags: 0)
			_executeInContext: anObject
	] on: CompileWarning do: [:ex | 
		ex resume.
	].
! !
!JadeServer64bit34 categoriesForMethods!
_environmentSuperClassFor:!private!System Browser! !
classOrganizer!private! !
debugString:fromContext:environment:!public! !
executeString:fromContext:environment:!public! !
!

