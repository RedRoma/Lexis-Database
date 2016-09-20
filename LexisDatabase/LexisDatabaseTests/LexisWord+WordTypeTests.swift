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

class LexisWord_WordTypeTests: XCTestCase
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
    
    func testAsJSON()
    {
        var json = WordType.Adjective.asJSON()!
        var data = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        json = WordType.Adverb.asJSON
        data = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        json = WordType.Noun(Declension.Accusative, Gender.Female).asJSON
        data = try! JSONSerialization.data(withJSONObject: json, options: [])
    }
    
    func testDataSerialization()
    {
        let data = left.asData!
        let copy = WordType.from(data: data)
        
        XCTAssertTrue(copy == left)
    }

    
    func testJsonSerialization()
    {
        let json = left.asJSON()
        XCTAssertTrue(json is NSDictionary)
        let dictionary = json as! NSDictionary
        
        let object = WordType.fromJSON(json: dictionary)
        XCTAssertFalse(object == nil)
        XCTAssertTrue(object is WordType)
        
        let copy = object as! WordType
        XCTAssertTrue(copy == left)
    }
}
