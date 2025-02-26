﻿"Filed out from Dolphin Smalltalk"!

JadePreferenceObject subclass: #JadeAutoCompletationRegistryPreference
	instanceVariableNames: 'registry variableMap paramMap'
	classVariableNames: 'Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

JadeAutoCompletationRegistryPreference guid: (GUID fromString: '{adc2a222-162c-4d55-a3ed-4cc43a4a1705}')!

JadeAutoCompletationRegistryPreference comment: ''!

!JadeAutoCompletationRegistryPreference categoriesForClass!Unclassified! !

!JadeAutoCompletationRegistryPreference methodsFor!

configuration

	^JadeAutoCompletationPreference default!

defaultFileName

	^SessionManager current imageBase, 'autocompletationInfo.obj'!

displayString

	^'Autocompletion Registry'!

fileOut
	| fileStream |

	fileStream := FileStream write: self defaultFileName text: false.
	self binaryStoreOn: fileStream.
	fileStream flush.
	fileStream close.!

getAllClassesNames
	"Answer a collection of all classes name"

	^registry keys!

getAllClassMethods
	"Answer a collection with all class methods in the receiver"

	^(registry inject: OrderedCollection new into: [:all :each | all addAll: each gsClassMethods asSortedCollection. all]) copyWithoutDuplicates!

getAllClassMethodsButObject
	"Answer a collection of all methods in the registry but NOT Object Class methods"
	| keys methods |

	keys := registry keys remove: 'Object'; yourself.
	methods := SortedCollection new.

	keys do: [:eachKey | methods addAll: (registry at: eachKey)  gsClassMethods].

	^methods copyWithoutDuplicates!

getAllClassMethodsFor: aJadeGsClassShape
	"Answer a collection of methods of <aJadeGsClassShape> including superclasses methods"
	| methods hierarchy |

	methods := OrderedCollection new.
	hierarchy := aJadeGsClassShape gsClassHierarchy asOrderedCollection.

	self configuration filterObjectMethods ifTrue: [hierarchy := hierarchy removeFirst; yourself ]. "we remove Object class from <hierarchy> Array"

	hierarchy do: [:each | | methodsToDisplay |
		methodsToDisplay := (self includesClassNamed: each) ifTrue: [(self getClass: each) gsClassMethods] ifFalse: [OrderedCollection new].
		self configuration filterPrimitiveMethods ifTrue: [methodsToDisplay := methodsToDisplay reject: [:eachSymbol | eachSymbol first = $_]].
		methods addAll: methodsToDisplay].

	^methods copyWithoutDuplicates

!

getAllClassVarOf: aJadeGsClassShape
	"Answer a collection with all instance variable names of argument <aJadeGsClassShape> including inst var of super classes"
	| vars |

	vars := OrderedCollection new.

	aJadeGsClassShape gsClassHierarchy "iterate over class shape hierarchy to get superclasses inst var names but may be the superclass is NOT in the registry"
		do: [:each | (self includesClassNamed: each) ifTrue: [vars addAll: (self getClass: each) gsClassVariables] ].

	^vars asSortedCollection
!

getAllGlobalMethods
	"Answer all methods in the receiver"
	| methods  | 

	methods := self configuration filterObjectMethods ifTrue: [self getAllMethodsButObject] ifFalse: [self getAllMethods]. 

	self configuration filterPrimitiveMethods ifTrue: [^methods select: [:each | each first ~=  $_] ].

	^methods copyWithoutDuplicates asSortedCollection

!

getAllInstClassVarOf: aJadeGsClassShape
	"Answer a collection with all instance variable names of argument <aJadeGsClassShape> including inst var of super classes"
	| vars |

	vars := OrderedCollection new.

	aJadeGsClassShape gsClassHierarchy "iterate over class shape hierarchy to get superclasses inst var names but may be the superclass is NOT in the registry"
		do: [:each | (self includesClassNamed: each) ifTrue: [vars addAll: (self getClass: each) gsInstClassVariables] ].

	^vars asSortedCollection
!

getAllInstVarNamesOf: aJadeGsClassShape
	"Answer a collection with all instance variable names of argument <aJadeGsClassShape> including inst var of super classes"
	| instVar |

	instVar := OrderedCollection new.

	aJadeGsClassShape gsClassHierarchy "iterate over class shape hierarchy to get superclasses inst var names but may be the superclass is NOT in the registry"
		do: [:each | (self includesClassNamed: each) ifTrue: [instVar addAll: (self getClass: each) gsInstVariables ] ].

	^instVar asSortedCollection
!

getAllMethods
	"Answer of all methods in the receiver"

	^(registry inject: OrderedCollection new into: [:all :each | all addAll: each gsMethods asSortedCollection. all]) copyWithoutDuplicates!

getAllMethodsButObject
	"Answer of all methods in the receiver but NOT Object methods"
	| keys methods |

	keys := registry keys remove: 'Object' ifAbsent:[]; yourself.
	methods := SortedCollection new.

	keys do: [:eachKey | | currentClassMethods |
		currentClassMethods := (registry at: eachKey)  gsMethods select: [:each | each class ==  String or:[each class == Symbol]].
		methods addAll: currentClassMethods].

	^methods copyWithoutDuplicates!

getAllMethodsFor: aJadeGsClassShape
	"Answer a collection of methods of <aJadeGsClassShape> including superclasses methods"
	| methods hierarchy |

	methods := OrderedCollection new.
	hierarchy := aJadeGsClassShape gsClassHierarchy asOrderedCollection.

	self configuration filterObjectMethods ifTrue: [hierarchy := hierarchy removeFirst; yourself ]. "we remove Object class from <hierarchy> Array"

	hierarchy do: [:each | | methodsToDisplay |
		methodsToDisplay := (self includesClassNamed: each) ifTrue: [(self getClass: each) gsMethods] ifFalse: [OrderedCollection new].
		self configuration filterPrimitiveMethods ifTrue: [methodsToDisplay := methodsToDisplay reject: [:eachSymbol | eachSymbol first = $_]].
		methods addAll: methodsToDisplay].

	^methods copyWithoutDuplicates

!

getAllPoolDictionariesOf: aJadeGsClassShape
	"Answer a collection with all instance variable names of argument <aJadeGsClassShape> including inst var of super classes"
	| pools |

	pools := OrderedCollection new.

	aJadeGsClassShape gsClassHierarchy "iterate over class shape hierarchy to get superclasses inst var names but may be the superclass is NOT in the registry"
		do: [:each | (self includesClassNamed: each) ifTrue: [pools addAll: (self getClass: each) gsPoolDictionaries] ].

	^pools asSortedCollection
!

getAllVarNamesOf: aJadeGsClassShape
	"Answer a collection with all instance variable names of argument <aJadeGsClassShape> including inst var of super classes"
	| allVarNames |

	allVarNames := self getAllInstVarNamesOf: aJadeGsClassShape.

	self configuration hideClassVars ifFalse: [allVarNames addAll: (self getAllClassVarOf: aJadeGsClassShape)].
	self configuration hideInstClassVars ifFalse: [allVarNames addAll: (self getAllInstClassVarOf: aJadeGsClassShape)].
	self configuration hidePoolDictionaries ifFalse: [allVarNames addAll: (self getAllPoolDictionariesOf: aJadeGsClassShape)].

	^allVarNames
!

getClass: aString
	"The receiver answer the register JadeGsClassShape for the name <aString> if none answer <nil>"

	^registry at: aString asString ifAbsent: [nil]!

getClassesNamedWith: aString
	"Answer a collection of JadeGsClassShape which it's name includes <aString> as subcollection"

	^self getAllClassesNames reject: [:each | (each indexOfSubCollection: aString trimBlanks) isZero]!

hasMapFor: aString
	"Answer whether the receiver has map for arg <aString>"

	^variableMap includesKey: aString!

hasMapForClassNamed: aString
	"Answer whether the receiver has a map in <variableMap> dictionary for target <aString>"

	^variableMap anySatisfy: [:each | each name = aString]!

icon

	^Package icon!

includesClassNamed: aString
	"Answer whether the receiver has registered a class named <aString>"

	^registry includesKey: aString!

initialize

	super initialize.

	registry := Dictionary new.
	variableMap := Dictionary new. "for example: html -> WAHtmlCanvas"
	self initializeParamMap.!

initializeParamMap

	paramMap := Dictionary new.
	paramMap
		at: 'detect:ifNone:' put: '[:each | each],[]';
		at: 'inject:into:' put: '0, [:sum :each | ]';
		at: 'ifEmpty:ifNotEmpty:' put: '[emptyOperation],[:collection | ]';
		at: 'ifNotEmpty:ifEmpty:' put: '[:collection | ],[emptyOperation]';
		at: 'ifNil:ifNotNil:' put: '[],[:value | value]';
		at: 'ifNotNil:ifNil:' put: '[:value | value],[]';
		at: 'ifTrue:ifFalse:' put: '[],[]';
		at: 'ifFalse:ifTrue:' put: '[],[]';
		at: 'select:' put: '[:each | each]';
		at: 'allSatisfy:' put: '[:each | each]';
		at: 'anySatisfy:' put: '[:each | each]';
		at: 'ifNotNil:' put: '[:value | value]';
		at: 'ifNil:' put: '[]';
		at: 'detect:' put: '[:each | each]';
		at: 'ifTrue:' put: '[]';
		at: 'ifFalse:' put: '[]';
		at: 'collect:' put: '[:each | each]';
		at: 'do:' put: '[:each | each]';
		yourself.

	^paramMap!

mapFor: aString
	"Answer the map (instance of JadeGsClassShape) for the name <aString> "

	^variableMap at: aString ifAbsent: [nil]!

mapToDisplay
	"Format <variableMap> to be displayed in a Presenter"
	| collection |

	collection := OrderedCollection new.
	variableMap keys do: [:eachKey | collection add: (eachKey, '>>', (variableMap at: eachKey) name)].

	^collection!

openCustomPopUpFor: symbolName ifNone: aNiladicValuable 

	(symbolName = #variableMap) ifTrue: [^self showVariableMapShell].
	(symbolName = #paramMap) ifTrue: [^self showParamMapShell].
	(symbolName = #registry) ifTrue: [^self showRegistryShell].

	^aNiladicValuable value!

paramFor: methodName
	"Answer the text for a parameter in the method named <methodName>, if none answer 'param' "

	^paramMap at: methodName ifAbsent: ['param']!

paramFor: methodName index: index
	"Answer the text for a parameter in the method named <methodName>, if none answer 'param' "
	| paramText |

	(paramMap includesKey: methodName) ifFalse: [^'param'].

	paramText := paramMap at: methodName.

	(paramText includes: $,)  ifFalse: [^paramText]. "the name is the same for all parameters"

	((methodName subStrings: ':') size = (paramText subStrings: ',') size) ifFalse: [^paramText]. "the number of arguments in <methodName> must be equel to number of parameter names in <paramText>"

	^(paramText subStrings: ',') at: index "pickup the paramter name "!

paramMap
	^paramMap!

paramMap: anObject
	paramMap := anObject!

paramsToDisplay
	"Format <paramMap> to be displayed in a Presenter"
	| collection |

	collection := SortedCollection new.
	paramMap keys do: [:eachKey | collection add: (eachKey, '>>', (paramMap at: eachKey))].

	^collection!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects
		add: (Aspect string: #variableMap);
		add: (Aspect string: #paramMap);
		add: (Aspect string: #registry).
	^aspects!

register: jadeClass
	"The receiver register the JadeGsClassShape instance <jadeClass>.
	- if there is a registered map for JadeGsClassShape instance <jadeClass> then update the class of the map with this new updated instance <jadeClass>.
	- register the class"

	(self hasMapForClassNamed: jadeClass name) ifTrue: [self updateGsClassForMapStrings: jadeClass]. "update the JadeGsClassShape of an existing map"

	^registry at: jadeClass name put: jadeClass "register the class"!

registerMap: mapString gsClassName: aString
	"The receiver register a mapping between a text <mapString> and a JadeGsClassShape named <aString>.
	For example: 'html'>>WAHtmlCanvas.
	Each time 'html' is typed the autocompletation engine will map it to a WAHtmlCanvas showing it's methods (very usefull at development)"

	^variableMap at: mapString put: (self getClass: aString)!

registerParamFor: methodName param: aString
	"The receiver register a parameter text <aString> for the method name <methodName>.
	For example: 'select:'>>'[:each | ]'
	Each time 'select:' is typed the autocompletation engine will put '[:each | each]' as the text for the parameter "

	^paramMap at: methodName put: aString!

registry
	^registry!

registry: anObject
	registry := anObject!

registryAsSortedCollection
	"Answer a SortedCollection with the values of the registry JadeGsClassShape instances"

	^registry asSortedCollection: [:a :b | a name <= b name]!

setAsDefault
	"Set the receiver as the default registry. Use this in the fileOut and fileIn process"

	^self class default: self!

showParamMapShell
	| shell |

	shell := JadeParamAutocompletationPresenter show view topView.
	shell 
		caption: 'Config Param for Messages';
		extent: 478@568!

showRegistryShell
	| shell |

	shell := JadeRegistryPresenter show view topView.
	shell 
		caption: 'Registered GS Classes for Autocompletion';
		extent: 450@512!

showVariableMapShell
	| shell |

	shell := JadeMapAutocompletationPresenter show view topView.
	shell 
		caption: 'Map Variable Names with GS classes';
		extent: 472@574!

unregister: aString
	"The receiver unregister the class JadeGsClassShape <jadeClass>"

	^registry removeKey: aString ifAbsent: [nil].!

unregisterClassNamed: className
	"The receiver unregister the class named <className>"

	^registry removeKey: className ifAbsent: []!

unregisterMap: mapString 
	"The receiver unregister the map named <mapString>"

	^variableMap removeKey: mapString ifAbsent: []!

unregisterParam: methodName 
	"The receiver unregister the method named <methodName> for parameter substitution"

	^paramMap removeKey: methodName!

updateGsClassForMapStrings: aJadeGsClassShape
	"The receiver update all variables map text that hold a class with same name as <aJadeGsClassShape> with this new update instance <aJadeGsClassShape>"
	| keysToUpdate |

	keysToUpdate := variableMap keys select: [:eachKey | (variableMap at: eachKey) name = aJadeGsClassShape name]. "select keys which it's value is equal to <aJadeGsClassShape> name"

	keysToUpdate do: [:eachKey | variableMap at: eachKey put: aJadeGsClassShape] "we update those keys with this new update instance"!

variableMap
	^variableMap!

variableMap: anObject
	variableMap := anObject! !

!JadeAutoCompletationRegistryPreference categoriesForMethods!
configuration!public! !
defaultFileName!public! !
displayString!public! !
fileOut!public! !
getAllClassesNames!public! !
getAllClassMethods!public! !
getAllClassMethodsButObject!public! !
getAllClassMethodsFor:!public! !
getAllClassVarOf:!public! !
getAllGlobalMethods!public! !
getAllInstClassVarOf:!public! !
getAllInstVarNamesOf:!public! !
getAllMethods!public! !
getAllMethodsButObject!public! !
getAllMethodsFor:!public! !
getAllPoolDictionariesOf:!public! !
getAllVarNamesOf:!public! !
getClass:!public! !
getClassesNamedWith:!public! !
hasMapFor:!public! !
hasMapForClassNamed:!public! !
icon!public! !
includesClassNamed:!public! !
initialize!public! !
initializeParamMap!public! !
mapFor:!public! !
mapToDisplay!public! !
openCustomPopUpFor:ifNone:!custom shell!public! !
paramFor:!public! !
paramFor:index:!public! !
paramMap!accessing!private! !
paramMap:!accessing!private! !
paramsToDisplay!public! !
publishedAspects!public! !
register:!public! !
registerMap:gsClassName:!public! !
registerParamFor:param:!public! !
registry!accessing!private! !
registry:!accessing!private! !
registryAsSortedCollection!public! !
setAsDefault!public! !
showParamMapShell!custom shell!public! !
showRegistryShell!custom shell!public! !
showVariableMapShell!custom shell!public! !
unregister:!public! !
unregisterClassNamed:!public! !
unregisterMap:!public! !
unregisterParam:!public! !
updateGsClassForMapStrings:!public! !
variableMap!accessing!private! !
variableMap:!accessing!private! !
!

!JadeAutoCompletationRegistryPreference class methodsFor!

newFromFile: pathFile
	| fileStream obj |

	fileStream := FileStream read: pathFile text: false.
	obj := self binaryReadFrom: fileStream.
	fileStream close.
	^obj! !

!JadeAutoCompletationRegistryPreference class categoriesForMethods!
newFromFile:!public! !
!

