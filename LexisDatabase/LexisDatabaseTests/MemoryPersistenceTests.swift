//
//  MemoryPersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/11/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
@testable import LexisDatabase
import XCTest

class MemoryPersistenceTests: XCTestCase
{
    
    var word = Generators.randomWord
    var words: [LexisWord] = []
    
    var instance: MemoryPersistence!
    
    override func setUp()
    {
        word = Generators.randomWord
        words = AlchemyGenerator.array() { Generators.randomWord }
        
        instance = MemoryPersistence()
    }
    
    func testSave()
    {
        try! instance.save(words: [word])
    }
    
    func testSaveWithAFew()
    {
        try! instance.save(words: words)
    }
    
    func testGetAllWordsWhenEmpty()
    {
        let result = instance.getAllWords()
        XCTAssertTrue(result.isEmpty)
    }
    
    func testGetAllWordsWhenNotEmpty()
    {
        try! instance.save(words: words)
        let result = instance.getAllWords()
        XCTAssertTrue(result.notEmpty)
    }
    
    func testSearchForWordsInTerms()
    {
        try! instance.save(words: words)
        
        let anyWord = words.anyElement!
        
        let results = instance.searchForWords(inWordList: anyWord.forms.anyElement!)
        XCTAssertTrue(results.count > 0)
        XCTAssertTrue(results.contains(anyWord))
    }
    
    func testSearchForWordsInTermsWhenEmpty()
    {
        let result = instance.searchForWords(inWordList: word.forms.anyElement!)
        XCTAssertTrue(result.isEmpty)
    }
    
    func testSearchForWordsInDefinition()
    {
        try! instance.save(words: words)
        
        let anyWord = words.anyElement!
        
        let results = instance.searchForWords(inDefinition: anyWord.definitions.anyElement!.terms.anyElement!)
        
        XCTAssertFalse(results.isEmpty)
        XCTAssertTrue(results.contains(anyWord))
    }
    
    func testSearchForWordsInDefinitionWhenEmpty()
    {
        let results = instance.searchForWords(inDefinition: word.definitions.anyElement!.terms.anyElement!)
        
        XCTAssertTrue(results.isEmpty)
    }
}
