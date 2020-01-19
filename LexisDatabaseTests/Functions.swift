//
//  Functions.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/18/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemySwift
import AlchemyTest
import Foundation
@testable import LexisDatabase

class Functions
{
    static func half(ofString string: String) -> String
    {
        guard string.notEmpty else { return string }

        let len = string.length 
        let mid = len.isEven ? ((len / 2) - 1) : (len / 2)
        let substring = string.substring(from: 0, to: mid)
        return substring
    }
}
