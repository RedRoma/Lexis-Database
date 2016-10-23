//
//  MemoryPersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/11/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
@testable import LexisDatabase
import XCTest

class MemoryPersistenceTests: BasePersistenceTests
{
    
    override func setUp()
    {
        super.setUp()
        instance = MemoryPersistence()
    }
}
