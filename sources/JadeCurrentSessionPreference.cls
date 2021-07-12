"Filed out from Dolphin Smallalk"!

JadePreferenceObject subclass: #JadeCurrentSessionPreference
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeCurrentSessionPreference guid: (GUID fromString: '{3fc7627f-1c65-46e7-86d3-cdff3b99d401}')!
JadeCurrentSessionPreference comment: ''!
!JadeCurrentSessionPreference categoriesForClass!Unclassified! !
!JadeCurrentSessionPreference methodsFor!

codeFont
	^CodeSourcePresenter codeFont!

codeFont: aFont
	CodeSourcePresenter codeFont: aFont!

debug
	^JadeLog debugFlag!

debug: aBoolean
	^JadeLog debug: aBoolean!

defaultFont
	^View desktop font!

defaultFont: aFont
	(View desktop font = aFont) ifFalse: [
		View desktop font: aFont
	].!

displayString
	^'Current Session'!

icon
	^Icon fromId: 'SMALLTALKOPTIONSFOLDER.ICO'!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects
		add: (Aspect font: #defaultFont);
		add: (Aspect font: #codeFont);
		add: (Aspect boolean: #debug).
	^aspects! !
!JadeCurrentSessionPreference categoriesForMethods!
codeFont!public! !
codeFont:!public! !
debug!public! !
debug:!public! !
defaultFont!public! !
defaultFont:!public! !
displayString!public! !
icon!public! !
publishedAspects!public! !
!

!JadeCurrentSessionPreference class methodsFor!

icon
	^Icon fromId: 'SMALLTALKOPTIONSFOLDER.ICO'! !
!JadeCurrentSessionPreference class categoriesForMethods!
icon!public! !
!

