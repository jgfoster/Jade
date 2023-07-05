"Filed out from Dolphin Smalltalk"!

Object subclass: #VWComponent
	instanceVariableNames: 'element name environment category package isPrivate sharedVariables'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VWComponent guid: (GUID fromString: '{408b2bd9-180c-481f-970b-1ea93ba60cdd}')!
VWComponent comment: ''!
!VWComponent categoriesForClass!Unclassified! !
!VWComponent methodsFor!

addSharedVar: nameString initializer: codeString

	sharedVariables 
		at: nameString 
		put: codeString.
!

category

	^category.
!

environment

	^environment.
!

initialize: anElement

	element := anElement.
	self 
		readCommon;
		readOther;
		yourself.
	element := nil.
!

initializerFor: anArray

	| stream period |
	stream := WriteStream on: String new.
	period := ''.
	anArray do: [:each | 
		stream 
			nextPutAll: period;
			nextPutAll: each;
			yourself.
		period := '.'.
	].
	stream
		nextPutAll: ' := ';
		nextPutAll: (sharedVariables at: anArray last);
		nextPut: $.;
		yourself.
	^stream contents.
!

name

	^name.
!

package

	^package.
!

printOn: aStream

	super printOn: aStream.
	aStream nextPutAll: ': ' , name.
!

readAttributes

	| attributes |
	attributes := element entityAt: #attributes.
	attributes entitiesDo: [:key :value | 
		key = #'package' ifTrue: [
			package := value elements first string.
		] ifFalse: [
			MessageBox notify: 'Sorry, we are not yet prepared to handle ' , key printString , ' (we only support the #package attribute)!!'.
			Keyboard default isShiftDown ifTrue: [self halt].
		].
	].
!

readCommon

	name 		:= (element entityAt: #name		) elements first string.
	environment 	:= (element entityAt: #environment 	) elements first string.
	category 		:= (element entityAt: #category 	) elements first string.
	isPrivate 		:= (element entityAt: #private		) elements first string = 'true'.
	sharedVariables := Dictionary new.
	self readAttributes.
! !
!VWComponent categoriesForMethods!
addSharedVar:initializer:!public! !
category!public! !
environment!public! !
initialize:!public! !
initializerFor:!public! !
name!public! !
package!public! !
printOn:!public! !
readAttributes!public! !
readCommon!public! !
!

!VWComponent class methodsFor!

from: anElement

	^self new
		initialize: anElement;
		yourself.
! !
!VWComponent class categoriesForMethods!
from:!public! !
!

