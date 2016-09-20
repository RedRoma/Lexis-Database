//
//  Tests+Aroma.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/19/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AromaSwiftClient
import Foundation
import Sulcus
import XCTest

class LexisTest: XCTestCase
{
    override class func setUp()
    {
        XCTestCase.setUp()
        LOG.enable()
        
        AromaClient.TOKEN_ID = "d51c346a-d61e-41b0-9bcd-885572c1256a"
        AromaClient.maxConcurrency = 2
        
        NSSetUncaughtExceptionHandler() { ex in
            AromaClient.beginMessage(withTitle: "Tests Failed")
                .addBody("Uncaught Exception").addLine(2)
                .addBody("\(ex)")
                .withPriority(.high)
                .send()
        }
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
            .send(onError: {ex in
                LOG.error("Failed to send message to Aroma: \(ex)")
            }) {
                let level = LOG.level
                LOG.level = .info
                LOG.info("Message sent to Aroma successfully")
                LOG.level = level
            }
        
    }
    
    
    func testAromaMessage()
    {
        func onError(ex: Error) {
            print("Aroma message failed: \(ex)")
        }
        
        func onDone() {
            print("Aroma message was a success")
        }
        
        for _ in 1...100
        {
            AromaClient.beginMessage(withTitle: "Testing")
                .withPriority(.medium)
                .send(onError: onError, onDone: onDone)
            
            AromaClient.sendMediumPriorityMessage(withTitle: "Testing")
        }
    }
    
}
