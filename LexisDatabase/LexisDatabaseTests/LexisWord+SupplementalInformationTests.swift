//
//  LexisWord+SupplementalInformationTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
@testable import LexisDatabase
import XCTest

class LexisWord_SupplementalInformationTests: XCTestCase
{
    
    private var information: SupplementalInformation!
    
    override func setUp()
    {
        information = Generators.randomSupplementalInformation
    }
    
    func testEncoding()
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: information)
        XCTAssertFalse(data == nil)
        XCTAssertFalse(data.isEmpty)
        
        let extracted = NSKeyedUnarchiver.unarchiveObject(with: data) as! LexisWord.SupplementalInformation
        
        XCTAssertEqual(extracted, information)
    }
    
    func testDecoding()
    {
        let archive = NSKeyedArchiver.archivedData(withRootObject: information)
        
        let result = NSKeyedUnarchiver.unarchiveObject(with: archive) as? SupplementalInformation
        XCTAssertFalse(result == nil)
    
        XCTAssertEqual(result, information)
    }
}
