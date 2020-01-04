//
//  Functions.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/18/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
@testable import LexisDatabase

class Functions
{
    static func half(ofString string: String) -> String
    {
        guard string.notEmpty else { return string }
        
        let count = string.count
        let halfwayPoint = count / 2
        let index = string.index(string.startIndex, offsetBy: halfwayPoint)
        let substring = String(string[..<index])
        return substring
    }
}
