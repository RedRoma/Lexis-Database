//
//  LexisWord+WordTypeTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import AlchemyTest
import Archeota
import AromaSwiftClient
import Foundation
@testable import LexisDatabase
import XCTest

class LexisWord_WordTypeTests: LexisTest
{
    
    var left: WordType!
    var right: WordType!

    override func beforeEachTest()
    {
        super.beforeEachTest()
        left = Generators.randomWordType
        right = Generators.randomWordType
    }
    
    func testEquals()
    {
        right = left
        assertEquals(right, left)
    }
    
    
    func testEqualsWhenDifferent()
    {
        while right == left
        {
            right = Generators.randomWordType
        }
        
        assertNotEquals(right, left)
    }
    
    
    func testHashCode()
    {
        right = left
        assertEquals(left.hashValue, right.hashValue)
    }
    
    func testHashCodeWhenDifferent()
    {
        while right == left
        {
            right = Generators.randomWordType
        }
        
        //Technically, two values can have the same hash code, but this should not happen on a small enum
        assertNotEquals(right.hashValue, left.hashValue)
    }
    
    func testDataSerialization()
    {
        let data: Data! = left.asData
        assertNotNil(data)
        let copy = WordType.from(data: data)
        
        assertEquals(copy, left)
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
        
        assertNotNil(result)
        assertEquals(result, conjugation)
    }
    
    func testConjugationNamesWithUnknown()
    {
        let randomName = AlchemyGenerator.alphanumericString()
        let result = Conjugation.from(name: randomName)
        assertNil(result)
    }
    
    func testConjugationShortCodes()
    {
        let codes = ["1st", "2nd" , "3rd", "4th"]
        let code = codes.anyElement!
        
        let conjugation = Conjugation.fromShortCode(code: code)
        assertThat(conjugation != .Irregular)
    }
  
    func testConjugationShortCodesWithUnknown()
    {
        let randomCode = AlchemyGenerator.alphanumericString()
        
        let result = Conjugation.fromShortCode(code: randomCode)
        assertThat(result == .Irregular)
    }
    
    func testVerbTypeNames()
    {
        let verbType = Generators.randomVerbType
        let name = verbType.name
        
        let result = VerbType.from(name: name)
        assertNotNil(result)
        assertEquals(result, verbType)
    }
    
    func testVerbTypeNamesWithUnknown()
    {
        let randomName = AlchemyGenerator.alphabeticString()
        let result = VerbType.from(name: randomName)
        assertNil(result)
    }
    
    func testGenderNames()
    {
        let gender = Generators.randomGender
        let name = gender.name
        
        let result = Gender.from(name: name)
        assertNotNil(result)
        assertEquals(result, gender)
    }
    
    func testGenderNamesWithUnknown()
    {
        let randomName = AlchemyGenerator.alphabeticString()
        let result = Gender.from(name: randomName)
        assertNil(result)
    }
    
    func testDeclensionName()
    {
        let declension = Generators.randomDeclension
        let name = declension.name
        
        let result = Declension.from(name: name)
        assertNotNil(result)
        assertEquals(result, declension)
    }
    
    func testDeclensionNameWithUnknown()
    {
        let randomName = AlchemyGenerator.alphabeticString()
        let result = Declension.from(name: randomName)
        assertNil(result)
    }
    
    func testDeclensionShortForms()
    {
        let declension = Generators.randomDeclension
        let shortForm = declension.shortForm
        
        let result = Declension.fromShortCode(code: shortForm)
        
        assertEquals(result, declension)
    }

    func testDeclensionShortFormsWithUnknown()
    {
        let randomShortForm = AlchemyGenerator.alphabeticString()
        let result = Declension.fromShortCode(code: randomShortForm)
        assertThat(result == .Undeclined)
    }
    
    func testCaseTypeNames()
    {
        let caseType = Generators.randomCaseType
        let name = caseType.name
        
        let result = CaseType.from(name: name)
        assertNotNil(result)
        assertEquals(result, caseType)
    }
    
    func testCaseTypeNamesWithUnknown()
    {
        let randomName = AlchemyGenerator.alphanumericString()
        let result = CaseType.from(name: randomName)
        assertNil(result)
    }
    
    func testCaseTypeCodes()
    {
        let codes = [ "NOM", "GEN", "ACC", "DAT", "ABL", "VOC", "LOC" ]
        let code = codes.anyElement!
        
        let result = CaseType.from(shortCode: code)
        assertThat(result != .Unknown)
        
    }
    
    func testCaseTypeCodesWithUnknown()
    {
        let randomCode = AlchemyGenerator.alphabeticString()
        let result = CaseType.from(shortCode: randomCode)
        assertThat(result == .Unknown)
    }

}
