//
//  UserDefaultsPersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyTest
import Foundation
@testable import LexisDatabase

class UserDefaultsPersistenceTests: BasePersistenceTests
{
    override func beforeEachTest()
    {
        super.beforeEachTest()

        guard let persistence = UserDefaultsPersistence.instance else
        {
            XCTFail("Could not initialize UserDefaultsPersistence")
            return
        }
        
        persistence.synchronize = true
        self.instance = persistence
        
    }
    
}
