//
//  WebRequestPersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 10/23/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Archeota
import AlchemyGenerator
import AlchemyTest
import Foundation
@testable import LexisDatabase
import XCTest

class WebRequestPersistenceTests: LexisTest
{
    private let instance = WebRequestPersistence()
    
    private var word = Generators.words.anyElement!
    
    override func setUp()
    {
        super.setUp()
        
        word = Generators.words.anyElement!
    }
    
    func testGetAllWords()
    {
        let words = instance.getAllWords()
        assertNotEmpty(words)
        assertThat(words.count > 30_000)
    }
    
    func testSearchForWordsContaining()
    {
        let searchTerm = word.forms.anyElement!
        
        let results = instance.searchForWordsContaining(term: searchTerm)
        assertNotEmpty(results)
        assertThat(results.contains(word))
    }
    
    func testSearchForWordsStartingWith()
    {
        let searchTerm = word.forms.anyElement!.firstHalf()
        
        let results = instance.searchForWordsContaining(term: searchTerm)
        assertNotEmpty(results)
        assertThat(results.contains(word))
    }
    
    func testSearchForWordsInDefinition()
    {
        
        let searchTerm = word.definitions.anyElement!.terms.anyElement!
        let results = instance.searchForWordsInDefinitions(term: searchTerm)
        
        assertNotEmpty(results)
        assertThat(results.contains(word))
    }
    
    func testSearchInBulk()
    {
        let start = Date()
        repeatTest(100)
        {
            let searchTerm = AlchemyGenerator.alphabeticString(ofSize: 3)
            
            _ = instance.searchForWordsContaining(term: searchTerm)
        }
        
        let latency = abs(start.timeIntervalSinceNow)
        LOG.info("\(iterations) searches too \(latency) seconds")
        
    }
    
    func testGetAnyWord()
    {
        let start = Date()
        repeatTest(100)
        {
            let word = instance.getAnyWord()
            assertNotNil(word)
        }
        
        let latency = abs(start.timeIntervalSinceNow)
        LOG.info("\(iterations) searches too \(latency) seconds")
    }
   
}
