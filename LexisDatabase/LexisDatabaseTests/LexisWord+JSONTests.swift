//
//  LexisWord+JSONTests.swift
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

class LexisWord_JSONTests: LexisTest
{
    var word: LexisWord!
    
    override func setUp()
    {
        super.setUp()
        word = Generators.randomWord
    }
    
    func testAsJSON()
    {
        let json = word.asJSON()
        XCTAssertFalse(json == nil)
        XCTAssertTrue(json is NSDictionary)
    }
    
    func testFromJSON()
    {
        let json = word.asJSON()!
        
        let result = LexisWord.fromJSON(json: json)
        XCTAssertFalse(result == nil)
        XCTAssertTrue(result is LexisWord)
        
        let copy = result as! LexisWord
        XCTAssertTrue(copy == word)
        
    }

}
