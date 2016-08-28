//
//  LexisWord.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation

enum WordType {
    case verb
    case noun
    case adjective
    case adverb
    case preposition
    case personalPronoun
}

enum VerbType {
    case transitive
    case intransitive
}

enum Gender {
    case male
    case female
    case neuter
}

enum Declension {
    case first, second, third, fourth, fifth
}

enum Number {
    case singular
    case plural
}

struct Definition {
    let terms: [String] = []
}

//This is the primary Datastructure representing a Latin word in Lexis.
struct LexisWord {
    

    let primary: String = ""
    let alternativeWords: [String] = []
    let wordType: WordType = .noun
    let definitions: [Definition] = []
    
    
}
