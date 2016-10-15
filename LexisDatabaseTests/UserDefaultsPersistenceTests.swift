//
//  UserDefaultsPersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
@testable import LexisDatabase
import Archeota
import XCTest

class UserDefaultsPersistenceTests: LexisTest
{
    var word = Generators.randomWord
    var words: [LexisWord] = []
    
    var instance: UserDefaultsPersistence!
    
    
    override class func setUp()
    {
        LOG.enable()
        LOG.level = .debug
        
        UserDefaultsPersistence.instance?.removeAll()
    }
    
    override func setUp()
    {
        word = Generators.randomWord
        words = AlchemyGenerator.array() { Generators.randomWord }
        
        instance = UserDefaultsPersistence.instance
        instance.synchronize = true
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
    
    func testSearchForWordsStartingWith()
    {
        try! instance.save(words: words)
        
        word = words.anyElement!
        
        let searchTerm = Functions.half(ofString: word.forms.anyElement!)
        
        let results = instance.searchForWords(startingWith: searchTerm)
        
        XCTAssertFalse(results.isEmpty)
        XCTAssertTrue(results.contains(word))
    }
    
    func testSaveAllWords()
    {
        let allWords = Generators.words
        instance.synchronize = true
        
        try! instance.save(words: allWords)
        
        let result = instance.getAllWords()
        
        let expected = Set(allWords)
        let resultSet = Set(result)
        XCTAssertEqual(resultSet.count, expected.count)
        XCTAssertTrue(resultSet == expected)
    }

}
