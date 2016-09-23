//
//  LexisDatabaseTests.swift
//  LexisDatabaseTests
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import XCTest
@testable import LexisDatabase

class LexisDatabaseTests: LexisTest
{
    
    fileprivate let instance = LexisDatabase.instance
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testGetAllWords()
    {
        let _ = instance.anyWord
    }
    

    func testInitialize()
    {
        instance.initialize()
    }
    
    func testInitializeMultipleTimes()
    {
        for _ in 1...100
        {
            instance.initialize()
        }
    }
    
}
