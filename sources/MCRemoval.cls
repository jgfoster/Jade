﻿"Filed out from Dolphin Smalltalk"!

MCPatchOperation subclass: #MCRemoval
	instanceVariableNames: 'definition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MCRemoval guid: (GUID fromString: '{ba962c07-8639-4e40-89aa-6ce4eb10ab50}')!

MCRemoval comment: ''!

!MCRemoval categoriesForClass!Unclassified! !

!MCRemoval methodsFor!

className

	^definition className.
!

detailsString

	^definition detailsString.
!

initialize: aStream

	definition := MCDefinition fromStream: aStream.
!

modificationSource
	"There is no source in the current version"

	^''!

obsoletionMemo

	^definition displayMemo.
!

obsoletionSource

	^definition source!

obsoletionText

	^definition displayText.
!

selector

	^definition selector.
! !

!MCRemoval categoriesForMethods!
className!public! !
detailsString!public! !
initialize:!public! !
modificationSource!public! !
obsoletionMemo!public! !
obsoletionSource!public! !
obsoletionText!public! !
selector!public! !
!

