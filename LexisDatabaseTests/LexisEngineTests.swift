    //
//  LexisEngineTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import AlchemyTest
import Archeota
import XCTest
@testable import LexisDatabase

class LexisEngineTests: LexisTest
{
    
    let instance = LexisEngine.instance

    override func beforeEachTest()
    {
        super.beforeEachTest()
        LOG.enable()
        LOG.level = .warn
    }

    func testReadDictionaryFile()
    {
        let text = LexisEngine.instance.readTextFile()
        assertNotNil(text)
        assertNotEmpty(text)
    }
    
    func testInitialize()
    {
        assertNotNil(LexisEngine.instance)
    }
    
    func testGetAllWords()
    {
        let words = instance.getAllWords()
        assertNotEmpty(words)
        assertThat(words.count > 10_000)
    }
    
    func testReadAllWords()
    {
        let words = instance.readAllWords(fromDictionary: Generators.dictionary)
        assertNotEmpty(words)
        assertThat(words.count > 10_000)
    }
    
    
    func testMapLineToWord()
    {
        let line = Generators.randomLine
        let lineNumber = AlchemyGenerator.integer(from: 10, to: 1000)
        
        let result = instance.mapLineToWord(line: line, at: lineNumber)
        assertNotNil(result)
        assertNotEmpty(result!.definitions)
        assertNotEmpty(result!.forms)
    }
    
    func testExtractWords()
    {
        
        let totalWords = AlchemyGenerator.integer(from: 10, to: 100)
        let words = AlchemyGenerator.array(ofSize: totalWords) { AlchemyGenerator.Strings.alphabetic }
        
        var testWord = words.joined(separator: ", ")
        //These extra additions are necessary to match the dictionary format.
        //Otherwise the regex won't match.
        testWord = "#" + testWord + "   "
        
        let result = instance.extractWords(from: testWord)
        assertEquals(result, words)
    }

}
