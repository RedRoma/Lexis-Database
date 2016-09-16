//
//  LexisWordDescriptionTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/16/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
@testable import LexisDatabase
import XCTest

class LexisWordDescriptionTests: XCTestCase
{
    func testAgeEnum()
    {
        let possibleAges = "X,A,B,C,D,E,F,G,H".components(separatedBy: ",")
        
        let randomCode = possibleAges.anyElement!
        
        let age = Age.from(dictionaryCode: randomCode)
        
        XCTAssertNotNil(age)
        print(age!)
    }
    
    func testAgeEnumWithInvalidValue()
    {
        let impossibleAges = "1,2,3,4,T,Y,R,E,V,N".components(separatedBy: ",")
        let randomCode = impossibleAges.anyElement!
        
        let age = Age.from(dictionaryCode: randomCode)
        XCTAssert(age == nil, "Expected nil Age")
    }
    
    func testSubjectAreaEnum()
    {
        let possibleAreas = "X,A,B,D,E,G,K,P,S,T,W,Y".components(separatedBy: ",")
        let randomCode = possibleAreas.anyElement!
        
        let subjectArea = SubjectArea.from(dictionaryCode: randomCode)
        XCTAssertNotNil(subjectArea)
        print(subjectArea!)
    }
}
