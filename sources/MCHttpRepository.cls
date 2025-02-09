﻿"Filed out from Dolphin Smalltalk"!

MCFileBasedRepository subclass: #MCHttpRepository
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MCHttpRepository guid: (GUID fromString: '{140baba7-58f1-4dc6-96f5-510365c3df9c}')!

MCHttpRepository comment: ''!

!MCHttpRepository categoriesForClass!Unclassified! !

!MCHttpRepository methodsFor!

storeVersion: anMCWorkingCopy name: nameString message: messageString from: aMCVersionDialog

	self 
		user: aMCVersionDialog httpUser
		password: aMCVersionDialog httpPassword.
	gciSession
		serverPerform: #'mcStore:name:message:repository:'
		with: anMCWorkingCopy
		with: (gciSession encode: nameString) 
		with: (gciSession encode: messageString) 
		with: self.
!

updateVersionDialogTabIn: aMCVersionDialog

	aMCVersionDialog updateHttpTabWith: self.
!

user: userString password: passwordString

	gciSession
		serverPerform: #'mcHttpRepository:user:password:'
		with: self
		with: (gciSession encode: userString) 
		with: (gciSession encode: passwordString).
!

userAndPassword

	^gciSession
		serverPerform: #'mcUserAndPasswordInHTTP:' 
		with: self.
! !

!MCHttpRepository categoriesForMethods!
storeVersion:name:message:from:!public! !
updateVersionDialogTabIn:!public! !
user:password:!public! !
userAndPassword!public! !
!

