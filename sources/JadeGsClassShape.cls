"Filed out from Dolphin Smalltalk"!

Object subclass: #JadeGsClassShape
	instanceVariableNames: 'name gsInstVariables gsClassVariables gsInstClassVariables gsPoolDictionaries gsMethods gsClassMethods gsClassHierarchy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeGsClassShape guid: (GUID fromString: '{706d0cb1-9735-4db8-9d5a-45b1ca2c55a3}')!
JadeGsClassShape comment: 'JadeGsClassShape represent individual information about GemStone/S classes.

Instance of this class are only created through the user interface JadeAutoSystemBrowserPresenter.

Each time a class is selected in the hierarchy browser an instance of this class is created and updated in the registry (JadeAutocompletationRegistry).

The Autocompletation engine use instance of this class to show autocompletation options.'!
!JadeGsClassShape categoriesForClass!Unclassified! !
!JadeGsClassShape methodsFor!

configuration
	^JadeAutoCompletationPreference default!

existInRegistry

	^self registry includesClassNamed: name!

getAllClassMethods

	^self registry getAllClassMethodsFor: self!

getAllInstVarNames

	^self registry getAllInstVarNamesOf: self

!

getAllMethods

	^self registry getAllMethodsFor: self!

getAllVarNames

	^self registry getAllVarNamesOf: self

!

getClassInstanceVariableLike: aString

	^self gsInstClassVariables select: [:each | (aString, '*') match: each]!

getClassVariableAndPoolDictionaryLike: aString

	^(self gsClassVariables select: [:each | (aString, '*') match: each]), (self gsPoolDictionaries select: [:each | (aString, '*') match: each])!

getInstanceVariableLike: aString

	^self getAllVarNames select: [:each | (aString, '*') match: each]!

getNamesAfterAssigment

	^self getAllVarNames
	"^self getAllInstVarNames"

	"^(self getAllInstVarNames, self getAllClassesNames asSortedCollection) asSortedCollection."

	!

gsClassHierarchy
	^gsClassHierarchy!

gsClassHierarchy: anObject
	gsClassHierarchy := anObject!

gsClassMethods
	^gsClassMethods!

gsClassMethods: anObject
	gsClassMethods := anObject!

gsClassVariables
	^gsClassVariables!

gsClassVariables: anObject
	gsClassVariables := anObject!

gsInstClassVariables
	^gsInstClassVariables!

gsInstClassVariables: anObject
	gsInstClassVariables := anObject!

gsInstVariables
	^gsInstVariables!

gsInstVariables: anObject
	gsInstVariables := anObject!

gsMethods
	^gsMethods!

gsMethods: anObject

	gsMethods := anObject!

gsPoolDictionaries
	^gsPoolDictionaries!

gsPoolDictionaries: anObject
	gsPoolDictionaries := anObject!

initialize

	super initialize.

	gsInstVariables := OrderedCollection new.
	gsClassVariables := OrderedCollection new.
	gsInstClassVariables := OrderedCollection new.
	gsPoolDictionaries := OrderedCollection new.
	gsMethods := LookupTable new.
	gsClassMethods := LookupTable new.!

name
	^name!

name: anObject
	name := anObject!

registry

	^JadeAutoCompletationRegistryPreference default!

updateClassData
	| previousShape |

	gsMethods ifNil: [gsMethods := LookupTable new].
	gsClassMethods ifNil: [gsClassMethods := LookupTable new].

	self existInRegistry ifFalse: [^self registry register: self].

	previousShape := self registry getClass: name.

	gsMethods isEmpty ifTrue: [gsMethods := previousShape gsMethods].
	gsClassMethods isEmpty ifTrue: [gsClassMethods := previousShape gsClassMethods].

	^self registry register: self! !
!JadeGsClassShape categoriesForMethods!
configuration!public! !
existInRegistry!public! !
getAllClassMethods!auto methods!public! !
getAllInstVarNames!public! !
getAllMethods!auto methods!public! !
getAllVarNames!public! !
getClassInstanceVariableLike:!public! !
getClassVariableAndPoolDictionaryLike:!public! !
getInstanceVariableLike:!public! !
getNamesAfterAssigment!public! !
gsClassHierarchy!accessing!private! !
gsClassHierarchy:!accessing!private! !
gsClassMethods!accessing!private! !
gsClassMethods:!accessing!private! !
gsClassVariables!accessing!private! !
gsClassVariables:!accessing!private! !
gsInstClassVariables!accessing!private! !
gsInstClassVariables:!accessing!private! !
gsInstVariables!accessing!private! !
gsInstVariables:!accessing!private! !
gsMethods!accessing!private! !
gsMethods:!accessing!private! !
gsPoolDictionaries!accessing!private! !
gsPoolDictionaries:!accessing!private! !
initialize!public! !
name!accessing!private! !
name:!accessing!private! !
registry!public! !
updateClassData!public! !
!

