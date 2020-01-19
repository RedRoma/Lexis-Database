//
//  Strings+Test.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/2/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import AlchemyTest
@testable import LexisDatabase

class Strings_Plus_Test: AlchemyTest
{

    private var dictionary: String!
    private var testString: String!

    override func beforeEachTest()
    {
        super.beforeEachTest()
        dictionary = LexisEngine.shared.readTextFile()!
        testString = createString(withNumberOfLines: 20)
    }
    
    func testForEachLine()
    {
        let totalLines = 10
        
        let testString = createString(withNumberOfLines: totalLines)
        
        var count = 0
        testString.forEachLine() { lineNumber, line in
            
            count += 1
            assertEquals(lineNumber, count)
        }
        
        assertEquals(count, totalLines)
    }
    
    func testProcessEachLine()
    {
        
        var expected: [String] = []
        
        let mapper: (String, Int) -> (String) = { line, lineNumber in
            
            let result = line + line
            expected.append(result)
            return result
        }
        
        var result: [String] = []
        let processor: (String) -> () = { string in
            result.append(string)
        }
        
        testString.processEachLine(mapper: mapper, processor: processor)
        assertEquals(result, expected)
        
    }
    
    func testWithCharacterRemoved()
    {
        let randomCharacter = "@" as Character
        let testString = self.testString + "\(randomCharacter)"
        
        let result = testString.withCharacterRemoved(character: randomCharacter)
        assertEquals(result, self.testString)
    }
    
    func testContainsAll()
    {
        let words = AlchemyGenerator.Arrays.ofAlphabeticString
        let subWords = Array(words[0...words.count/2])
        
        assertThat(words.containsMultiple(subWords))
    }
    
    func testDoesNotContainsAnyOf()
    {
        let numbers = AlchemyGenerator.array() { AlchemyGenerator.integer(from: 1, to: 9) }
        let numbersAsString = numbers.map(String.init).joined()
        let modifiedString = numbersAsString + testString + numbersAsString
        
        assertFalse(modifiedString.doesNotContain(anyOf: numbers.map(String.init)))
    }
    
    private func createString(withNumberOfLines lines: Int) -> String
    {
        guard lines >= 0 else { return "" }
        
        var count = 1
        var string = ""
        
        dictionary.enumerateLines() { line, shouldStop in
            
            if count >= lines
            {
                shouldStop = true
            }
            
            count += 1
            string += line + "\n"
        }
        
        return string
    }
    
   
}
