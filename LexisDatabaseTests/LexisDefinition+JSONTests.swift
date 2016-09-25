//
//  LexisDefinition+JSONTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/20/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
@testable import LexisDatabase
import Sulcus
import XCTest

class LexisDefinition_JSONTests: LexisTest
{
    var definition: LexisDefinition!
    var definitions: [LexisDefinition] = []
    
    override func setUp()
    {
        definitions = Generators.randomWord.definitions
        definition = definitions.anyElement!
    }
    
    func testAsJSON()
    {
        let json = definition.asJSON()
        XCTAssertFalse(json == nil)
        XCTAssertTrue(json is NSDictionary)
    }
    
    func testFromJSON()
    {
        let json = definition.asJSON()!
        
        let result = LexisDefinition.fromJSON(json: json)
        XCTAssertFalse(result == nil)
        XCTAssertTrue(result is LexisDefinition)
        
        let copy = result as! LexisDefinition
        XCTAssertTrue(copy == definition)
        
    }
}