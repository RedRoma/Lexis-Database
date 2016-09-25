    //
//  LexisEngineTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Sulcus
import XCTest
@testable import LexisDatabase

class LexisEngineTests: LexisTest
{
    
    let instance = LexisEngine.instance
    
    override func setUp()
    {
        super.setUp()
        LOG.enable()
        LOG.level = .warn
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testReadDictionaryFile()
    {
        let text = LexisEngine.instance.readTextFile()
        XCTAssertNotNil(text)
        XCTAssertFalse(text!.isEmpty)
    }
    
    func testInitialize()
    {
        XCTAssertNotNil(LexisEngine.instance)
    }
    
    func testGetAllWords()
    {
        let words = instance.getAllWords()
        XCTAssert(words.notEmpty)
        XCTAssert(words.count > 10_000)
    }
    
    func testReadAllWords()
    {
        let words = instance.readAllWords(fromDictionary: Generators.dictionary)
        XCTAssert(words.notEmpty)
        XCTAssert(words.count > 10_000)
    }
    
    
    func testMapLineToWord()
    {
        let line = Generators.randomLine
        let lineNumber = AlchemyGenerator.integer(from: 10, to: 1000)
        
        let result = instance.mapLineToWord(line: line, at: lineNumber)
        XCTAssertNotNil(result)
        XCTAssert(result!.definitions.notEmpty)
        XCTAssert(result!.forms.notEmpty)
        
    }
    
    func testExtractWords()
    {
        
        let totalWords = AlchemyGenerator.integer(from: 10, to: 100)
        let words = AlchemyGenerator.array(ofSize: totalWords) { AlchemyGenerator.Strings.alphabetic }
        
        var testWord = words.joined(separator: ", ")
        //These extra additionas are necessary to match the dictionary format.
        //Otherwise the regex won't match.
        testWord = "#" + testWord + "   "
        
        let result = instance.extractWords(from: testWord)
        XCTAssertEqual(result, words)
        
    }
}
