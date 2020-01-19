//
//  WordType+JSONTests.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/20/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyTest
import Archeota
import Foundation
@testable import LexisDatabase


class WordType_JSONTests: LexisTest
{
    private let serializer = BasicJSONSerializer.instance
    private var instance: WordType!
    
    override func setUp()
    {
        instance = Generators.randomWordType
    }
    
    func testAsJSON()
    {
        var jsonObject = WordType.Adjective.asJSON()!
        var json = serializer.toJSON(object: jsonObject)!
        
        jsonObject = WordType.Adverb.asJSON()!
        json = serializer.toJSON(object: jsonObject)!
        
        jsonObject = WordType.Noun(Declension.First, Gender.Female).asJSON()!
        json = serializer.toJSON(object: jsonObject)!
    }
    
    
    func testJsonSerialization()
    {
        let json = instance.asJSON()
        assertThat(json is NSDictionary)
        let dictionary = json as! NSDictionary
        
        let object = WordType.fromJSON(json: dictionary)
        assertNotNil(object)
        assertThat(object is WordType)
        
        let copy = object as! WordType
        assertEquals(copy, instance)
    }
}
