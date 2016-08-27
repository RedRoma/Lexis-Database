//
//  LexisWord.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation

enum LexisWordType {
    case verb
    case noun
    case adjective
    case adverb
    case preposition
}


struct LexisDefinition {
    let terms: [String] = []
}

//This is the primary Datastructure representing a Latin word in Lexis.
struct LexisWord {
    

    let primary: String = ""
    let alternativeWords: [String] = []
    let wordType: LexisWordType = .noun
    let definitions: [LexisDefinition] = []
    
    
}
