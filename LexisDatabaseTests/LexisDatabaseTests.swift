//
//  LexisDatabaseTests.swift
//  LexisDatabaseTests
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyTest
@testable import LexisDatabase

class LexisDatabaseTests: LexisTest
{
    
    fileprivate let instance = LexisDatabase.instance

    func testGetAnyWord()
    {
        let _ = instance.anyWord
    }
    
    func testSearchForWordsStartingWithTitleCased()
    {
        let term = "Amazon"
        let results = instance.searchForms(startingWith: term)
        assertNotEmpty(results)
        let first = results.first!
        assertThat(first.forms.contains(term))
    }

    func testInitialize()
    {
        instance.initialize()
    }
    
    func testInitializeMultipleTimes()
    {
        repeatTest(Int.random(in: 10...100))
        {
            instance.initialize()
        }
    }
    
    func testInitializeInMultipleThreads()
    {
        let async = OperationQueue()
        async.maxConcurrentOperationCount = 5
        
        repeatTest(Int.random(in: 2...10))
        {
            async.addOperation
            {
                self.instance.initialize()
            }
        }

        async.waitUntilAllOperationsAreFinished()
        print(instance.anyWord)
        
        print("Operations done")
    }
}
