expectvalue /Class
doit
GciTsObjInfo comment: 
'
	"$GEMSTONE/include/gcits.hf line 391
class GciTsObjInfo { public:  OopType objId;  OopType objClass;  int64 objSize;  int namedSize;  uint access;  unsigned short objectSecurityPolicyId;  unsigned short _bits;  enum {     AUTH_NONE = 0, AUTH_READ = 1, AUTH_WRITE = 2  };  GciTsObjInfo() {    initialize();  }  void initialize() {    objId = ((OopType)0x14);    objClass = ((OopType)0x14);    objSize = 0;    namedSize = 0;    access = 0;    objectSecurityPolicyId = 0;    _bits = 0;  }  enum {      implem_mask = GC_IMPLEMENTATION_MASK,      indexable_mask = GC_INDEXABLE_MASK,      invariant_mask = GC_INVARIANT_MASK,      partial_mask = 0x10,      overlay_mask = 0x20,      is_placeholder = 0x40 ,      swiz_kind_mask = 0x300,           swiz_kind_shift = 8  };  inline unsigned char isInvariant() { return _bits & invariant_mask; }  inline unsigned char isIndexable() { return _bits & indexable_mask; }  inline unsigned char isPartial() { return _bits & partial_mask; }  inline unsigned char isOverlayed() { return _bits & overlay_mask; }  inline GciByteSwizEType byteSwizKind() const {     return (GciByteSwizEType)((_bits & swiz_kind_mask) >> swiz_kind_shift) ;  }  inline unsigned char objImpl() {    return _bits & GC_IMPLEMENTATION_MASK;  }};"
'
%
! ------------------- Remove existing behavior from GciTsObjInfo
expectvalue /Metaclass3
doit
GciTsObjInfo removeAllMethods.
GciTsObjInfo class removeAllMethods.
%
set compile_env: 0
! ------------------- Class methods for GciTsObjInfo
category: 'Instance Creation'
classmethod: GciTsObjInfo
new

	^self gcMalloc: 40.
%
category: 'Instance Creation'
classmethod: GciTsObjInfo
on: aCByteArray

	^self withAll: aCByteArray.
%
! ------------------- Instance methods for GciTsObjInfo
category: 'Accessing'
method: GciTsObjInfo
_bits

	^self uint16At: 34.
%
category: 'Updating'
method: GciTsObjInfo
_bits: anObject

	self 
		uint16At: 34
		put: anObject.
%
category: 'Conversion'
method: GciTsObjInfo
_stringFromBytes: aByteArray

	| index |
	index := aByteArray indexOf: 0.
	^aByteArray
		at: 1
		sizeBytes: 1
		stringSize: (0 == index ifTrue: [aByteArray size] ifFalse: [index - 1]).
%
category: 'Accessing'
method: GciTsObjInfo
access

	^self uint32At: 28.
%
category: 'Updating'
method: GciTsObjInfo
access: anObject

	self 
		uint32At: 28
		put: anObject.
%
category: 'Initialization'
method: GciTsObjInfo
initialize
%
category: 'Initialization'
method: GciTsObjInfo
initialize: aCByteArray

	1 to: (self size min: aCByteArray size) do: [:i |
		self uint8At: i put: (aCByteArray uint8At: i).
	].
%
category: 'Accessing'
method: GciTsObjInfo
namedSize

	^self int32At: 24.
%
category: 'Updating'
method: GciTsObjInfo
namedSize: anObject

	self 
		int32At: 24
		put: anObject.
%
category: 'Accessing'
method: GciTsObjInfo
objClass

	^self uint64At: 8.
%
category: 'Updating'
method: GciTsObjInfo
objClass: anObject

	self 
		uint64At: 8
		put: anObject.
%
category: 'Accessing'
method: GciTsObjInfo
objectSecurityPolicyId

	^self uint16At: 32.
%
category: 'Updating'
method: GciTsObjInfo
objectSecurityPolicyId: anObject

	self 
		uint16At: 32
		put: anObject.
%
category: 'Accessing'
method: GciTsObjInfo
objId

	^self uint64At: 0.
%
category: 'Updating'
method: GciTsObjInfo
objId: anObject

	self 
		uint64At: 0
		put: anObject.
%
category: 'Accessing'
method: GciTsObjInfo
objSize

	^self int64At: 16.
%
category: 'Updating'
method: GciTsObjInfo
objSize: anObject

	self 
		int64At: 16
		put: anObject.
%
