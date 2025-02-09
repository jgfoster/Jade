﻿"Filed out from Dolphin Smalltalk"!

GciErrSType subclass: #GciErrSType32
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_argCount _OffsetOf_args _OffsetOf_category _OffsetOf_context _OffsetOf_fatal _OffsetOf_message _OffsetOf_number'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GciErrSType32 guid: (GUID fromString: '{a4559093-6277-4975-a45b-6f8fa8285429}')!

GciErrSType32 addClassConstant: '_OffsetOf_argCount' value: 16r1C8!
GciErrSType32 addClassConstant: '_OffsetOf_args' value: 16r1A0!
GciErrSType32 addClassConstant: '_OffsetOf_category' value: 16r0!
GciErrSType32 addClassConstant: '_OffsetOf_context' value: 16r8!
GciErrSType32 addClassConstant: '_OffsetOf_fatal' value: 16r1CC!
GciErrSType32 addClassConstant: '_OffsetOf_message' value: 16rC!
GciErrSType32 addClassConstant: '_OffsetOf_number' value: 16r4!

GciErrSType32 comment: 'GciErrSType
	<C: typedef struct {
			OopType category;
			long number;
			OopType context;
			char message[401];
			OopType args[10];
			long argCount;
			BoolType fatal;
		} GciErrSType>'!

!GciErrSType32 categoriesForClass!Unclassified! !

!GciErrSType32 methodsFor!

argCount
	"Answer the receiver's argCount field as a Smalltalk object."

	^(bytes dwordAtOffset: 456)!

argCount: anObject
	"Set the receiver's argCount field to the value of anObject."

	bytes dwordAtOffset: 456 put: anObject!

args
	args ifNotNil: [^args].
	^OopType32Array fromAddress: (bytes yourAddress + 416) length: 10!

category
	"Answer the receiver's category field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

category: anObject
	"Set the receiver's category field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

categoryOop

	^OopType32 fromInteger: self category.
!

context
	"Answer the receiver's context field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

context: anObject
	"Set the receiver's context field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

contextOop

	^OopType32 fromInteger: self context.!

fatal
	"Answer the receiver's fatal field as a Smalltalk object."

	^(bytes dwordAtOffset: 460) asBoolean!

fatal: anObject
	"Set the receiver's fatal field to the value of anObject."

	bytes dwordAtOffset: 460 put: anObject asParameter!

message
	"Answer the receiver's message field as a Smalltalk object."

	^AnsiString fromAddress: (bytes yourAddress + 12)!

message: anObject
	"Set the receiver's message field to the value of anObject."

	| size |
	size := anObject byteSize - 1 min: (400 * 1).
	anObject replaceBytesOf: bytes from: 13 to: 12 + size startingAt: 1.
	bytes at: size+13 put: 0!

number
	"Answer the receiver's number field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

number: anObject
	"Set the receiver's number field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

oopTypeClass

	^OopType32.
! !

!GciErrSType32 categoriesForMethods!
argCount!**compiled accessors**!public! !
argCount:!public! !
args!**compiled accessors**!public! !
category!**compiled accessors**!public! !
category:!public! !
categoryOop!public! !
context!**compiled accessors**!public! !
context:!public! !
contextOop!public! !
fatal!**compiled accessors**!public! !
fatal:!public! !
message!**compiled accessors**!public! !
message:!public! !
number!**compiled accessors**!public! !
number:!public! !
oopTypeClass!public! !
!

!GciErrSType32 class methodsFor!

defineFields
	"	typedef struct {
			OopType category;
			long number;
			OopType context;
			char message[401];
			OopType args[10];
			long argCount;
			BoolType fatal;
		} GciErrSType;

		GciErrSType32 compileDefinition
	"

	| arrayField stringField |
	arrayField := ArrayField type: OopType32Array length: 10.
	stringField := StringField length: 401.
	self
		defineField: #category 	type: OopType32Field 	new	;
		defineField: #number		type: DWORDField 		new	;
		defineField: #context		type: OopType32Field	new	;
		defineField: #message	type: stringField						;
		defineField: #args			type: arrayField						;
		defineField: #argCount	type: DWORDField		new	;
		defineField: #fatal			type: BOOLField			new	;
		yourself.
! !

!GciErrSType32 class categoriesForMethods!
defineFields!public! !
!

