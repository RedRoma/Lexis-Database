//
//  LexisEngine.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation

//The Lexis Engine is reponsible for reading through the Dictionary text file
//And extracting meaningful information from it, for the purpose of
//Storing representing in a LexisWord data structure
class LexisEngine {
    
    
    private struct Regex {
        
        static let wordType = "(TRANS|V|N|ADJ|ADV|CONJ)"
        static let dictionaryCode = "\\[(\\w+)\\]"
        
    }
    
}
