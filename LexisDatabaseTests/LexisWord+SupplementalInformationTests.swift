//
//  LexisWord+SupplementalInformationTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import AlchemyTest
import Foundation
@testable import LexisDatabase
import XCTest

class LexisWord_SupplementalInformationTests: LexisTest
{
    
    private var instance: SupplementalInformation!
    
    override func setUp()
    {
        instance = Generators.randomSupplementalInformation
    }
    
    func testEncoding()
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: instance)
        assertFalse(data.isEmpty)
        
        let extracted: SupplementalInformation! = NSKeyedUnarchiver.unarchiveObject(with: data) as! LexisWord.SupplementalInformation
        
        assertEquals(extracted, instance)
    }
    
    func testDecoding()
    {
        let archive = NSKeyedArchiver.archivedData(withRootObject: instance)
        
        let result: SupplementalInformation! = NSKeyedUnarchiver.unarchiveObject(with: archive) as? SupplementalInformation
        assertNotNil(result)
    
        assertEquals(result, instance)
    }
    
    func testEqualsFunction()
    {
        let archive = NSKeyedArchiver.archivedData(withRootObject: instance)
        
        let copy = NSKeyedUnarchiver.unarchiveObject(with: archive) as! SupplementalInformation
        
        assertThat(copy == instance)
    }
    
    func testEqualsFunctionWhenNotEquals()
    {
        let other = Generators.randomSupplementalInformation
        
        assertNotEquals(other, instance)
    }
    
    func testHumanReadableDescription()
    {
        repeatTest(10)
        {
            instance = Generators.randomSupplementalInformation
            let description = instance.humanReadableDescription
            assertNotEmpty(description)
            print(description)
            print()
            
        }
    }
}
