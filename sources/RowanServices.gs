! ------- Create dictionary if it is not present
run
| aSymbol names userProfile |
aSymbol := #'RowanServices'.
userProfile := System myUserProfile.
names := userProfile symbolList names.
(names includes: aSymbol) ifFalse: [
	| symbolDictionary |
	symbolDictionary := SymbolDictionary new name: aSymbol; yourself.
	userProfile insertDictionary: symbolDictionary at: names size + 1.
].
%
! ------------------- Class definition for RowanDefinitionService
expectvalue /Class
doit
Object subclass: 'RowanDefinitionService'
	instVarNames: #( definition)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: 'RowanServices'
	category: 'Kernel'
	options: #()

%
expectvalue /Class
doit
RowanDefinitionService category: 'Kernel'
%
! ------------------- Class definition for RowanClassDefinitionService
expectvalue /Class
doit
RowanDefinitionService subclass: 'RowanClassDefinitionService'
	instVarNames: #( name comment instVarNames
	                  classVarNames classInstVarNames superclassName subclassType
	                  poolDictionaryNames classType)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: 'RowanServices'
	category: 'Kernel'
	options: #()

%
expectvalue /Class
doit
RowanClassDefinitionService category: 'Kernel'
%
! ------------------- Class definition for RowanMethodDefinitionService
expectvalue /Class
doit
RowanDefinitionService subclass: 'RowanMethodDefinitionService'
	instVarNames: #( source selector methodDefinitions)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: 'RowanServices'
	category: 'Kernel'
	options: #()

%
expectvalue /Class
doit
RowanMethodDefinitionService category: 'Kernel'
%
! ------------------- Class definition for RowanPackageDefinitionService
expectvalue /Class
doit
RowanDefinitionService subclass: 'RowanPackageDefinitionService'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: 'RowanServices'
	category: 'Kernel'
	options: #()

%
expectvalue /Class
doit
RowanPackageDefinitionService category: 'Kernel'
%

! ------------------- Remove existing behavior from RowanDefinitionService
expectvalue /Metaclass3       
doit
RowanDefinitionService removeAllMethods.
RowanDefinitionService class removeAllMethods.
%
! ------------------- Class methods for RowanDefinitionService
set compile_env: 0
category: 'examples'
classmethod: RowanDefinitionService
sampleService

	^self new sampleService
%
! ------------------- Instance methods for RowanDefinitionService
set compile_env: 0
category: 'rowan'
method: RowanDefinitionService
definitionClass

	^self subclassResponsibility
%
category: 'rowan'
method: RowanDefinitionService
definitionClassName

	^self definitionClass name
%

! ------------------- Remove existing behavior from RowanClassDefinitionService
expectvalue /Metaclass3       
doit
RowanClassDefinitionService removeAllMethods.
RowanClassDefinitionService class removeAllMethods.
%
! ------------------- Class methods for RowanClassDefinitionService
! ------------------- Instance methods for RowanClassDefinitionService

! ------------------- Remove existing behavior from RowanMethodDefinitionService
expectvalue /Metaclass3       
doit
RowanMethodDefinitionService removeAllMethods.
RowanMethodDefinitionService class removeAllMethods.
%
! ------------------- Class methods for RowanMethodDefinitionService
! ------------------- Instance methods for RowanMethodDefinitionService
set compile_env: 0
category: 'accessors'
method: RowanMethodDefinitionService
selector

	^selector
%
category: 'accessors'
method: RowanMethodDefinitionService
selector: aSymbol

	selector := aSymbol
%
category: 'accessors'
method: RowanMethodDefinitionService
source

	^source
%
category: 'accessors'
method: RowanMethodDefinitionService
source: aString

	source := aString
%
set compile_env: 0
category: 'examples'
method: RowanMethodDefinitionService
sampleDefinition

	definition := self definitionClass newForSelector: 'sampleMethod' protocol: 'sampleProtocol' source: self sampleMethodSource.
	source := definition source.
	selector := definition selector.
	^definition
%
category: 'examples'
method: RowanMethodDefinitionService
sampleDefinitions

	methodDefinitions := Array with: self sampleDefinition.
	^methodDefinitions
%
category: 'examples'
method: RowanMethodDefinitionService
sampleMethodSource

	^'sampleMethod ^''some text'''.
%
set compile_env: 0
category: 'rowan'
method: RowanMethodDefinitionService
definitionClass

	^RwMethodDefinition
%

! ------------------- Remove existing behavior from RowanPackageDefinitionService
expectvalue /Metaclass3       
doit
RowanPackageDefinitionService removeAllMethods.
RowanPackageDefinitionService class removeAllMethods.
%
! ------------------- Class methods for RowanPackageDefinitionService
! ------------------- Instance methods for RowanPackageDefinitionService
