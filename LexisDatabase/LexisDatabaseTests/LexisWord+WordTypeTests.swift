//
//  LexisWord+WordTypeTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
@testable import LexisDatabase
import XCTest

class LexisWord_WordTypeTests: LexisTest
{
    
    var left: WordType!
    var right: WordType!
    
    override func setUp()
    {
        left = Generators.randomWordType
        right = Generators.randomWordType
    }
    
    func testEquals()
    {
        right = left
        XCTAssertTrue(right == left)
    }
    
    
    func testEqualsWhenDifferent()
    {
        while right == left
        {
            right = Generators.randomWordType
        }
        
        XCTAssertFalse(right == left)
    }
    
    
    func testHashCode()
    {
        right = left
        XCTAssertEqual(left.hashValue, right.hashValue)
    }
    
    func testHashCodeWhenDifferent()
    {
        while right == left
        {
            right = Generators.randomWordType
        }
        
        //Technically, two values can have the same hash code, but this should not happen on a small enum
        XCTAssertNotEqual(right.hashValue, left.hashValue)
    }
    
    func testDataSerialization()
    {
        let data: Data! = left.asData
        XCTAssertFalse(data == nil)
        let copy = WordType.from(data: data)
        
        XCTAssertTrue(copy == left)
    }

}
