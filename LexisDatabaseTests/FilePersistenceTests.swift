//
//  FilePersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/25/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyTest
import Foundation
@testable import LexisDatabase

class FilePersistenceTests: BasePersistenceTests
{
    override func beforeEachTest()
    {
        super.beforeEachTest()

        self.instance = FilePersistence.instance
    }
    
}
