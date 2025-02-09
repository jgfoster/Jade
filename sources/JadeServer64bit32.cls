﻿"Filed out from Dolphin Smalltalk"!

JadeServer64bit3x subclass: #JadeServer64bit32
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

JadeServer64bit32 guid: (GUID fromString: '{b2cb5f19-4347-4b6e-922e-705e99f7cb99}')!

JadeServer64bit32 comment: ''!

!JadeServer64bit32 categoriesForClass!Unclassified! !

!JadeServer64bit32 methodsFor!

_gsPackagePolicy

	| class |
	class := self _gsPackagePolicyClass.
	class isNil ifTrue: [^nil].
	class enabled ifFalse: [^nil].
	^class current
!

_setSessionState
	"Avoid deprecated method and still use 'Topaz session state' (since we know Topaz isn't running!!)"

	System __sessionStateAt: 3 put: self.
! !

!JadeServer64bit32 categoriesForMethods!
_gsPackagePolicy!private! !
_setSessionState!public! !
!

!JadeServer64bit32 class methodsFor!

gsClassDefinitionStringFor: aClass
	"Some class variables exist only in Dolphin and map to globals in GemStone; others exist only in GemStone and map to globals in Dolphin!!"

	^'class subclass: ''' , aClass name , '''
		instVarNames: ' , aClass instVarNames printString , '
		classVars: #(' , aClass classVarsForGemStone , ')
		classInstVars: #()
		poolDictionaries: (#() class withAll: symbolList)
		inDictionary: SymbolDictionary new.'
!

sessionStateCode
	"Avoid deprecated method and still use 'Topaz session state' (since we know Topaz isn't running!!)"

	^'System __sessionStateAt: 3 put: server.'! !

!JadeServer64bit32 class categoriesForMethods!
gsClassDefinitionStringFor:!public! !
sessionStateCode!public! !
!

