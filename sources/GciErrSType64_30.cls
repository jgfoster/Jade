﻿"Filed out from Dolphin Smalltalk"!

GciErrSType subclass: #GciErrSType64_30
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_argCount _OffsetOf_args _OffsetOf_category _OffsetOf_context _OffsetOf_exceptionObj _OffsetOf_fatal _OffsetOf_message _OffsetOf_number _OffsetOf_reason'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GciErrSType64_30 guid: (GUID fromString: '{2cff1edf-058d-44c9-a9ab-9a6e7bf669f1}')!

GciErrSType64_30 addClassConstant: '_OffsetOf_argCount' value: 16r6C!
GciErrSType64_30 addClassConstant: '_OffsetOf_args' value: 16r18!
GciErrSType64_30 addClassConstant: '_OffsetOf_category' value: 16r0!
GciErrSType64_30 addClassConstant: '_OffsetOf_context' value: 16r8!
GciErrSType64_30 addClassConstant: '_OffsetOf_exceptionObj' value: 16r10!
GciErrSType64_30 addClassConstant: '_OffsetOf_fatal' value: 16r70!
GciErrSType64_30 addClassConstant: '_OffsetOf_message' value: 16r71!
GciErrSType64_30 addClassConstant: '_OffsetOf_number' value: 16r68!
GciErrSType64_30 addClassConstant: '_OffsetOf_reason' value: 16r472!

GciErrSType64_30 comment: ''!

!GciErrSType64_30 categoriesForClass!Unclassified! !

!GciErrSType64_30 methodsFor!

argCount
	"Answer the receiver's argCount field as a Smalltalk object."

	^(bytes dwordAtOffset: 108)!

argCount: anObject
	"Set the receiver's argCount field to the value of anObject."

	bytes dwordAtOffset: 108 put: anObject!

args

	args ifNotNil: [^args].
	^OopType64Array fromAddress: (bytes yourAddress + 24) length: 10!

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

exceptionObj
	"Answer the receiver's exceptionObj field as a Smalltalk object."

	^(bytes qwordAtOffset: 16)!

exceptionObj: anObject
	"Set the receiver's exceptionObj field to the value of anObject."

	bytes qwordAtOffset: 16 put: anObject!

exceptionObjOop

	^OopType64 fromInteger: self exceptionObj.!

fatal
	"Answer the receiver's fatal field as a Smalltalk object."

	^(bytes byteAtOffset: 112)!

fatal: anObject
	"Set the receiver's fatal field to the value of anObject."

	bytes byteAtOffset: 112 put: anObject!

message
	"Answer the receiver's message field as a Smalltalk object."

	^AnsiString fromAddress: (bytes yourAddress + 113)!

message: anObject
	"Set the receiver's message field to the value of anObject."

	| size |
	size := anObject byteSize - 1 min: (1024 * 1).
	anObject replaceBytesOf: bytes from: 114 to: 113 + size startingAt: 1.
	bytes at: size+114 put: 0!

number
	"Answer the receiver's number field as a Smalltalk object."

	^(bytes dwordAtOffset: 104)!

number: anObject
	"Set the receiver's number field to the value of anObject."

	bytes dwordAtOffset: 104 put: anObject!

oopTypeClass

	^OopType64.
!

reason
	"Answer the receiver's reason field as a Smalltalk object."

	^AnsiString fromAddress: (bytes yourAddress + 1138)!

reason: anObject
	"Set the receiver's reason field to the value of anObject."

	| size |
	size := anObject byteSize - 1 min: (63 * 1).
	anObject replaceBytesOf: bytes from: 1139 to: 1138 + size startingAt: 1.
	bytes at: size+1139 put: 0! !

!GciErrSType64_30 categoriesForMethods!
argCount!**compiled accessors**!public! !
argCount:!public! !
args!**compiled accessors**!public! !
category!**compiled accessors**!public! !
category:!public! !
categoryOop!public! !
context!**compiled accessors**!public! !
context:!public! !
contextOop!public! !
exceptionObj!**compiled accessors**!public! !
exceptionObj:!public! !
exceptionObjOop!public! !
fatal!**compiled accessors**!public! !
fatal:!public! !
message!**compiled accessors**!public! !
message:!public! !
number!**compiled accessors**!public! !
number:!public! !
oopTypeClass!public! !
reason!**compiled accessors**!public! !
reason:!public! !
!

!GciErrSType64_30 class methodsFor!

defineFields
	"typedef struct {
		OopType			category;												/* error dictionary       */
		OopType			context;												/* GemStone Smalltalk execution state , a GsProcess */
		OopType			exceptionObj;										/* an instance of Exception, or nil; may be nil if error was not signaled from Smalltalk execution */
		OopType			args[GCI_MAX_ERR_ARGS];			/* arguments to error text */
		int					number;												/* GemStone error number  */
		int					argCount;											/* num of arg in the args[]*/
		unsigned char	fatal;													/* nonzero if err is fatal */
		char					message[GCI_ERR_STR_SIZE + 1];	/* null-term. str of err text */		// GCI_ERR_STR_SIZE = 1024
		char					reason[GCI_ERR_reasonSize + 1];	// GCI_ERR_reasonSize = 63

  // If you change this struct,  Smalltalk client FFI code may
  //  need smalltalk code changes.
} GciErrSType;

		GciErrSType64_30 compileDefinition
"

	| arrayField messageField reasonField |
	arrayField := ArrayField type: OopType64Array length: 10.
	messageField := StringField length: 1025.
	reasonField := StringField length: 64.
	self
		defineField: #category 			type: OopType64Field 	new	;
		defineField: #context				type: OopType64Field	new	;
		defineField: #exceptionObj		type: OopType64Field	new	;
		defineField: #args					type: arrayField						;
		defineField: #number				type: DWORDField 		new	;
		defineField: #argCount			type: DWORDField		new	;
		defineField: #fatal					type: BYTEField			new	;
		defineField: #message			type: messageField				;
		defineField: #reason				type: reasonField					;
		yourself.
! !

!GciErrSType64_30 class categoriesForMethods!
defineFields!public! !
!

