﻿"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #GciTsObjInfo
	instanceVariableNames: 'data'
	classVariableNames: '_OffsetOf__bits _OffsetOf_access _OffsetOf_namedSize _OffsetOf_objClass _OffsetOf_objectSecurityPolicyId _OffsetOf_objId _OffsetOf_objSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GciTsObjInfo guid: (GUID fromString: '{6a0671ac-78ff-43d1-b841-525b61598094}')!

GciTsObjInfo addClassConstant: '_OffsetOf__bits' value: 16r1E!
GciTsObjInfo addClassConstant: '_OffsetOf_access' value: 16r20!
GciTsObjInfo addClassConstant: '_OffsetOf_namedSize' value: 16r18!
GciTsObjInfo addClassConstant: '_OffsetOf_objClass' value: 16r8!
GciTsObjInfo addClassConstant: '_OffsetOf_objectSecurityPolicyId' value: 16r1C!
GciTsObjInfo addClassConstant: '_OffsetOf_objId' value: 16r0!
GciTsObjInfo addClassConstant: '_OffsetOf_objSize' value: 16r10!

GciTsObjInfo comment: '
class GciTsObjInfo {
	public:
		OopType			objId;
		OopType			objClass;							/* OOP of the class of the obj						*/
		int64					objSize;								/* obj''s total size, in bytes or OOPs					*/
		int					namedSize;						/* num of named inst vars in the obj				*/
		unsigned short	objectSecurityPolicyId;		/* previously named segmentId						*/
		unsigned short	_bits;
		unsigned short	access;								/* 0 no auth, 1 read allowed, 2 write allowed	*/

		enum { 
			AUTH_NONE = 0, AUTH_READ = 1, AUTH_WRITE = 2 
		};
		enum {  // definitions of _bits
			implem_mask		= GC_IMPLEMENTATION_MASK,	// 0x03
			indexable_mask	= GC_INDEXABLE_MASK,				// 0x04
			invariant_mask		= GC_INVARIANT_MASK,				// 0x08
			partial_mask			= 0x10,
			overlay_mask		= 0x20,
			is_placeholder		= 0x40,		// object is place holder for unsatisfied forward reference
			swiz_kind_mask	= 0x300,
			swiz_kind_shift		= 8
		};

		inline unsigned char isInvariant()	{ return _bits & invariant_mask;	}
		inline unsigned char isIndexable()	{ return _bits & indexable_mask;	}
		inline unsigned char isPartial()		{ return _bits & partial_mask;		}
		inline unsigned char isOverlayed()	{ return _bits & overlay_mask;		}

		inline GciByteSwizEType byteSwizKind() const {
			return (GciByteSwizEType)((_bits & swiz_kind_mask) >> swiz_kind_shift) ;
		}

		inline unsigned char objImpl() {
			/* implementation format 0..3 , one of GC_FORMAT_OOP..GC_FORMAT_SPECIAL */
			return _bits & GC_IMPLEMENTATION_MASK;
		}
};'!

!GciTsObjInfo categoriesForClass!Unclassified! !

!GciTsObjInfo methodsFor!

_bits
	"Answer the receiver's _bits field as a Smalltalk object."

	^(bytes swordAtOffset: 30)!

_bits: anObject
	"Set the receiver's _bits field to the value of anObject."

	bytes swordAtOffset: 30 put: anObject!

access
	"Answer the receiver's access field as a Smalltalk object."

	^(bytes swordAtOffset: 32)!

access: anObject
	"Set the receiver's access field to the value of anObject."

	bytes swordAtOffset: 32 put: anObject!

data
	^data!

data: anObject
	data := anObject!

implementation
"
#define GC_FORMAT_OOP			0
#define GC_FORMAT_BYTE			1
#define GC_FORMAT_NSC			2
#define GC_FORMAT_SPECIAL		3
"
	^self _bits bitAnd: 16r03	"implem_mask    = GC_IMPLEMENTATION_MASK, // 0x03"
!

isIndexable

	^0 < (self _bits bitAnd: 16r04)	"indexable_mask = GC_INDEXABLE_MASK,      // 0x04"
!

isInvariant

	^0 < (self _bits bitAnd: 16r08)	"invariant_mask = GC_INVARIANT_MASK,      // 0x08"
!

isReadable

	^0 < self access.
!

isWriteable

	^1 < self access.
!

namedSize
	"Answer the receiver's namedSize field as a Smalltalk object."

	^(bytes sdwordAtOffset: 24)!

namedSize: anObject
	"Set the receiver's namedSize field to the value of anObject."

	bytes sdwordAtOffset: 24 put: anObject!

objClass
	"Answer the receiver's objClass field as a Smalltalk object."

	^(bytes qwordAtOffset: 8)!

objClass: anObject
	"Set the receiver's objClass field to the value of anObject."

	bytes qwordAtOffset: 8 put: anObject value!

objClassOop

	^OopType64 fromInteger: self objClass.
!

objectSecurityPolicyId
	"Answer the receiver's objectSecurityPolicyId field as a Smalltalk object."

	^(bytes swordAtOffset: 28)!

objectSecurityPolicyId: anObject
	"Set the receiver's objectSecurityPolicyId field to the value of anObject."

	bytes swordAtOffset: 28 put: anObject!

objId
	"Answer the receiver's objId field as a Smalltalk object."

	^(bytes qwordAtOffset: 0)!

objId: anObject
	"Set the receiver's objId field to the value of anObject."

	bytes qwordAtOffset: 0 put: anObject!

objSize
	"Answer the receiver's objSize field as a Smalltalk object."

	^(bytes sqwordAtOffset: 16)!

objSize: anObject
	"Set the receiver's objSize field to the value of anObject."

	bytes sqwordAtOffset: 16 put: anObject! !

!GciTsObjInfo categoriesForMethods!
_bits!**compiled accessors**!public! !
_bits:!**compiled accessors**!public! !
access!**compiled accessors**!public! !
access:!**compiled accessors**!public! !
data!accessing!public! !
data:!accessing!public! !
implementation!public!testing! !
isIndexable!public!testing! !
isInvariant!public!testing! !
isReadable!public!testing! !
isWriteable!public!testing! !
namedSize!**compiled accessors**!public! !
namedSize:!**compiled accessors**!public! !
objClass!**compiled accessors**!public! !
objClass:!**compiled accessors**!public! !
objClassOop!public! !
objectSecurityPolicyId!**compiled accessors**!public! !
objectSecurityPolicyId:!**compiled accessors**!public! !
objId!**compiled accessors**!public! !
objId:!**compiled accessors**!public! !
objSize!**compiled accessors**!public! !
objSize:!**compiled accessors**!public! !
!

!GciTsObjInfo class methodsFor!

defineFields
"
	GciTsObjInfo compileDefinition.
"
	self
		defineField: #objId 							type: QWORDField 	new	;
		defineField: #objClass						type: QWORDField 	new	;
		defineField: #objSize							type: SQWORDField	new	;
		defineField: #namedSize					type: SDWORDField	new	;
		defineField: #objectSecurityPolicyId	type: SWORDField	new	;
		defineField: #_bits								type: SWORDField	new	;
		defineField: #access							type: SWORDField	new	;
		yourself.
! !

!GciTsObjInfo class categoriesForMethods!
defineFields!public! !
!

