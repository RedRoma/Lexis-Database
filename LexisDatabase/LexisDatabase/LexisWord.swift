//
//  LexisWord.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation

enum Conjugation {
    case First
    case Second
    case Third
    case Fourth
}

enum VerbType {
    case Transitive
    case Intransitive
    case Impersonal
    case Deponent
}

enum Gender {
    case Male
    case Female
    case Neuter
}

enum Declension: String {
    case First = "Nominative"
    case Second = "Genitive"
    case Third = "Dative"
    case Fourth = "Accusative"
    case Fifth = "Ablative"
}

enum PronounType: String {
    case Reflexive
    case Personal
}


enum WordType {
    case Verb(Conjugation, VerbType)
    case Noun(Declension, Gender)
    case Adjective
    case Adverb
    case Preposition(Declension)
    case PersonalPronoun(Declension, PronounType?)
}

enum Number {
    case Singular
    case Plural
}

struct Definition {
    let terms: [String] = []
}

//This is the primary Datastructure representing a Latin word in Lexis.
struct LexisWord {
    

    let primary: String = ""
    let alternativeWords: [String] = []
    let wordType: WordType
    let definitions: [Definition] = []
    
    
}
