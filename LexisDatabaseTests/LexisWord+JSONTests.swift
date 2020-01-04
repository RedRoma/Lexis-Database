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
import Archeota
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
        assertThat(json is NSDictionary)
    }
    
    func testFromJSON()
    {
        let json = word.asJSON()!
        
        let result = LexisWord.fromJSON(json: json)
        XCTAssertFalse(result == nil)
        assertThat(result is LexisWord)
        
        let copy = result as! LexisWord
        assertThat(copy == word)
        
    }

    
    func testCopyInitializer()
    {
        let new = LexisWord(other: word)
        
        assertThat(new == word)
        XCTAssertFalse(new === word)
    }
    
    func testPublicJSONExport()
    {
        let json = word.json
        
        let expected = word.asJSON() as! NSDictionary
        
        XCTAssertEqual(json, expected)
    }
    
    func testPublicJSONInitializer()
    {
        let json = word.asJSON() as! NSDictionary
        
        let copy = LexisWord(json: json)
        assertThat(copy == word)
    }
    
    func testPublicJSONInitializerWithEmptyJSON()
    {
        let empty = NSDictionary()
        
        let copy = LexisWord(json: empty)
        assertThat(copy == nil)
    }
}
