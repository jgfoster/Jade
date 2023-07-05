"Filed out from Dolphin Smalltalk"!

JadeImageStripper subclass: #ContactsImageStripper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ContactsImageStripper guid: (GUID fromString: '{9b58c50c-364b-4f25-b578-718999cb9c5b}')!
ContactsImageStripper comment: ''!
!ContactsImageStripper categoriesForClass!Unclassified! !
!ContactsImageStripper methodsFor!

closeLoginShells

	ContactsLoginShell allInstances do: [:each | each view close].
	super closeLoginShells.
!

requiredPackageNames

	^super requiredPackageNames
		add: 'Contacts Demo';
		add: 'Jade Login';
		yourself.
! !
!ContactsImageStripper categoriesForMethods!
closeLoginShells!public! !
requiredPackageNames!public! !
!

