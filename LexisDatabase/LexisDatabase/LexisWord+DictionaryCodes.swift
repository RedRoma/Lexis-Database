//
//  LexisWord+Description.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/15/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus


/**
    This file represents the information discussed in Whitaker's [documentation](http://archives.nd.edu/whitaker/wordsdoc.htm#DICTIONARY).
    This file provides clean Swift representation of the codes reference there.
 */


/**
    The Age represents a Words' Age and in what time-period it was used.
 */
public enum Age: String
{

    case X
    case A
    case B
    case C
    case D
    case E
    case F
    case G
    case H
    
    internal static let descriptions: [Age: String] =
    [
        .X: "In use throughout the ages/unknown",
        .A: "Archaic; Very early forms, obsolete by classical times",
        .B: "Early Latin, pre-classical, used for effect and poetry",
        .C: "Classical; limited to classical (-150 BC - 200 AD)",
        .D: "Late, post-classical period (300-500 AD)",
        .E: "Later; Latin not in use during Classical times (600-1000 AD) Christian",
        .F: "In use throughout the Medieval period (1600-1800 AD)",
        .G: "In use during the Scholarly/Scientific period (1600-1800 AD)",
        .H: "Modern; Coined recently; words for new things (1900 AD onwards)"
    ]
    
    
    //MARK: Variables
    internal static var codes: [String]
    {
        return ages.map() { $0.code }
    }
    
    internal static let ages: [Age] = [.X, .A, .B, .C, .D, .E, .F, .G, .H]
    
    public var code: String { return self.rawValue }
    
    public var description: String
    {
        return Age.descriptions[self]!
    }
    
    
    //MARK: Functions
    internal static func from(dictionaryCode code: String) -> Age?
    {
        
        if let age = Age(rawValue: code)
        {
            return age
        }
        else
        {
            LOG.warn("Unknown Dictionary code for Age: \(code)")
            return nil
        }
    }
    
}

/**
    The Subject Area represents the discipline in which the word is used,
    for example, in medical fields, or in agriculture.
 */
public enum SubjectArea: String
{
    case X
    case A
    case B
    case D
    case E
    case G
    case L
    case P
    case S
    case T
    case W
    case Y

    //MARK: Variables
    
    internal static let descriptions: [SubjectArea: String] =
    [
        .X: "All areas",
        .A: "Agriculture, Flora, Fauna, Land, Equipment, Rural",
        .B: "Biological, Medical, Body Parts",
        .D: "Drama, Music, Theatre, Art, Painting, Sculpture",
        .E: "Ecclesiastic, Biblical, Religious",
        .G: "Grammar, Retoric, Logic, Literature, Schools",
        .L: "Legal, Goverment, Tax, Financial, Political, Titles",
        .P: "Poetic",
        .S: "Science, Philosophy, Mathematics, Units/Measurements",
        .T: "Technical, Architecture, Topography, Surveying",
        .W: "Warn, Military, Naval, Ships, Armor",
        .Y: "Muthology"
    ]
    
    internal static var codes: [String]
    {
        return areas.map() { $0.code }
    }
    
    internal static let areas: [SubjectArea] = [.X, .A, .B, .D, .E, .G, .L, .P, .S, .T, .W, .Y]
    
    public var parts: [String]
    {
        return self.rawValue.components(separatedBy: ", ")
    }
    
    public var code: String { return self.rawValue }
    
    
    //MARK: Functions
    internal static func from(dictionaryCode code: String) -> SubjectArea?
    {
        
        if let subjectArea = SubjectArea(rawValue: code)
        {
            return subjectArea
        }
        else
        {
            LOG.warn("Could not find a suitable subject area for dictionary code: \(code)")
            return nil
        }
    }
}


/**
    The Geographical Area represents where in the world the word was commonly used.
 */
public enum GeographicalArea: String
{
    case X = "All area"
    case A = "Africa"
    case B = "Britain"
    case C = "China"
    case D = "Scandinavia"
    case E = "Egypt"
    case F = "France/Gaul"
    case G = "Germany"
    case H = "Greece"
    case I = "Italy, Rome"
    case J = "India"
    case K = "Balkans"
    case N = "Netherlands"
    case P = "Persia"
    case Q = "Near East"
    case R = "Russia"
    case S = "Spain"
    case U = "Eastern Europe"
    
    //MARK: Variables
    
    internal static let codeMappings: [String: GeographicalArea] =
    [
        "X": .X,
        "A": .A,
        "B": .B,
        "C": .C,
        "D": .D,
        "E": .E,
        "F": .F,
        "G": .G,
        "H": .H,
        "I": .I,
        "J": .J,
        "K": .K,
        "N": .N,
        "P": .P,
        "Q": .Q,
        "R": .R,
        "S": .S,
        "U": .U
    ]
    
    internal static var codes: [String]
    {
        return Array(codeMappings.keys)
    }
    
    internal static var geophraphies: [GeographicalArea]
    {
        return Array(Set(codeMappings.values))
    }
    
    public var code: String { return self.rawValue }
    
    //MARK: Functions
    internal static func from(dictionaryCode code: String) -> GeographicalArea?
    {
        
        if let geographicalArea = codeMappings[code]
        {
            return geographicalArea
        }
        else
        {
            LOG.warn("Could not load geographical area from code: \(code)")
            return nil
        }
    }
    
}

/**
    Frequency is an indication of the relative frequency for a word.
    This code also applies differently to inflections.
    If there were several matches to an input word,
    this key may be used to sort teh output, or exclude rate interpretations.
 */
public enum Frequency: String
{
    case X = "Unknown"
    case A = "Very frequenetly; Used in all Elmentary Latin books. Definitely top 1000 words"
    case B = "Frequent, next top 2000 words"
    case C = "Common; For dictionary, in the top 10,000 words"
    case D = "Lesser; For dictionary, in top 20,1000 words"
    case E = "Uncommon; 2 or 3 citations"
    case I = "Inscription; The only citation is scripture"
    case M = "Grafitti; Presently not used much"
    case N = "Pliny; Things that appear only in the Pliny Natural History"
    
    
    internal static let codeMappings: [String: Frequency] =
    [
        "X": .X,
        "A": .A,
        "B": .B,
        "C": .C,
        "D": .D,
        "E": .E,
        "I": .I,
        "M": .M,
        "N": .N
    ]
    
    internal static var codes: [String]
    {
        return Array(codeMappings.keys)
    }
    
    internal static var frequencies: [Frequency]
    {
        return Array(Set(codeMappings.values))
    }
    
    internal static func from(dictionaryCode code: String) -> Frequency?
    {
        
        if let frequency = codeMappings[code]
        {
            return frequency
        }
        else
        {
            LOG.warn("Failed to determine frequency from dictionary code: \(code)")
            return nil
        }
    }
    
    public var code: String { return self.rawValue }
}

/**
    The source of the word is the Dictionary or Grammar the word's
    definition and information was procured from.
 */
public enum Source: String
{
    
    
    case X = "General or unknown"
    case A
    case B = "C.H.Beeson, A Primer of Medieval Latin, 1925 (Bee)"
    case C = "Charles Beard, Cassell's Latin Dictionary 1892 (CAS)"
    case D = "J.N.Adams, Latin Sexual Vocabulary, 1982 (Sex)"
    case E = "L.F.Stelten, Dictionary of Eccles. Latin, 1995 (Ecc)"
    case F = "Roy J. Deferrari, Dictionary of St. Thomas Aquinas, 1960 (DeF)"
    case G = "Gildersleeve + Lodge, Latin Grammar 1895 (G+L)"
    case H = "Collatinus Dictionary by Yves Ouvrard"
    case I = "Leverett, F.P., Lexicon of the Latin Language, Boston 1845"
    case J
    case K = "Calepnus Novus, modern Latin, by Guy Licoppe (Cal)"
    case L = "Lewis, C.S., Elementary Latin Dictionary 1891"
    case M = "Latham, Revised Medieval Word List, 1980"
    case N = "Lynn Nelso, Wordlist"
    case O = "Oxford Latin Dictionary, 1982 (OLD)"
    case P = "Souter, A Glossary of Later Latin to 600 A.D., Oxford 1949"
    case Q = "Other, cited or unspecified dictionaries"
    case R = "Plater & White, A Grammar of the Vulgate, Oxford 1926"
    case S = "Lewis and Short, A Latin Dictionary, 1870 (L+S)"
    case T = "Found in a translation -- no dictionary reference"
    case U = "Du Cange"
    case V = "Vademecum in opus Saxonis - Franz Blatt (Saxo)"
    case W = "My personal guess"
    case Y,Z = "No Dictionary Reference"
    
    //MARK: Variables
    internal static let codeMappings: [String: Source] =
    [
        "A": .A,
        "B": .B,
        "C": .C,
        "D": .D,
        "E": .E,
        "F": .F,
        "G": .G,
        "H": .H,
        "I": .I,
        "J": .J,
        "K": .K,
        "L": .L,
        "M": .M,
        "N": .N,
        "O": .O,
        "P": .P,
        "Q": .Q,
        "R": .R,
        "S": .S,
        "T": .T,
        "U": .U,
        "V": .V,
        "W": .W,
        "X": .X,
        "Y": .Y,
        "Z": .Z
    ]
    
    internal static var codes: [String]
    {
        return Array(codeMappings.keys)
    }
    
    internal static var sources: [Source]
    {
        return Array(Set(codeMappings.values))
    }
    
    public var code: String { return self.rawValue }
    
    
    //MARK: Functions
    internal static func from(dictionaryCode code: String) -> Source?
    {
      
        if let source = codeMappings[code]
        {
            return source
        }
        else
        {
            LOG.warn("Could not find a Source for dictionary code: \(code)")
            return nil
        }
    }
    
}
