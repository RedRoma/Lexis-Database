//
//  SimpleUserDefaultsTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/25/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
@testable import LexisDatabase
import XCTest


class SimpleUserDefaultsPersistenceTests: BasePersistenceTests
{
    
    override func setUp()
    {
        super.setUp()
        
        let persistence = SimpleUserDefaultsPersistence.instance
        persistence?.synchronize = true
        self.instance = persistence
        
    }
}
