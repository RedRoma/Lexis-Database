//
//  Arrays+Test.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/2/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import XCTest
@testable import LexisDatabase

class Arrays_Test: XCTestCase
{
    
    let numbers = arrayOfNumbers(from: 1, to: 1000)
    
    override func setUp()
    {
        super.setUp()
        
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testSecond()
    {
        let expected = numbers[1]
        let result = numbers.second!
        XCTAssertEqual(result, expected)
    }
    
    func testContainsMultiple()
    {
        let subArray = arrayOfNumbers(from: 10, to: 500)
        XCTAssertTrue(numbers.containsMultiple(subArray))
    }
    
    
}
