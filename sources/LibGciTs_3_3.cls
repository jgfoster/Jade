﻿"Filed out from Dolphin Smalltalk"!

GciThreadSafeLibrary subclass: #LibGciTs_3_3
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LibGciTs_3_3 guid: (GUID fromString: '{2312615d-0e2e-4e4e-8334-b0b5e5586e53}')!

LibGciTs_3_3 comment: ''!

!LibGciTs_3_3 categoriesForClass!Unclassified! !

!LibGciTs_3_3 methodsFor!

errorStructureClass

	^GciErrSType64_31.
!

gciErr: errorReport

	<cdecl: bool GciErr GciErrSType64_31*>
	^self invalidCall: _failureCode
! !

!LibGciTs_3_3 categoriesForMethods!
errorStructureClass!private! !
gciErr:!private! !
!

!LibGciTs_3_3 class methodsFor!

displayName

	'64-bit 3.3.0 (TS)'.
	^nil
!

fileNameSearch

	^'libgcits-3.3.0-32.dll'.
! !

!LibGciTs_3_3 class categoriesForMethods!
displayName!public! !
fileNameSearch!public! !
!

