//
//  LexisWord+JSONTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/20/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import AlchemyTest
import Archeota
import Foundation
@testable import LexisDatabase

class LexisWord_JSONTests: LexisTest
{
    var word: LexisWord!

    override func beforeEachTest()
    {
        super.beforeEachTest()
        word = Generators.randomWord
    }
    
    func testAsJSON()
    {
        let json = word.asJSON()
        assertNotNil(json)
        assertThat(json is NSDictionary)
    }
    
    func testFromJSON()
    {
        let json = word.asJSON()!
        
        let result = LexisWord.fromJSON(json: json)
        assertNotNil(result)
        assertThat(result is LexisWord)
        
        let copy = result as! LexisWord
        assertEquals(copy, word)
    }
    
    func testCopyInitializer()
    {
        let new = LexisWord(other: word)
        
        assertEquals(new, word)
        assertFalse(new === word)
    }
    
    func testPublicJSONExport()
    {
        let json = word.json
        
        let expected = word.asJSON() as! NSDictionary
        
        assertEquals(json, expected)
    }
    
    func testPublicJSONInitializer()
    {
        let json = word.asJSON() as! NSDictionary
        
        let copy = LexisWord(json: json)
        assertEquals(copy, word)
    }
    
    func testPublicJSONInitializerWithEmptyJSON()
    {
        let empty = NSDictionary()
        
        let copy = LexisWord(json: empty)
        assertNil(copy)
    }

}
