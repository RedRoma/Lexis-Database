    //
//  LexisEngineTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Sulcus
import XCTest
@testable import LexisDatabase

class LexisEngineTests: XCTestCase
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

    func testDictionaryFileCanLoad()
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
        let words = instance.readAllWords(fromDictionary: Data.dictionary)
        XCTAssert(words.notEmpty)
        XCTAssert(words.count > 10_000)
    }
    
}
