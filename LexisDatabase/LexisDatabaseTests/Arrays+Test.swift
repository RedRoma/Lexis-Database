//
//  Arrays+Test.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/2/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import XCTest
@testable import LexisDatabase

class Arrays_Plus_Test: XCTestCase
{
    
    let numbers = allIntegers(from: 1, to: 1000)
    
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
        let subArray = AlchemyGenerator.array() { return AlchemyGenerator.integer(from: 10, to: 500) }
        XCTAssertTrue(numbers.containsMultiple(subArray))
    }
    
    func testSplit()
    {
        let array = AlchemyGenerator.array(withCreator: AlchemyGenerator.positiveInteger)
        let split = splitInTwo(array: array)
        
        let first = split[0]
        let second = split[1]
        
        let result = array.split(into: 2)
        XCTAssertTrue(result.count == 2)
        
        let firstResult = result[0]
        let secondResult = result[1]
        XCTAssertTrue(firstResult == first)
        XCTAssertTrue(secondResult == second)
        
    }
    
    func testSplitMoreThoroughly()
    {
        
        for _ in 1...200
        {
            let numbers = AlchemyGenerator.array(withCreator: AlchemyGenerator.positiveInteger)
            let splitCount = AlchemyGenerator.integer(from: 2, to: numbers.count - 1)
            
            let result = numbers.split(into: splitCount)
            XCTAssertFalse(result.isEmpty)
            
            if result.count != splitCount
            {
                XCTFail("Expected \(splitCount) in Array. Instead \(result.count)")
            }
        }
    }
    
    private func splitInTwo(array: [Int]) -> [[Int]]
    {
        
        let start = 0
        let mid = array.count / 2
        let end = array.count
        
        let first = Array(array[start..<mid])
        let second = Array(array[mid..<end])
        
        return [first, second]
    }
}
