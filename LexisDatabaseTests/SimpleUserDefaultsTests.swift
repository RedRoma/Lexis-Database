//
//  SimpleUserDefaultsTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/25/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyTest
import Foundation
@testable import LexisDatabase

class SimpleUserDefaultsPersistenceTests: BasePersistenceTests
{
    override func beforeEachTest()
    {
        super.beforeEachTest()

        guard let persistence = SimpleUserDefaultsPersistence.shared else
        {
            XCTFail("Could not initialize SimpleUserDefaultsPersistence")
            return
        }
        
        persistence.synchronize = true
        self.instance = persistence
    }

}
