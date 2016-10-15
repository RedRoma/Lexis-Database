//
//  LexisWord+WordTypeTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import AromaSwiftClient
import Foundation
@testable import LexisDatabase
import XCTest

class LexisWord_WordTypeTests: LexisTest
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
    
    func testDataSerialization()
    {
        let data: Data! = left.asData
        XCTAssertFalse(data == nil)
        let copy = WordType.from(data: data)
        
        XCTAssertTrue(copy == left)
    }

    
}


//MARK: Enum Tests
extension LexisWord_WordTypeTests
{
    func testConjugationNames()
    {
        let conjugation = Generators.randomConjugation
        let name = conjugation.name
        
        let result = Conjugation.from(name: name)
        
        XCTAssertFalse(result == nil)
        XCTAssertTrue(result == conjugation)
    }
    
    func testConjugationNamesWithUnknown()
    {
        let randomName = AlchemyGenerator.alphanumericString()
        let result = Conjugation.from(name: randomName)
        XCTAssertTrue(result == nil)
    }
    
    func testConjugationShortCodes()
    {
        let codes = ["1st", "2nd" , "3rd", "4th"]
        let code = codes.anyElement!
        
        let conjugation = Conjugation.fromShortCode(code: code)
        XCTAssertTrue(conjugation != .Irregular)
    }
  
    func testConjugationShortCodesWithUnknown()
    {
        let randomCode = AlchemyGenerator.alphanumericString()
        
        let result = Conjugation.fromShortCode(code: randomCode)
        XCTAssertTrue(result == .Irregular)
    }
    
    func testVerbTypeNames()
    {
        let verbType = Generators.randomVerbType
        let name = verbType.name
        
        let result = VerbType.from(name: name)
        XCTAssertFalse(result == nil)
        XCTAssertTrue(result == verbType)
    }
    
    func testVerbTypeNamesWithUnknown()
    {
        let randomName = AlchemyGenerator.alphabeticString()
        let result = VerbType.from(name: randomName)
        XCTAssertTrue(result == nil)
    }
    
    func testGenderNames()
    {
        let gender = Generators.randomGender
        let name = gender.name
        
        let result = Gender.from(name: name)
        XCTAssertFalse(result == nil)
        XCTAssertTrue(result == gender)
    }
    
    func testGenderNamesWithUnknown()
    {
        let randomName = AlchemyGenerator.alphabeticString()
        let result = Gender.from(name: randomName)
        XCTAssertTrue(result == nil)
    }
    
    func testDeclensionName()
    {
        let declension = Generators.randomDeclension
        let name = declension.name
        
        let result = Declension.from(name: name)
        XCTAssertFalse(result == nil)
        XCTAssertTrue(result == declension)
    }
    
    func testDeclensionNameWithUnknown()
    {
        let randomName = AlchemyGenerator.alphabeticString()
        let result = Declension.from(name: randomName)
        XCTAssertTrue(result == nil)
    }
    
    func testDeclensionShortForms()
    {
        let declension = Generators.randomDeclension
        let shortForm = declension.shortForm
        
        let result = Declension.fromShortCode(code: shortForm)
        
        XCTAssertTrue(result == declension)
    }
    
    func testDeclensionShortFormsWithUnknown()
    {
        let randomShortForm = AlchemyGenerator.alphabeticString()
        let result = Declension.fromShortCode(code: randomShortForm)
        XCTAssertTrue(result == .Undeclined)
    }
    
    func testCaseTypeNames()
    {
        let caseType = Generators.randomCaseType
        let name = caseType.name
        
        let result = CaseType.from(name: name)
        XCTAssertFalse(result == nil)
        XCTAssertTrue(result == caseType)
    }
    
    func testCaseTypeNamesWithUnknown()
    {
        let randomName = AlchemyGenerator.alphanumericString()
        let result = CaseType.from(name: randomName)
        XCTAssertTrue(result == nil)
    }
    
    func testCaseTypeCodes()
    {
        let caseType = Generators.randomCaseType
        let codes = [ "NOM", "GEN", "ACC", "DAT", "ABL", "VOC", "LOC" ]
        let code = codes.anyElement!
        
        let result = CaseType.from(shortCode: code)
        XCTAssertTrue(result == caseType)
    }
    
    func testCaseTypeCodesWithUnknown()
    {
        let randomCode = AlchemyGenerator.alphabeticString()
        let result = CaseType.from(shortCode: randomCode)
        XCTAssertTrue(result == .Unknown)
    }
}
