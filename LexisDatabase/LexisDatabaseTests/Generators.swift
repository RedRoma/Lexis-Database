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
