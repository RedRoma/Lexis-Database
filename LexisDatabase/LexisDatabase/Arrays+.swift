//
//  Arrays+.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/31/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation


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
    
}

extension Array where Element: Equatable
{
    
    
    func containsMultiple(_ elements: Element...) -> Bool
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
}
