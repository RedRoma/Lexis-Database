//
//  WebRequestPersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 10/23/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Archeota
import AlchemyGenerator
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
        
        XCTAssertFalse(words.isEmpty)
        XCTAssertTrue(words.count > 30_000)
    }
    
    func testSearchForWordsContaining()
    {
        let searchTerm = word.forms.anyElement!
        
        let results = instance.searchForWordsContaining(term: searchTerm)
        XCTAssertFalse(results.isEmpty)
        XCTAssertTrue(results.contains(word))
    }
    
    func testSearchForWordsStartingWith()
    {
        let searchTerm = word.forms.anyElement!.firstHalf()
        
        let results = instance.searchForWordsContaining(term: searchTerm)
        XCTAssertFalse(results.isEmpty)
        XCTAssertTrue(results.contains(word))
    }
    
    func testSearchForWordsInDefinition()
    {
        
        let searchTerm = word.definitions.anyElement!.terms.anyElement!
        let results = instance.searchForWordsInDefinitions(term: searchTerm)
        
        XCTAssertFalse(results.isEmpty)
        XCTAssertTrue(results.contains(word))
    }
    
    func testSearchInBulk()
    {
        let iterations = 100
        
        for _ in 1...iterations
        {
            let searchTerm = AlchemyGenerator.alphabeticString(ofSize: 3)
            
            let results = instance.searchForWordsContaining(term: searchTerm)
        }
        
    }
   
}
