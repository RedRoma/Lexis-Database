//
//  SupplementalInformation_JSON.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/20/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
@testable import LexisDatabase
import Archeota
import XCTest

class SupplementalInformation_JSONTests: LexisTest
{
    var instance: SupplementalInformation!
    
    let serializer = BasicJSONSerializer.instance
    
    override func setUp()
    {
        instance = Generators.randomSupplementalInformation
    }
    
    func testAsJSON()
    {
        let json = instance.asJSON()
        XCTAssertFalse(json == nil)
        XCTAssertTrue(json is NSDictionary)
        
        let serialized: String! = instance.asJSONString(serializer: serializer)
        XCTAssertFalse(serialized == nil)
        XCTAssertTrue(serialized.notEmpty)
    }
    
    func testFromJSON()
    {
        let json = instance.asJSON()!
        
        let result = SupplementalInformation.fromJSON(json: json)
        XCTAssertFalse(result == nil)
        XCTAssertTrue(result is SupplementalInformation)
        
        let copy = result as! SupplementalInformation
        XCTAssertTrue(copy == instance)
        
    }
    
    func testJSONDeserialization()
    {
        let jsonString: String! = instance.asJSONString(serializer: serializer)
        XCTAssertFalse(jsonString == nil)
        XCTAssertTrue(jsonString.notEmpty)
        
        let dictionary = serializer.fromJSON(jsonString: jsonString)
        XCTAssertTrue(dictionary != nil)
        XCTAssertTrue(dictionary is NSDictionary)
        
        let result: SupplementalInformation! = SupplementalInformation.fromJSON(json: dictionary!) as! SupplementalInformation!
        XCTAssertFalse(result == nil)
        
        XCTAssertTrue(result == instance)
    }
}
