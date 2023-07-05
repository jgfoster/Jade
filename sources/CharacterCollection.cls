"Filed out from Dolphin Smalltalk"!

ArrayedCollection variableSubclass: #CharacterCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CharacterCollection guid: (GUID fromString: '{4408ec10-3b63-4d56-a60f-56c628c34605}')!
CharacterCollection comment: ''!
!CharacterCollection categoriesForClass!Collections-Abstract! !
!CharacterCollection methodsFor!

asCharacterCollection

	^self!

asUtf16String

	| writeStream |
	writeStream := WriteStream on: Utf16String new.
	self do: [:each | writeStream nextPut: each].
	^writeStream contents!

asUtf8String

	| writeStream |
	writeStream := WriteStream on: Utf8String new.
	self do: [:each | writeStream nextPut: each].
	^writeStream contents! !
!CharacterCollection categoriesForMethods!
asCharacterCollection!public! !
asUtf16String!public! !
asUtf8String!public! !
!

