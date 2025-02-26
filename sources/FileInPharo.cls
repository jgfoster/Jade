﻿"Filed out from Dolphin Smalltalk"!

Object subclass: #FileInPharo
	instanceVariableNames: 'gciSession fileStream classes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FileInPharo guid: (GUID fromString: '{256c2c5a-83ee-490d-ba07-7388c5e12701}')!

FileInPharo comment: ''!

!FileInPharo categoriesForClass!Unclassified! !

!FileInPharo methodsFor!

chunk: aString

	| pieces |
	aString trimBlanks isEmpty ifTrue: [^self].
	aString trimBlanks = '"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "' ifTrue: [^self].
	pieces := aString subStrings.
	(pieces size == 9 and: [(pieces at: 2) = 'subclass:' and: [
			(pieces at: 4) = 'instanceVariableNames:' and: [
			(pieces at: 6) = 'classVariableNames:' and: [
			(pieces at: 8) = 'package:']]]]) ifTrue: [
		^self 
			class: (pieces at: 1) 
			subclass: (pieces at: 3) 
			instVarNames: (pieces at: 5) 
			classVarNames: (pieces at: 7) 
			package: (pieces at: 9)
		].
	(pieces size == 5 and: [(pieces at: 2) = 'commentStamp:']) ifTrue: [
		^self commentStamp: (pieces at: 1)
	].
	(pieces size >= 3 and: [(pieces at: 2) = 'methodsFor:']) ifTrue: [
		| stream |
		stream := WriteStream on: String new.
		pieces from: 3 do: [:each | stream nextPutAll: each; space].
		^self methodsForClass: (pieces at: 1) category: stream contents trimBlanks.
	].
	(pieces size == 4 and: [(pieces at: 2) = 'class' and: [(pieces at: 3) = 'methodsFor:']]) ifTrue: [
		^self methodsForClass: (pieces at: 1) , ' class' category: (pieces at: 4)
	].
	(pieces size == 4 and: [(pieces at: 2) = 'class' and: [(pieces at: 3) = 'instanceVariableNames:']]) ifTrue: [
		^self class: (pieces at: 1) , ' class' instVarNames: (pieces at: 4)
	].
	self halt.
!

class: className instVarNames: instVarNames 

	(classes at: className subStrings first) classInstVarNames: instVarNames.
!

class: className subclass: subclassSymbol instVarNames: instVarNames classVarNames: classVarNames package: packageName

	| pharoClass subclassName |
	subclassName := subclassSymbol copyFrom: 2 to: subclassSymbol size.
	pharoClass := PharoClass
		superclassName: className 
		subclass: subclassName 
		instVarNames: instVarNames 
		classVarNames: classVarNames 
		package: packageName.
	classes at: subclassName put: pharoClass.
!

commentStamp: className

	(classes at: className) comment: (fileStream upTo: $!!).
!

initialize: aString

	classes := Dictionary new.
	fileStream := FileStream read: aString.
	self read; write.
!

methodsForClass: className category: categoryName

	| source stream string |
	stream := WriteStream on: String new.
	(string := fileStream nextLine) isEmpty ifFalse: [self error: 'Unexpected data!!'].
	stream nextPutAll: (fileStream upTo: $!!).
	[
		string := fileStream upTo: $!!.
		string ~= ' '.
	] whileTrue: [
		stream nextPut: $!!; nextPutAll: string.
	].
	source := stream contents.
	(className includes: Character space) ifTrue: [
		(classes at: className subStrings first) classMethod: source category: categoryName.
	] ifFalse: [
		(classes at: className) instanceMethod: source category: categoryName.
	].

!

read

	[
		[fileStream atEnd not] whileTrue: [self chunk: (fileStream upTo: $!!)].
	] ensure: [
		fileStream close.
	].
	classes do: [:each | 
		| parent |
each name = 'Py_int' ifTrue: [self halt].
		parent := classes at: each superclassName ifAbsent: [nil].
		parent ifNotNil: [
			each parent: parent.
			parent addChild: each.
		].
	].
!

write

	| path roots |
	path := FileSaveDialog new
		caption: 'Save as Topaz Script';
		fileTypes: (Array with: #('Topaz Script (*.tpz)' '*.tpz' ) with: #('All Files (*.*)' '*.*' ));
		defaultExtension: 'tpz';
		overwritePrompt;
		showModal.
	path isNil ifTrue: [^self].
	fileStream := FileStream write: path.
	self writeSymbolDictionaries.
	[
		roots := classes select: [:each | each parent isNil].
self halt.
		roots do: [:each | each writeClassTo: fileStream].
		roots do: [:each | each writeMethodsTo: fileStream].
	] ensure: [
		fileStream close.
	].
!

writeSymbolDictionaries

	fileStream nextPutAll: 'set compile_env: 0'; lf.
	(classes collect: [:each | (each packageName subStrings: $-) first]) asSet asSortedCollection do: [:each |
		fileStream
			nextPutAll: '!! ------- Create dictionary if it is not present
run
| aSymbol names userProfile |
aSymbol := #' , each printString , '.
userProfile := System myUserProfile.
names := userProfile symbolList names.
(names includes: aSymbol) ifFalse: [
	| symbolDictionary |
	symbolDictionary := SymbolDictionary new name: aSymbol; yourself.
	userProfile insertDictionary: symbolDictionary at: 1.
].
%
'.
	].
!

writeToPath: aString

	| roots |
	roots := classes select: [:each | each parent isNil].
	roots halt.! !

!FileInPharo categoriesForMethods!
chunk:!public! !
class:instVarNames:!public! !
class:subclass:instVarNames:classVarNames:package:!public! !
commentStamp:!public! !
initialize:!public! !
methodsForClass:category:!public! !
read!public! !
write!public! !
writeSymbolDictionaries!public! !
writeToPath:!public! !
!

!FileInPharo class methodsFor!

path: aString

	^self basicNew
		initialize: aString;
		yourself
! !

!FileInPharo class categoriesForMethods!
path:!public! !
!

