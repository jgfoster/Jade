"Filed out from Dolphin Smallalk"!

JadePreferenceObject subclass: #JadeAllSessionsPreference
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeAllSessionsPreference guid: (GUID fromString: '{546eb412-bc29-405c-b0f7-29f73e946fa4}')!
JadeAllSessionsPreference comment: ''!
!JadeAllSessionsPreference categoriesForClass!Unclassified! !
!JadeAllSessionsPreference methodsFor!

autoCommit

	^self gciSession isAutoCommit!

autoCommit: aBoolean
	self gciSession isAutoCommit: aBoolean!

autoMigrate
	^self gciSession isAutoMigrate!

autoMigrate: aBoolean

	^self gciSession isAutoMigrate: aBoolean!

displayString

	^'All Sessions'!

icon

	^Icon fromId: 'ListView.ico'!

isShowUnimplementedMessages
	^self gciSession isShowUnimplementedMessages!

isShowUnimplementedMessages: aBoolean
	self gciSession isShowUnimplementedMessages: aBoolean!

nativeCode
	^self gciSession isNativeCode!

nativeCode: aBoolean

	^self gciSession isNativeCode: aBoolean!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	self gciSession isNativeCode ifNotNil: [aspects add: (Aspect boolean: #nativeCode)].
	self gciSession isAutoCommit ifNotNil: [aspects add: (Aspect boolean: #autoCommit)].
	self gciSession isAutoMigrate ifNotNil: [aspects add: (Aspect boolean: #autoMigrate)].
	self gciSession isShowUnimplementedMessages ifNotNil: [aspects add: (Aspect boolean: #isShowUnimplementedMessages)].
	^aspects! !
!JadeAllSessionsPreference categoriesForMethods!
autoCommit!public! !
autoCommit:!public! !
autoMigrate!public! !
autoMigrate:!public! !
displayString!public! !
icon!public! !
isShowUnimplementedMessages!public! !
isShowUnimplementedMessages:!public! !
nativeCode!public! !
nativeCode:!public! !
publishedAspects!public! !
!

!JadeAllSessionsPreference class methodsFor!

icon

	^Icon fromId: 'ListView.ico'! !
!JadeAllSessionsPreference class categoriesForMethods!
icon!public! !
!

