﻿"Filed out from Dolphin Smalltalk"!

GsObject subclass: #GsGlobal
	instanceVariableNames: 'gsClassName data'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GsGlobal guid: (GUID fromString: '{e6f20781-ff1e-4553-a0b9-5a06b141a564}')!

GsGlobal comment: ''!

!GsGlobal categoriesForClass!Unclassified! !

!GsGlobal methodsFor!

data

	^data.
!

gsClassName

	^gsClassName.
!

initialize: aList

	super initialize: aList.
	gsClassName := aList at: 3.
	data := aList at: 4.
! !

!GsGlobal categoriesForMethods!
data!public! !
gsClassName!public! !
initialize:!public! !
!

