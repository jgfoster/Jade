﻿"Filed out from Dolphin Smalltalk"!

JadePresenter subclass: #JadeRewriteMethodsList
	instanceVariableNames: 'methodsPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

JadeRewriteMethodsList guid: (GUID fromString: '{3fdc46ed-5f49-4a6d-b15e-cf6d2803e4b5}')!

JadeRewriteMethodsList comment: ''!

!JadeRewriteMethodsList categoriesForClass!Unclassified! !

!JadeRewriteMethodsList methodsFor!

createComponents

	super createComponents.

	methodsPresenter := self add: ListPresenter new name: 'methods'.!

createSchematicWiring

	super createSchematicWiring.

	methodsPresenter when: #selectionChanged send: #onSelectorChanged to: self!

initialize

	super initialize.!

model: aCollection

	super model: aCollection.

	methodsPresenter model: (ListModel on: aCollection)!

onSelectorChanged

	self subclassResponsibility!

removeFromList

	methodsPresenter hasSelection ifFalse: [^self].

	methodsPresenter model remove: methodsPresenter selection! !

!JadeRewriteMethodsList categoriesForMethods!
createComponents!public! !
createSchematicWiring!public! !
initialize!public! !
model:!public! !
onSelectorChanged!public! !
removeFromList!code actions!public! !
!

