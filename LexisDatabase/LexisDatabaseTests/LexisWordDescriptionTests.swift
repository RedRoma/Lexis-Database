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

class LexisWordDescriptionTests: XCTestCase
{
    func testAgeEnum()
    {
        let possibleAges = "X,A,B,C,D,E,F,G,H".components(separatedBy: ",")
        
        let randomCode = AlchemyGenerator.stringFromList(possibleAges)
        
        let age = Age.from(dictionaryCode: randomCode)
        
        XCTAssertNotNil(age)
        print(age!)
    }
    
    func testAgeEnumWithInvalidValue()
    {
        let impossibleAges = "1,2,3,4,T,Y,R,E,V,N".components(separatedBy: ",")
        let randomCode = AlchemyGenerator.stringFromList(impossibleAges)
        
        let age = Age.from(dictionaryCode: randomCode)
        XCTAssert(age == nil, "Expected nil Age")
    }
    
    func testSubjectAreaEnum()
    {
        let possibleAreas = "X,A,B,D,E,G,K,L,P,S,T,W,Y".components(separatedBy: ",")
        let randomCode = AlchemyGenerator.stringFromList(possibleAreas)
        
        let subjectArea = SubjectArea.from(dictionaryCode: randomCode)
        XCTAssertNotNil(subjectArea)
        print(subjectArea!)
    }
    
    func testSubjectAreaEnumWithInvalidValue()
    {
        let impossibleCodes = "1,2,3,4,5,6,7,8,9,0,Q,R,K,Z".components(separatedBy: ",")
        let randomCode = AlchemyGenerator.stringFromList(impossibleCodes)
        
        let subject = SubjectArea.from(dictionaryCode: randomCode)
        XCTAssertNil(subject)
        XCTAssertTrue(subject == nil, "Expected subject to be nil with unknown code: \(randomCode)")
    }
    
    func  testGeographicalAreaEnum()
    {
        let possibleGeographies = "A,B,C,D,E,F,G,H,I,J,K,N,P,Q,R,S,U,X".components(separatedBy: ",")
        
        let randomCode = AlchemyGenerator.stringFromList(possibleGeographies)
        
        let geographicalArea = GeographicalArea.from(dictionaryCode: randomCode)
        
        XCTAssertFalse(geographicalArea == nil)
    }
    
    func testGeographicalAreaAnumWithInvalidValue()
    {
        let impossibleCodes = "1,2,3,4,5,6,7,8,9,0,T,U".components(separatedBy: ",")
        let randomCode = AlchemyGenerator.stringFromList(impossibleCodes)
        
        let geographicalArea = GeographicalArea.from(dictionaryCode: randomCode)
        XCTAssertTrue(geographicalArea == nil)
    }
}
