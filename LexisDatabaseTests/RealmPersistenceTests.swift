//
//  RealmPersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 10/22/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
@testable import LexisDatabase
import XCTest

class RealmPersistenceTests: BasePersistenceTests
{
    
    override func setUp()
    {
        super.setUp()
        
        self.instance = RealmPersistence.instance
    }
}
