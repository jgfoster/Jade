"Filed out from Dolphin Smalltalk"!

JadePreferenceObject subclass: #JadeRewriteToolPreference
	instanceVariableNames: 'formatterClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeRewriteToolPreference guid: (GUID fromString: '{adcf92c9-9cfe-4192-bd4d-8c9738029967}')!
JadeRewriteToolPreference comment: ''!
!JadeRewriteToolPreference categoriesForClass!Unclassified! !
!JadeRewriteToolPreference methodsFor!

displayString

	^'Rewrite Tool Options'!

formatterClass
	^formatterClass!

formatterClass: anObject
	formatterClass := anObject!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects
		add: (Aspect choice: #formatterClass from: (Array with: 'RBFormatter' with: 'RBConfigurableFormatter')).
	^aspects! !
!JadeRewriteToolPreference categoriesForMethods!
displayString!public! !
formatterClass!accessing!private! !
formatterClass:!accessing!private! !
publishedAspects!public! !
!

