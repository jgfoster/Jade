﻿"Filed out from Dolphin Smalltalk"!

GciErrSType subclass: #GciErrSType64
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_argCount _OffsetOf_args _OffsetOf_category _OffsetOf_context _OffsetOf_fatal _OffsetOf_message _OffsetOf_number'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GciErrSType64 guid: (GUID fromString: '{04defb15-dfdd-4009-acb0-548eb82e4aea}')!

GciErrSType64 addClassConstant: '_OffsetOf_argCount' value: 16r64!
GciErrSType64 addClassConstant: '_OffsetOf_args' value: 16r10!
GciErrSType64 addClassConstant: '_OffsetOf_category' value: 16r0!
GciErrSType64 addClassConstant: '_OffsetOf_context' value: 16r8!
GciErrSType64 addClassConstant: '_OffsetOf_fatal' value: 16r68!
GciErrSType64 addClassConstant: '_OffsetOf_message' value: 16r69!
GciErrSType64 addClassConstant: '_OffsetOf_number' value: 16r60!

GciErrSType64 comment: ''!

!GciErrSType64 categoriesForClass!Unclassified! !

!GciErrSType64 methodsFor!

argCount
	"Answer the receiver's argCount field as a Smalltalk object."

	^(bytes dwordAtOffset: 100)!

argCount: anObject
	"Set the receiver's argCount field to the value of anObject."

	bytes dwordAtOffset: 100 put: anObject!

args

	args ifNotNil: [^args].
	^OopType64Array fromAddress: (bytes yourAddress + 16) length: 10!

category
	"Answer the receiver's category field as a Smalltalk object."

	^(bytes qwordAtOffset: 0)!

category: anObject
	"Set the receiver's category field to the value of anObject."

	bytes qwordAtOffset: 0 put: anObject!

categoryOop

	^OopType64 fromInteger: self category.!

context
	"Answer the receiver's context field as a Smalltalk object."

	^(bytes qwordAtOffset: 8)!

context: anObject
	"Set the receiver's context field to the value of anObject."

	bytes qwordAtOffset: 8 put: anObject!

contextOop

	^OopType64 fromInteger: self context.
!

fatal
	"Answer the receiver's fatal field as a Smalltalk object."

	^(bytes byteAtOffset: 104)!

fatal: anObject
	"Set the receiver's fatal field to the value of anObject."

	bytes byteAtOffset: 104 put: anObject!

message
	"Answer the receiver's message field as a Smalltalk object."

	^AnsiString fromAddress: (bytes yourAddress + 105)!

message: anObject
	"Set the receiver's message field to the value of anObject."

	| size |
	size := anObject byteSize - 1 min: (1024 * 1).
	anObject replaceBytesOf: bytes from: 106 to: 105 + size startingAt: 1.
	bytes at: size+106 put: 0!

number
	"Answer the receiver's number field as a Smalltalk object."

	^(bytes dwordAtOffset: 96)!

number: anObject
	"Set the receiver's number field to the value of anObject."

	bytes dwordAtOffset: 96 put: anObject!

oopTypeClass

	^OopType64.
! !

!GciErrSType64 categoriesForMethods!
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

!GciErrSType64 class methodsFor!

defineFields
	"typedef struct {
		OopType			category;                      /* error dictionary       */
		OopType			context;  /* GemStone Smalltalk execution state , a GsProcess */
		OopType			args[GCI_MAX_ERR_ARGS];        /* arguments to error text */
		int				number;                        /* GemStone error number  */
		int				argCount;                      /* num of arg in the args[]*/
		unsigned char	fatal;                         /* nonzero if err is fatal */
		char			message[GCI_ERR_STR_SIZE + 1]; /* null-term. str of err text */
} GciErrSType;

		GciErrSType64 compileDefinition
	"

	| arrayField stringField |
	arrayField := ArrayField type: OopType64Array length: 10.
	stringField := StringField length: 1025.
	self
		defineField: #category 	type: OopType64Field 	new	;
		defineField: #context		type: OopType64Field	new	;
		defineField: #args			type: arrayField						;
		defineField: #number		type: DWORDField 		new	;
		defineField: #argCount	type: DWORDField		new	;
		defineField: #fatal			type: BYTEField			new	;
		defineField: #message	type: stringField						;
		yourself.
! !

!GciErrSType64 class categoriesForMethods!
defineFields!public! !
!

