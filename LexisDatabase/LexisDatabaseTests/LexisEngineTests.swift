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
    
    override func setUp()
    {
        super.setUp()
        LOG.enable()
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDictionaryCanLoad()
    {
        let text = LexisEngine.instance.readTextFile()
        XCTAssertNotNil(text)
        XCTAssertFalse(text!.isEmpty)
        
        text!.forEachLine() { line in
            
            let wordCode = (line.text =~ LexisEngine.Regex.dictionaryCode)
            print("Line #\(line.number), Code: \(wordCode.first!)")

        }
    }
    
}
