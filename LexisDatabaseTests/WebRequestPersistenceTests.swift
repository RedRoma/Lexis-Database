//
//  WebRequestPersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 10/23/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Archeota
import Foundation
@testable import LexisDatabase
import XCTest

class WebRequestPersistenceTests: LexisTest
{
    private let instance = WebRequestPersistence()
    
    override func setUp()
    {
        super.setUp()
    }
    
    func testGetAllWords()
    {
        let words = instance.getAllWords()
        
        XCTAssertFalse(words.isEmpty)
        XCTAssertTrue(words.count > 30_000)
    }
}
