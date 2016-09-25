//
//  LexisWordDescriptionTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/16/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
@testable import LexisDatabase
import XCTest

class LexisWord_DictionaryCodesTests: LexisTest
{
    func testAgeEnum()
    {
        let possibleAges = Age.codes
        let randomCode = AlchemyGenerator.stringFromList(possibleAges)
        
        let age = Age.from(dictionaryCode: randomCode)
        
        XCTAssertNotNil(age)
        print(age!)
    }
    
    func testAgeEnumWithInvalidValue()
    {
        let possibleAges = Age.codes
        let impossibleCode = stringNotInList(possibleAges)
        
        let age = Age.from(dictionaryCode: impossibleCode)
        XCTAssert(age == nil, "Expected nil Age")
    }
    
    func testSubjectAreaEnum()
    {
        let possibleAreas = SubjectArea.codes
        let randomCode = AlchemyGenerator.stringFromList(possibleAreas)
        
        let subjectArea = SubjectArea.from(dictionaryCode: randomCode)
        XCTAssertNotNil(subjectArea)
        print(subjectArea!)
    }
    
    func testSubjectAreaEnumWithInvalidValue()
    {
        let possibleAreas = SubjectArea.codes
        let impossibleCode = stringNotInList(possibleAreas)
        
        let subject = SubjectArea.from(dictionaryCode: impossibleCode)
        XCTAssertNil(subject)
        XCTAssertTrue(subject == nil, "Expected subject to be nil with unknown code: \(impossibleCode)")
    }
    
    func  testGeographicalAreaEnum()
    {
        let possibleGeographies = GeographicalArea.codes
        let randomCode = AlchemyGenerator.stringFromList(possibleGeographies)
        
        let geographicalArea = GeographicalArea.from(dictionaryCode: randomCode)
        
        XCTAssertFalse(geographicalArea == nil)
    }
    
    func testGeographicalAreaAnumWithInvalidValue()
    {
        let possibleGeographies = GeographicalArea.codes
        let impossibleCode = stringNotInList(possibleGeographies)
        
        let geographicalArea = GeographicalArea.from(dictionaryCode: impossibleCode)
        XCTAssertTrue(geographicalArea == nil)
    }
    
    func testFrequencyEnum()
    {
        let possibleFrequencies = Frequency.codes
        let randomCode = AlchemyGenerator.stringFromList(possibleFrequencies)
        
        let frequency = Frequency.from(dictionaryCode: randomCode)
        XCTAssertFalse(frequency == nil)
    }
    
    func testFrequencyEnumWithInvalidCode()
    {
        let possibleFrequencies = Frequency.codes
        let impossibleCode = stringNotInList(possibleFrequencies)
        
        let frequency = Frequency.from(dictionaryCode: impossibleCode)
        XCTAssertTrue(frequency == nil)
    }
    
    func testSourceEnum()
    {
        let possibleSources = Source.codes
        let randomSource = AlchemyGenerator.stringFromList(possibleSources)
        
        let source = Source.from(dictionaryCode: randomSource)
        XCTAssertFalse(source == nil)
    }
    
    func testSourceEnumWithInvalidCode()
    {
        let possibleSource = Source.codes
        let impossibleCode = stringNotInList(possibleSource)
        
        let source = Source.from(dictionaryCode: impossibleCode)
        XCTAssertTrue(source == nil)
    }
    
    fileprivate func stringNotInList(_ strings: [String]) -> String
    {
        var character = AlchemyGenerator.alphanumericString(ofSize: 1)
        
        while strings.contains(character)
        {
            character = AlchemyGenerator.alphanumericString(ofSize: 1)
        }
        
        return character
    }
}