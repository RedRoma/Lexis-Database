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
        left = randomWordType
        right = randomWordType
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
            right = randomWordType
        }
        
        XCTAssertFalse(right == left)
    }
    
    
    func testHashCode()
    {
        XCTAssertEqual(left.hashValue, right.hashValue)
    }
    
    var randomWordType: WordType
    {
        let index = randomInteger(from: 0, to: 10)
        
        switch index
        {
            case 0 :
                return WordType.Adjective
            case 1:
                return .Adjective
            case 2:
                return WordType.Conjunction
            case 3:
                return WordType.Interjection
            case 4:
                return WordType.Noun(Declension.Vocative, .Neuter)
            case 5:
                return WordType.Numeral
            case 6:
                return WordType.PersonalPronoun
            case 7:
                return WordType.Preposition(Declension.Ablative)
            default:
                return WordType.Verb(Conjugation.First, .Transitive)
        }
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
