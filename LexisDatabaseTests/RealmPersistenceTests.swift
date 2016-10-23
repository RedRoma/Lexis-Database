//
//  RealmPersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 10/22/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Archeota
import Foundation
@testable import LexisDatabase
import RealmSwift
import XCTest

class RealmPersistenceTests: BasePersistenceTests
{
    
    override class func setUp()
    {
        super.setUp()
        
        Realm.deleteDatabase()
        
    }
    
    override func setUp()
    {
        super.setUp()
        
        self.instance = RealmPersistence.instance
    }
}

extension RealmPersistenceTests
{
    
    func testWordPersistence()
    {
        let word = Generators.randomWord
        
        let realmWord: RealmWord! = RealmWord.from(lexisWord: word)
        XCTAssertFalse(realmWord == nil)
        
        let result = realmWord.asLexisWord
        
        XCTAssertTrue(result == word)
    }
}
