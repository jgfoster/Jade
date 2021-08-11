# Jade

A new Flutter project.

# Function List

## Desired Functions

The following provides a list of all the functions defined in `gcits.hf` grouped to roughly parallel the tables in the GemBuilder for C manual. Checked items have been completed.

### Table 7.1 Functions for Controlling Sessions and Transactions

```C
✓   BoolType   GciTsAbort(GciSession sess, GciErrSType *err);
✓   BoolType   GciTsBegin(GciSession sess, GciErrSType *err);
✓   BoolType   GciTsCommit(GciSession sess, GciErrSType *err);
✓   char*      GciTsEncrypt(const char* password, char *outBuf, size_t outBuffSize);
✓   int        GciTsSessionIsRemote(GciSession sess);
✓   GciSession GciTsLogin(...);
✓   BoolType   GciTsLogout(GciSession sess, GciErrSType *err);
```

### Table 7.2 Functions for Handling Errors and Interrupts and for Debugging

```C
✓   BoolType   GciTsBreak(GciSession sess, BoolType hard, GciErrSType *err);
    int        GciTsCallInProgress(GciSession sess, GciErrSType *err);
    BoolType   GciTsClearStack(GciSession sess, OopType gsProcess, GciErrSType *err);
    OopType    GciTsContinueWith(GciSession sess, ...);
    int        GciTsGemTrace(GciSession sess, int enable, GciErrSType *err);
```

### Table 7.3 Functions for Managing Object Bitmaps

```C
    BoolType   GciTsReleaseObjs(GciSession sess, OopType *buf, int count, GciErrSType *err);
    BoolType   GciTsReleaseAllObjs(GciSession sess, GciErrSType *err);
    BoolType   GciTsSaveObjs(GciSession sess, OopType *buf, int count, GciErrSType *err);
```

### Table 7.4 Functions for Compiling and Executing Smalltalk Code in the Database

```C
    OopType    GciTsCompileMethod(GciSession sess, ...);
    BoolType   GciTsProtectMethods(GciSession sess, BoolType mode, GciErrSType *err);
    OopType    GciTsExecute(GciSession sess, ...);
    OopType    GciTsExecute_(GciSession sess, ...);
    ssize_t    GciTsExecuteFetchBytes(GciSession sess, ...);
    OopType    GciTsPerform(GciSession sess, ...);
    ssize_t    GciTsPerformFetchBytes(GciSession sess, ...);
```

### Table 7.5 Functions for Accessing Symbol Dictionaries

```C
    OopType    GciTsResolveSymbol(GciSession sess, ...);
    OopType    GciTsResolveSymbolObj(GciSession sess, ...);
```

### Table 7.6 Functions for creating and Initializing Objects

```C
    int        GciTsGetFreeOops(GciSession sess, OopType *buf, int numOopsRequested, GciErrSType *err);
    OopType    GciTsNewObj(GciSession sess, OopType aClass, GciErrSType *err);
    OopType    GciTsNewByteArray(GciSession sess, ...);
    OopType    GciTsNewString_(GciSession sess, ...);
    OopType    GciTsNewSymbol(GciSession sess, ...);
    OopType    GciTsNewUnicodeString_(GciSession sess, ...);
    OopType    GciTsNewUtf8String_(GciSession sess, ...);
    int64      GciTsFetchUnicode(GciSession sess, ...);
```

### Table 7.7 Functions for Converting Objects and Values

```C
✓   BoolType   GciTsOopIsSpecial(OopType oop);
✓   OopType    GciTsFetchSpecialClass(OopType oop);
✓   int        GciTsOopToChar(OopType oop);
✓   OopType    GciTsCharToOop(uint ch);
✓   OopType    GciTsDoubleToSmallDouble(double aFloat);
✓   OopType    GciI32ToOop(int arg);
    OopType    GciTsDoubleToOop(GciSession sess, double aDouble, GciErrSType *err);
    BoolType   GciTsOopToDouble(GciSession sess, OopType oop, ...);
    OopType    GciTsI64ToOop(GciSession sess, int64 arg, GciErrSType *err);
    BoolType   GciTsOopToI64(GciSession sess, OopType oop, int64 *result, GciErrSType *err);
```

### Table 7.8 Object Traversal and Path Functions

```C
    int        GciTsStoreTravDoTravRefs(GciSession sess, ...);
    int        GciTsFetchTraversal(GciSession sess, ...);
    BoolType   GciTsStoreTrav(GciSession sess, ...);
    int        GciTsMoreTraversal(GciSession sess, ...);
```

### Table 7.9 Structural Access Functions

```C
    int64      GciTsFetchBytes(GciSession sess, ...);
    int64      GciTsFetchChars(GciSession sess, ...);
    int64      GciTsFetchUtf8Bytes(GciSession sess, ...);
    BoolType   GciTsStoreBytes(GciSession sess, ...);
    int        GciTsFetchOops(GciSession sess, ...);
    BoolType   GciTsStoreOops(GciSession sess, ...);
    int        GciTsRemoveOopsFromNsc(GciSession sess, ...);
    int64      GciTsFetchObjInfo(GciSession sess, OopType objId, ...);
    int64      GciTsFetchSize(GciSession sess, OopType obj, GciErrSType *err);
    int64      GciTsFetchVaryingSize(GciSession sess, OopType obj, GciErrSType *err);
    OopType    GciTsFetchClass(GciSession sess, OopType obj, GciErrSType *err);
    int        GciTsIsKindOf(GciSession sess, ...);
    int        GciTsIsSubclassOf(GciSession sess, ...);
    int        GciTsIsKindOfClass(GciSession sess, ...);
    int        GciTsIsSubclassOfClass(GciSession sess, ...);
    BoolType   GciTsObjExists(GciSession sess, OopType obj);
```

### Table 7.10 Utility Functions

```C
✓   uint       GciTsVersion(char *buf, size_t bufSize);
    int        GciTsWaitForEvent(GciSession sess, int latencyMs, ...);
    BoolType   GciTsCancelWaitForEvent(GciSession sess, GciErrSType *err);
```

## Other Functions

### Fork

GciTs offers a variety of `Fork` functions that take a callback.

```C
    BoolType   GciTsForkLogin(...);
    BoolType   GciTsForkContinueWith(GciSession sess, ...);
    BoolType   GciTsForkExecute(GciSession sess, ...);
    BoolType   GciTsForkPerform(GciSession sess, ...);
    BoolType   GciTsForkStoreTravDoTravRefs(GciSession sess, ...);
```

### String

The following are deprecated in favor of the underscore version.

```C
    OopType    GciTsNewString(GciSession sess, ...);
    OopType    GciTsNewUnicodeString(GciSession sess, ...);
    OopType    GciTsNewUtf8String(GciSession sess, ...);
```

The following provide UTF-8 conversion.

```C
    BoolType   GciUtf8To8bit(const char* src, char *dest, ssize_t destSize);
    ssize_t    GciNextUtf8Character(const char* src, size_t len, uint *chOut);
```

### GCI Errors

The following did not seem to work when originally tested.

```C
    BoolType   GciTsClassRemoveAllMethods(GciSession sess, ...);
    int64      GciTsFetchUtf8(GciSession sess, ...);
```
