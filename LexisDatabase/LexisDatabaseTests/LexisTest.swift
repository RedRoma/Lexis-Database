//
//  Tests+Aroma.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/19/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AromaSwiftClient
import Foundation
import XCTest

class LexisTest: XCTestCase
{
    override class func setUp()
    {
        XCTestCase.setUp()
        
        AromaClient.TOKEN_ID = "d51c346a-d61e-41b0-9bcd-885572c1256a"
    }
    
    override func recordFailure(withDescription description: String, inFile filePath: String, atLine lineNumber: UInt, expected: Bool)
    {
        super.recordFailure(withDescription: description, inFile: filePath, atLine: lineNumber, expected: expected)
        
        AromaClient.beginMessage(withTitle: "Tests Failed")
            .addBody(description)
            .addLine(2)
            .addBody("In File: \(filePath)").addLine(2)
            .addBody("At Line #\(lineNumber)").addLine(2)
            .withPriority(.high)
            .send()
    }
    
}
