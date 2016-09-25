//
//  RegexTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/3/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import LexisDatabase

class RegexTests: XCTestCase
{
    
    var randomLine: String!
    
    override func setUp()
    {
        randomLine = Generators.randomLine
    }
    
    
    func testOperator()
    {
        let results = randomLine =~ Regex.dictionaryCode
    
        XCTAssert(results.notEmpty)
    }
    
}
