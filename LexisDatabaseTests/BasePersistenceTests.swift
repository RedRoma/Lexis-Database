//
//  BasePersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 10/23/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//



import AlchemyGenerator
import Foundation
@testable import LexisDatabase
import Archeota
import XCTest


class BasePersistenceTests: LexisTest
{
    var word = Generators.randomWord
    var words: [LexisWord] = []
    
    static var instance: LexisPersistence!
    var instance: LexisPersistence!
    
    override class func setUp()
    {
        LOG.enable()
        LOG.level = .debug
        instance = MemoryPersistence()
    }
    
    override func setUp()
    {
        word = Generators.randomWord
        words = AlchemyGenerator.array() { Generators.randomWord }
        
        instance = BasePersistenceTests.instance
        instance.removeAll()
    }
    
    
    override func tearDown()
    {
        instance.removeAll()
    }
    
    func testSave()
    {
        try! instance.save(words: [word])
    }
    
    func testSaveWithAFew()
    {
        try! instance.save(words: words)
    }
    
    func testRemoveAll()
    {
        try! instance.save(words: words)
        instance.removeAll()
        
        let stored = instance.getAllWords()
        XCTAssertTrue(stored.isEmpty)
    }
    
    func testGetAllWordsWhenEmpty()
    {
        instance.removeAll()
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
        
        let searchTerm = anyWord.forms.anyElement!
        let results = instance.searchForWordsContaining(term: searchTerm)
        XCTAssertTrue(results.count > 0)
        XCTAssertTrue(results.contains(anyWord))
    }
    
    func testSearchForWordsInTermsWhenEmpty()
    {
        let searchTerm =  word.forms.anyElement!
        let result = instance.searchForWordsContaining(term: searchTerm)
        XCTAssertTrue(result.isEmpty)
    }
    
    func testSearchForWordsInDefinition()
    {
        try! instance.save(words: words)
        
        let anyWord = words.anyElement!
        
        let searchTerm = anyWord.definitions.anyElement!.terms.anyElement!
        let results = instance.searchForWordsInDefinitions(term: searchTerm)
        
        XCTAssertFalse(results.isEmpty)
        XCTAssertTrue(results.contains(anyWord))
    }
    
    func testSearchForWordsInDefinitionWhenEmpty()
    {
        let searchTerm = word.definitions.anyElement!.terms.anyElement!
        let results = instance.searchForWordsInDefinitions(term: searchTerm)
        
        XCTAssertTrue(results.isEmpty)
    }
    
    func testSearchForWordsStartingWith()
    {
        try! instance.save(words: words)
        
        word = words.anyElement!
        
        let searchTerm = Functions.half(ofString: word.forms.anyElement!)
        
        let results = instance.searchForWordsStartingWith(term: searchTerm)
        
        XCTAssertFalse(results.isEmpty)
        XCTAssertTrue(results.contains(word))
    }
    
    func testSaveAllWords()
    {
        let allWords = Generators.words
        
        try! instance.save(words: allWords)
        
        let result = instance.getAllWords()
        
        let expected = Set(allWords)
        let resultSet = Set(result)
        XCTAssertEqual(resultSet.count, expected.count)
        XCTAssertTrue(resultSet == expected)
    }
    
}
