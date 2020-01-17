//
//  LexisWordTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/3/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import AlchemyTest
import Foundation
import XCTest
@testable import LexisDatabase


class LexisDefinitionTests: LexisTest
{
    
    private var terms: [String] = AlchemyGenerator.array()
    {
        AlchemyGenerator.Strings.alphabetic
    }
    
    private var definition: LexisDefinition!

    override func beforeEachTest()
    {
        super.beforeEachTest()
        definition = LexisDefinition(terms: terms)
    }
    
    func testEquatable()
    {
        let secondDefinition = LexisDefinition(terms: terms)
        assertEquals(secondDefinition, definition)
    }
    
    func testEquatableWhenDifferent()
    {
        let otherTerms = AlchemyGenerator.Arrays.ofString
        let otherDefinition = LexisDefinition(terms: otherTerms)
        
        assertNotEquals(otherDefinition, definition)
    }
    
    func testHashCodeOfSameObject()
    {
        let first = definition.hashValue
        let second = definition.hashValue
        assertEquals(first, second)
    }
    
    func testHashCodeOfDifferentDefinitions()
    {
        let otherTerms = AlchemyGenerator.Arrays.ofAlphabeticString
        let otherDefinition = LexisDefinition(terms: otherTerms)
        
        let first = definition.hashValue
        let second = otherDefinition.hashValue
        assertNotEquals(first, second)
    }
    
    func testHashCodeOfDifferentInstanceButSameObject()
    {
        let copy = LexisDefinition(terms: terms)
        
        let first: Int = definition.hash
        let second: Int = copy.hash
        assertEquals(first, second)
    }
    
    func testCoding()
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: definition!)
        
        let extracted: LexisDefinition! = NSKeyedUnarchiver.unarchiveObject(with: data) as? LexisDefinition
        assertEquals(extracted, definition)
    }
}

class LexisWordTests: XCTestCase
{
    
    private var forms: [String] = []
    private var wordType: WordType! = nil
    private var definitions: [LexisDefinition] = []
    private var supplementalInfo: SupplementalInformation!
    
    private var randomForms: [String] { AlchemyGenerator.Arrays.ofAlphabeticString }
    private var randomDefinitions: [LexisDefinition]
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
        word =  Generators.randomWord
        forms = word.forms
        wordType = word.wordType
        definitions = word.definitions
        supplementalInfo = word.supplementalInformation
    }
    
    func testEquality()
    {
        let shallowCopy = word
        assertEquals(shallowCopy, word)
        
        let deepCopy = LexisWord(forms: forms, wordType: wordType, definitions: definitions, supplementalInformation: supplementalInfo)
        assertThat(deepCopy == word)
    }
    
    func testEqualityWhenDifferent()
    {
        let differentForms = LexisWord(forms: randomForms, wordType: wordType, definitions: definitions, supplementalInformation: supplementalInfo)
        assertThat(differentForms != word)
        
        var differentWordType = LexisWord(forms: forms, wordType: Generators.randomWordType, definitions: definitions, supplementalInformation: supplementalInfo)
        
        while differentWordType == word
        {
            differentWordType = LexisWord(forms: forms, wordType: Generators.randomWordType, definitions: definitions, supplementalInformation: supplementalInfo)
        }
        
        assertNotEquals(differentWordType, word)
        
        let differentDefinitions = LexisWord(forms: forms, wordType: wordType, definitions: randomDefinitions, supplementalInformation: supplementalInfo)
        assertNotEquals(differentDefinitions, word)
    }
    
    func testHashCodeWhenSame()
    {
        let copy = LexisWord(forms: forms, wordType: wordType, definitions: definitions, supplementalInformation: supplementalInfo)
        let first: Int = word.hash
        let second: Int = copy.hash
        assertEquals(first, second)
    }
    
    func testHashCodeWhenDifferent()
    {
        let other = LexisWord(forms: randomForms, wordType: Generators.randomWordType, definitions: randomDefinitions, supplementalInformation: supplementalInfo)
        let first = word.hashValue
        let second = other.hashValue
        
        assertNotEquals(first, second)
    }

    func testNSCoding()
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: word)
        XCTAssertFalse(data.isEmpty)
        
        let extracted: LexisWord! = NSKeyedUnarchiver.unarchiveObject(with: data) as? LexisWord

        assertEquals(extracted, word)
    }

}
