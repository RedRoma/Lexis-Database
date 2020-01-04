//
//  BasePersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 10/23/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//



import AlchemyGenerator
import AlchemyTest
import Archeota
import Foundation
@testable import LexisDatabase

class BasePersistenceTests: LexisTest
{
    var word = Generators.randomWord
    var words: [LexisWord] = []
    
    var instance: LexisPersistence = MemoryPersistence()

    override class func beforeTests()
    {
        super.beforeTests()
        LOG.enable()
        LOG.level = .debug
    }

    override func beforeEachTest()
    {
        super.beforeEachTest()
        word = Generators.randomWord
        words = AlchemyGenerator.array() { Generators.randomWord }
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
        assertThat(stored.isEmpty)
    }
    
    func testGetAllWordsWhenEmpty()
    {
        instance.removeAll()
        let result = instance.getAllWords()
        assertThat(result.isEmpty)
    }
    
    func testGetAllWordsWhenNotEmpty()
    {
        try! instance.save(words: words)
        let result = instance.getAllWords()
        assertThat(result.notEmpty)
    }
    
    func testSearchForWordsInTerms()
    {
        try! instance.save(words: words)
        
        let anyWord = words.anyElement!
        
        let searchTerm = anyWord.forms.anyElement!
        let results = instance.searchForWordsContaining(term: searchTerm)
        assertThat(results.count > 0)
        assertThat(results.contains(anyWord))
    }
    
    func testSearchForWordsInTermsWhenEmpty()
    {
        let searchTerm =  word.forms.anyElement!
        let result = instance.searchForWordsContaining(term: searchTerm)
        assertThat(result.isEmpty)
    }
    
    func testSearchForWordsInDefinition()
    {
        try! instance.save(words: words)
        
        let anyWord = words.anyElement!
        
        let searchTerm = anyWord.definitions.anyElement!.terms.anyElement!
        let results = instance.searchForWordsInDefinitions(term: searchTerm)
        
        assertNotEmpty(results)
        assertThat(results.contains(anyWord))
    }
    
    func testSearchForWordsInDefinitionWhenEmpty()
    {
        let searchTerm = word.definitions.anyElement!.terms.anyElement!
        let results = instance.searchForWordsInDefinitions(term: searchTerm)
        
        assertEmpty(results)
    }
    
    func testSearchForWordsStartingWith()
    {
        try! instance.save(words: words)
        
        word = words.anyElement!
        
        let searchTerm = Functions.half(ofString: word.forms.anyElement!)
        
        let results = instance.searchForWordsStartingWith(term: searchTerm)
        
        assertNotEmpty(results)
        assertThat(results.contains(word))
    }
    
    func testSaveAllWords()
    {
        let allWords = Generators.words
        
        try! instance.save(words: allWords)
        
        let result = instance.getAllWords()
        
        let expected = Set(allWords)
        let resultSet = Set(result)
        assertEquals(resultSet.count, expected.count)
        assertEquals(resultSet, expected)
    }
    
}
