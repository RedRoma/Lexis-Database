//
//  LexisWordTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/3/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import LexisDatabase

class WordTypeTests: XCTestCase
{
    
    var left: WordType!
    var right: WordType!
    
    override func setUp()
    {
        left = Data.randomWordType
        right = Data.randomWordType
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
            right = Data.randomWordType
        }
        
        XCTAssertFalse(right == left)
    }
    
    
    func testHashCode()
    {
        XCTAssertEqual(left.hashValue, right.hashValue)
    }
    
    
}

class DefinitionTests: XCTestCase
{
    
    private var terms: [String] = arrayOfSize(valueGenerator: alphabeticalStringOfAnySize)
    
    private var definition: LexisDefinition!
    
    override func setUp()
    {
        definition = LexisDefinition(terms: terms)
    }
    
    func testEquatable()
    {
        let secondDefinition = LexisDefinition(terms: terms)
        XCTAssertTrue(secondDefinition == definition)
        XCTAssertEqual(secondDefinition, definition)
    }
    
    func testEquatableWhenDifferent()
    {
        let otherTerms = arrayOfSize(valueGenerator: alphabeticalStringOfAnySize)
        let otherDefinition = LexisDefinition(terms: otherTerms)
        
        XCTAssertFalse(otherDefinition == definition)
        XCTAssertNotEqual(otherDefinition, definition)
    }
    
    func testHashCodeOfSameObject()
    {
        let first = definition.hashValue
        let second = definition.hashValue
        XCTAssertEqual(first, second)
    }
    
    func testHashCodeOfDifferentDefinitions()
    {
        let otherTerms = arrayOfSize(valueGenerator: alphabeticalStringOfAnySize)
        let otherDefinition = LexisDefinition(terms: otherTerms)
        
        let first = definition.hashValue
        let second = otherDefinition.hashValue
        XCTAssertNotEqual(first, second)
    }
    
    func testHashCodeOfDifferentInstanceButSameObject()
    {
        let copy = LexisDefinition(terms: terms)
        
        let first = definition.hashValue
        let second = copy.hashValue
        XCTAssertEqual(first, second)
        XCTAssertTrue(first == second)
    }
}

class LexisWordTests: XCTestCase
{
    
    private var forms: [String] = []
    private var wordType: WordType! = nil
    private var definitions: [LexisDefinition] = []
    
    
    private var randomForms: [String] { return arrayOfSize(valueGenerator: alphabeticalStringOfAnySize) }
    private var randomDefintions: [LexisDefinition]
    {
        let generator: () -> (LexisDefinition) =
        {
            let terms = self.randomForms
            return LexisDefinition(terms: terms)
        }
        
        return arrayOfSize(valueGenerator: generator)
    }
    
    private var word: LexisWord! = nil
    
    override func setUp()
    {
        forms = randomForms
        wordType = Data.randomWordType
        definitions = randomDefintions
        
        word = LexisWord(forms: forms, wordType: wordType, definitions: definitions)
    }
    
    
    func testEquality()
    {
        let shallowCopy = word
        XCTAssertEqual(shallowCopy, word)
        XCTAssertTrue(shallowCopy == word)
        
        let deepCopy = LexisWord(forms: forms, wordType: wordType, definitions: definitions)
        XCTAssertEqual(deepCopy, word)
        XCTAssertTrue(deepCopy == word)
        
    }
    
    func testEqualityWhenDifferent()
    {
        let differentForms = LexisWord(forms: randomForms, wordType: wordType, definitions: definitions)
        XCTAssertTrue(differentForms != word)
        
        let differentWordType = LexisWord(forms: forms, wordType: Data.randomWordType, definitions: definitions)
        XCTAssertTrue(differentWordType != word)
        
        let differentDefinitions = LexisWord(forms: forms, wordType: wordType, definitions: randomDefintions)
        XCTAssertTrue(differentDefinitions != word)
        
    }
}
