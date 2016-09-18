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
    
    private var instance: SupplementalInformation!
    
    override func setUp()
    {
        instance = Generators.randomSupplementalInformation
    }
    
    func testEncoding()
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: instance)
        XCTAssertFalse(data.isEmpty)
        
        let extracted: SupplementalInformation! = NSKeyedUnarchiver.unarchiveObject(with: data) as! LexisWord.SupplementalInformation
        
        XCTAssertTrue(extracted == instance)
    }
    
    func testDecoding()
    {
        let archive = NSKeyedArchiver.archivedData(withRootObject: instance)
        
        let result: SupplementalInformation! = NSKeyedUnarchiver.unarchiveObject(with: archive) as? SupplementalInformation
        XCTAssertFalse(result == nil)
    
        XCTAssertTrue(result == instance)
    }
    
    func testEqualsFunction()
    {
        let archive = NSKeyedArchiver.archivedData(withRootObject: instance)
        
        let copy = NSKeyedUnarchiver.unarchiveObject(with: archive) as! SupplementalInformation
        
        XCTAssertTrue(copy == instance)
    }
    
    func testEqualsFunctionWhenNotEquals()
    {
        let other = Generators.randomSupplementalInformation
        
        XCTAssertFalse(other == instance)
    }
    
    func testHumanReadableDescription()
    {
        let description = instance.humanReadableDescription
        XCTAssertFalse(description.isEmpty)
        print(description)
    }
}
