"Filed out from Dolphin Smalltalk"!

MCPatchOperation subclass: #MCAddition
	instanceVariableNames: 'definition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MCAddition guid: (GUID fromString: '{b78cb54f-d86c-4398-a734-2c5cfa934104}')!
MCAddition comment: ''!
!MCAddition categoriesForClass!Unclassified! !
!MCAddition methodsFor!

className

	^definition className.
!

definition
	^definition!

definition: anObject
	definition := anObject!

detailsString

	^definition detailsString.
!

initialize: aStream

	definition := MCDefinition fromStream: aStream.
!

modificationMemo

	^definition displayMemo.
!

modificationSource
	^self modificationMemo!

modificationText

	^definition displayText.
!

obsoletionSource
	"There is no source in the previous version"

	^''
!

selector

	^definition selector.
! !
!MCAddition categoriesForMethods!
className!public! !
definition!public! !
definition:!public! !
detailsString!public! !
initialize:!public! !
modificationMemo!public! !
modificationSource!public! !
modificationText!public! !
obsoletionSource!public! !
selector!public! !
!

