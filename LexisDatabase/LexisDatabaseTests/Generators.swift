//
//  Generators.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/2/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
@testable import LexisDatabase

struct Data
{
    static let dictionary = LexisEngine.instance.readTextFile()!
    static let words = LexisEngine.instance.getAllWords()
    static let lines = Data.dictionary.components(separatedBy: "\n").filter(String.isNotEmpty)
    
    static var randomLine: String
    {
        let randomLineNumber = try! randomInteger(from: 1, to: 30_000)
        return lines[randomLineNumber]
    }
}

enum BadArgument: Error
{
    case InvalidRange
}

func randomInteger(from: Int, to: Int) throws -> Int
{
    guard from < to else { throw BadArgument.InvalidRange }
    
    let difference = to - from
    
    let randomNumber = Int(arc4random_uniform(UInt32(difference)))
    
    let result = from + randomNumber
    
    return result <= to ? result : to
}

func arrayOfNumbers(from: Int, to: Int) -> [Int]
{
    var array: [Int] = []
    
    for number in (from...to)
    {
        array.append(number)
    }
    
    return array
}

func stringWithNumbers(from: Int, to: Int) -> String
{
    var result = ""
    for number in (from...to)
    {
        result += "\(number)"
    }
    return result
}

func alphabeticalString(ofSize size: Int = try! randomInteger(from: 5, to: 15)) -> String
{
    guard size > 0 else { return "" }
    
    
    var string = ""
    
    var index: Int
    {
        return try! randomInteger(from: 0, to: alphabeticalCharacters.count - 1)
    }
    

    for _ in (1...size)
    {
        string.append(alphabeticalCharacters[index])
    }
    
    return string
}

private var alphabeticalCharacters: [String]
{
    var characters: [String] = []
    
    let beginScalar = "a".unicodeScalars.first!.value
    let endScalar = "z".unicodeScalars.first!.value
    
    for char in (beginScalar...endScalar)
    {
        guard let unicode = UnicodeScalar.init(char) else { continue }
        let character = String(unicode)
        characters.append(character)
    }
    
    return characters
}

