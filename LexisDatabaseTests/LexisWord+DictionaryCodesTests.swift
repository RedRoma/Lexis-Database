//
//  LexisWordDescriptionTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/16/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import AlchemyTest
import Foundation
@testable import LexisDatabase

class LexisWord_DictionaryCodesTests: LexisTest
{
    func testAgeEnum()
    {
        let possibleAges = Age.codes
        let randomCode = AlchemyGenerator.stringFromList(possibleAges)
        
        let age = Age.from(dictionaryCode: randomCode)
        
        assertNotNil(age)
        print(age!)
    }
    
    func testAgeEnumWithInvalidValue()
    {
        let possibleAges = Age.codes
        let impossibleCode = stringNotInList(possibleAges)
        
        let age = Age.from(dictionaryCode: impossibleCode)
        assertNil(age)
    }
    
    func testSubjectAreaEnum()
    {
        let possibleAreas = SubjectArea.codes
        let randomCode = AlchemyGenerator.stringFromList(possibleAreas)
        
        let subjectArea = SubjectArea.from(dictionaryCode: randomCode)
        assertNotNil(subjectArea)
        print(subjectArea!)
    }
    
    func testSubjectAreaEnumWithInvalidValue()
    {
        let possibleAreas = SubjectArea.codes
        let impossibleCode = stringNotInList(possibleAreas)
        
        let subject = SubjectArea.from(dictionaryCode: impossibleCode)
        assertNil(subject)
    }
    
    func  testGeographicalAreaEnum()
    {
        let possibleGeographies = GeographicalArea.codes
        let randomCode = AlchemyGenerator.stringFromList(possibleGeographies)
        
        let geographicalArea = GeographicalArea.from(dictionaryCode: randomCode)
        assertNotNil(geographicalArea)
    }
    
    func testGeographicalAreaAnumWithInvalidValue()
    {
        let possibleGeographies = GeographicalArea.codes
        let impossibleCode = stringNotInList(possibleGeographies)
        
        let geographicalArea = GeographicalArea.from(dictionaryCode: impossibleCode)
        assertNotNil(geographicalArea)
    }
    
    func testFrequencyEnum()
    {
        let possibleFrequencies = Frequency.codes
        let randomCode = AlchemyGenerator.stringFromList(possibleFrequencies)
        
        let frequency = Frequency.from(dictionaryCode: randomCode)
        assertNotNil(frequency)
    }
    
    func testFrequencyEnumWithInvalidCode()
    {
        let possibleFrequencies = Frequency.codes
        let impossibleCode = stringNotInList(possibleFrequencies)
        
        let frequency = Frequency.from(dictionaryCode: impossibleCode)
        assertNil(frequency)
    }
    
    func testSourceEnum()
    {
        let possibleSources = Source.codes
        let randomSource = AlchemyGenerator.stringFromList(possibleSources)
        
        let source = Source.from(dictionaryCode: randomSource)
        assertNotNil(source)
    }
    
    func testSourceEnumWithInvalidCode()
    {
        let possibleSource = Source.codes
        let impossibleCode = stringNotInList(possibleSource)
        
        let source = Source.from(dictionaryCode: impossibleCode)
        assertNil(source)
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
