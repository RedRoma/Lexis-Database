//
//  FilePersistenceTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/25/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
@testable import LexisDatabase
import Archeota
import XCTest


class FilePersistenceTests: BasePersistenceTests
{
    
    override func setUp()
    {
        super.setUp()
        
        self.instance = FilePersistence.instance
    }
    
}
