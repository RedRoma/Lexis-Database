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
    
    override func setUp()
    {
        instance = Generators.randomSupplementalInformation
    }
    
    func testAsJSON()
    {
        let json = instance.asJSON()
        XCTAssertFalse(json == nil)
        assertThat(json is NSDictionary)
    }
    
    func testFromJSON()
    {
        let json = instance.asJSON()!
        
        let result = SupplementalInformation.fromJSON(json: json)
        XCTAssertFalse(result == nil)
        assertThat(result is SupplementalInformation)
        
        let copy = result as! SupplementalInformation
        assertThat(copy == instance)
        
    }
}
