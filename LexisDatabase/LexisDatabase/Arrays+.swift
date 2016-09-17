//
//  Arrays+.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/31/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
import Sulcus

extension Array
{
    
    var second: Element?
    {
        if count >= 2
        {
            return self[1]
        }
        
        return nil
    }
    
    var notEmpty: Bool
    {
        return !isEmpty
    }
    
    var anyElement: Element?
    {
        guard notEmpty else { return nil }
        
        let randomIndex = AlchemyGenerator.integer(from: 0, to: count - 1)
        return self[randomIndex]
    }
    
}

extension Array where Element: Equatable
{
    
    func containsMultiple(_ elements: [Element]) -> Bool
    {
        for element in elements
        {
            if !self.contains(element)
            {
                return false
            }
        }
        
        return true
    }
    
    func allMatch(shouldMatch: (Element) -> (Bool)) -> Bool
    {
        return self.filter(shouldMatch).count == count
    }
    
    func anyMatch(shouldMatch: (Element) -> (Bool)) -> Bool
    {
        return self.filter(shouldMatch).count >= 1
    }
}

