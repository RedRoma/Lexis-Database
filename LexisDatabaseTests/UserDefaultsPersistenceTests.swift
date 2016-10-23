//
//  UserDefaultsPersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
@testable import LexisDatabase
import Archeota
import XCTest

class UserDefaultsPersistenceTests: BasePersistenceTests
{
  
    override func setUp()
    {
        super.setUp()
        
        let persistence = UserDefaultsPersistence.instance
        persistence?.synchronize = true
        self.instance = persistence
        
    }

}
