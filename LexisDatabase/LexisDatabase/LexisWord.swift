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

enum Declension {
    case Nominative
    case Genitive
    case Accusative
    case Dative
    case Ablative
    case Vocative
    case Locative
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
    case Interjection
}

enum Number {
    case Singular
    case Plural
}

struct Definition {
    let terms: [String] = []
}

//This is the primary Datastructure representing a Latin word in Lexis.
struct LexisWord
{
    /**
        A Word's forms represnts the different parts to a Latin vocabulary entry.
        For instance, a noun will have its nominative and genitive forms.
    */
    let forms: [String]
    
    /**
        Determines a word's type: `[Noun, Verb, Adjective, etc]`.
    */
    let wordType: WordType
    
    /**
        This represent a Word's separate definitions. Although each `Definition` object may have different words,
        they all essentially represent the same meaning.
     
        Whereas a different `Definition` object represents a different meaning.
    */
    let definitions: [Definition] = []
    
}
