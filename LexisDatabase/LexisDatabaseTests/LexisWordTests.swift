//
//  LexisWordTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/3/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
import XCTest
@testable import LexisDatabase

class WordTypeTests: XCTestCase
{
    
    var left: WordType!
    var right: WordType!
    
    override func setUp()
    {
        left = Generators.randomWordType
        right = Generators.randomWordType
    }
    
    func testEquals()
    {
        right = left
        XCTAssertTrue(right == left)
    }
    
    
    func testEqualsWhenDifferent()
    {
        while right == left
        {
            right = Generators.randomWordType
        }
        
        XCTAssertFalse(right == left)
    }
    
    
    func testHashCode()
    {
        right = left
        XCTAssertEqual(left.hashValue, right.hashValue)
    }
    
    func testHashCodeWhenDifferent()
    {
        while right == left
        {
            right = Generators.randomWordType
        }
        
        //Technically, two values can have the same hash code, but this should not happen on a small enum
        XCTAssertNotEqual(right.hashValue, left.hashValue)
    }
    
}

class DefinitionTests: XCTestCase
{
    
    private var terms: [String] = AlchemyGenerator.array() { return AlchemyGenerator.Strings.alphabetic }
    
    private var definition: LexisDefinition!
    
    override func setUp()
    {
        definition = LexisDefinition(terms: terms)
    }
    
    func testEquatable()
    {
        let secondDefinition = LexisDefinition(terms: terms)
        XCTAssertTrue(secondDefinition == definition)
    }
    
    func testEquatableWhenDifferent()
    {
        let otherTerms = AlchemyGenerator.Arrays.ofString
        let otherDefinition = LexisDefinition(terms: otherTerms)
        
        XCTAssertFalse(otherDefinition == definition)
    }
    
    func testHashCodeOfSameObject()
    {
        let first = definition.hashValue
        let second = definition.hashValue
        XCTAssertTrue(first == second)
    }
    
    func testHashCodeOfDifferentDefinitions()
    {
        let otherTerms = AlchemyGenerator.Arrays.ofAlphabeticString
        let otherDefinition = LexisDefinition(terms: otherTerms)
        
        let first = definition.hashValue
        let second = otherDefinition.hashValue
        XCTAssertFalse(first == second)
    }
    
    func testHashCodeOfDifferentInstanceButSameObject()
    {
        let copy = LexisDefinition(terms: terms)
        
        let first = definition.hashValue
        let second = copy.hashValue
        XCTAssertTrue(first == second)
    }
    
    func testCoding()
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: definition)
        
        let extracted: LexisDefinition! = NSKeyedUnarchiver.unarchiveObject(with: data) as? LexisDefinition
        
        XCTAssertTrue(extracted == definition)
    }
}

class LexisWordTests: XCTestCase
{
    
    private var forms: [String] = []
    private var wordType: WordType! = nil
    private var definitions: [LexisDefinition] = []
    
    
    private var randomForms: [String] { return AlchemyGenerator.Arrays.ofAlphabeticString }
    private var randomDefintions: [LexisDefinition]
    {
        let generator: () -> (LexisDefinition) =
        {
            let terms = self.randomForms
            return LexisDefinition(terms: terms)
        }
        
        return AlchemyGenerator.array(withCreator: generator)
    }
    
    private var word: LexisWord! = nil
    
    override func setUp()
    {
        forms = randomForms
        wordType = Generators.randomWordType
        definitions = randomDefintions
        
        word = LexisWord(forms: forms, wordType: wordType, definitions: definitions)
    }
    
    
    func testEquality()
    {
        let shallowCopy = word
        XCTAssertTrue(shallowCopy == word)
        
        let deepCopy = LexisWord(forms: forms, wordType: wordType, definitions: definitions)
        XCTAssertTrue(deepCopy == word)
        
    }
    
    func testEqualityWhenDifferent()
    {
        let differentForms = LexisWord(forms: randomForms, wordType: wordType, definitions: definitions)
        XCTAssertTrue(differentForms != word)
        
        var differentWordType = LexisWord(forms: forms, wordType: Generators.randomWordType, definitions: definitions)
        
        while differentWordType == word
        {
            differentWordType = LexisWord(forms: forms, wordType: Generators.randomWordType, definitions: definitions)
        }
        
        XCTAssertTrue(differentWordType != word)
        
        let differentDefinitions = LexisWord(forms: forms, wordType: wordType, definitions: randomDefintions)
        XCTAssertTrue(differentDefinitions != word)
        
    }
    
    func testHashCodeWhenSame()
    {
        let copy = LexisWord(forms: forms, wordType: wordType, definitions: definitions)
        let first = word.hashValue
        let second = copy.hashValue
        XCTAssertTrue(first == second)
    }
    
    func testHashCodeWhenDifferent()
    {
        let other = LexisWord(forms: randomForms, wordType: Generators.randomWordType, definitions: randomDefintions)
        let first = word.hashValue
        let second = other.hashValue
        
        XCTAssertFalse(first == second)
    }
}
