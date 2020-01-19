//
//  MemoryPersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/11/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyTest
import Foundation
@testable import LexisDatabase

class MemoryPersistenceTests: BasePersistenceTests
{
    override func beforeEachTest()
    {
        super.beforeEachTest()
        instance = MemoryPersistence()
    }
}
