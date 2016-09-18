//
//  LexisDatabaseTests.swift
//  LexisDatabaseTests
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import XCTest
@testable import LexisDatabase

class LexisDatabaseTests: XCTestCase {
    
    fileprivate let instance = LexisDatabase.instance
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    

    func testInitialize()
    {
        instance.initialize()
    }
    
}
