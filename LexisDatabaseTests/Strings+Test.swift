//
//  Strings+Test.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/2/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import XCTest
@testable import LexisDatabase

class Strings_Plus_Test: XCTestCase
{

    private var dictionary: String!
    private var testString: String!
    
    override func setUp()
    {
        super.setUp()
        dictionary = LexisEngine.instance.readTextFile()!
        testString = createString(withNumberOfLines: 20)
        
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testForEachLine()
    {
        let totalLines = 10
        
        let testString = createString(withNumberOfLines: totalLines)
        
        var count = 0
        testString.forEachLine() { lineNumber, line in
            
            count += 1
            XCTAssert(lineNumber == count)
        }
        
        XCTAssert(count == totalLines)
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
        XCTAssertEqual(result, expected)
        
    }
    
    func testWithCharacterRemoved()
    {
        let randomCharacter = "@" as Character
        let testString = self.testString + "\(randomCharacter)"
        
        let result = testString.withCharacterRemoved(character: randomCharacter)
        XCTAssertEqual(result, self.testString)
    }
    
    func testContainsAll()
    {
        let words = AlchemyGenerator.Arrays.ofAlphabeticString
        let subWords = Array(words[0...words.count/2])
        
        XCTAssertTrue(words.containsMultiple(subWords))
    }
    
    func testDoesNotContainsAnyOf()
    {
        let numbers = AlchemyGenerator.array() { return AlchemyGenerator.integer(from: 1, to: 9) }
        let numbersAsString = numbers.map(String.init).joined()
        let modifiedString = numbersAsString + testString + numbersAsString
        
        XCTAssertFalse(modifiedString.doesNotContain(anyOf: numbers.map(String.init)))
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
