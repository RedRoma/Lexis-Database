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
        .X: "Throughout the Ages/Unknown",
        .A: "Throughout the Archaic period; These very early forms were obsolete by Classical times",
        .B: "During the Early Latin, Pre-Classical period, for effect and poetry",
        .C: "Throughout the Classical Era (-150 BC - 200 AD)",
        .D: "During the Late, Post-Classical period (300-500 AD)",
        .E: "Much later. This word was not in use during Classical times (600-1000 AD)",
        .F: "Throughout the Medieval period (1600-1800 AD)",
        .G: "During the Scholarly/Scientific period (1600-1800 AD)",
        .H: "In Modern times; This word was coined recently, and is used for new ideas (1900 AD onwards)"
    ]
    
    
    //MARK: Variables
    public static var codes: [String]
    {
        return ages.map() { $0.code }
    }
    
    public static let ages: [Age] = [.X, .A, .B, .C, .D, .E, .F, .G, .H]
    
    /** The corresponding dictionary code as a String */
    public var code: String { return self.rawValue }
    
    /** A short description of the Dictionary code */
    public var description: String
    {
        return Age.descriptions[self] ?? "Uknown"
    }
    
    
    //MARK: Functions
    
    /**
        Load an Age from a String dictionary code representation.
    */
    public static func from(dictionaryCode code: String) -> Age?
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
        .X: "All Areas",
        .A: "Agriculture, Flora, Fauna, Land, Equipment, Rural",
        .B: "Biology, Medicine, Human Anatomy",
        .D: "Drama, Music, Theatre, Art, Paintings, Sculptures",
        .E: "Ecclesiastics, The Bible, Religions",
        .G: "Grammar, Retoric, Logic, Literature, Schools",
        .L: "Legal, Goverment, Tax, Job Titles, Political, and Financial Institutions",
        .P: "Poetry",
        .S: "Science, Philosophy, Mathematics, Units of Measurement",
        .T: "Architecture, Topography, Surveying, Technology",
        .W: "War, Military, Naval, Ships, Armor",
        .Y: "Mythology"
    ]
    
    public static var codes: [String]
    {
        return areas.map() { $0.code }
    }
    
    public static let areas: [SubjectArea] = [.X, .A, .B, .D, .E, .G, .L, .P, .S, .T, .W, .Y]
    
    
    public var code: String { return self.rawValue }
    
    public var description: String
    {
        return SubjectArea.descriptions[self] ?? "Uknown"
    }
    
    public var descriptionParts: [String]
    {
        return self.description.components(separatedBy: ", ")
    }
    
    //MARK: Functions
    public static func from(dictionaryCode code: String) -> SubjectArea?
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
    case X
    case A
    case B
    case C
    case D
    case E
    case F
    case G
    case H
    case I
    case J
    case K
    case N
    case P
    case Q
    case R
    case S
    case U
    
    //MARK: Variables
    
    internal static let descriptions: [GeographicalArea: String] =
    [
        .X: "All areas",
        .A: "Africa",
        .B: "Britain",
        .C: "China",
        .D: "Scandinavia",
        .E: "Egypt",
        .F: "France/Gaul",
        .G: "Germany",
        .H: "Greece",
        .I: "Italy, Rome",
        .J: "India",
        .K: "Balkans",
        .N: "Netherlands",
        .P: "Persia",
        .Q: "Near East",
        .R: "Russia",
        .S: "Spain",
        .U: "Eastern Europe"
    ]
    
    public static var codes: [String]
    {
        return geophraphies.map() { $0.code }
    }
    
    public static let geophraphies: [GeographicalArea] = [.X, .A, .B, .C, .D, .E, .F, .G, .H, .I, .J, .K, .N, .P, .Q, .R, .S, .U]
    
    public var code: String { return self.rawValue }
    
    public var description: String
    {
        return GeographicalArea.descriptions[self] ?? "Uknown"
    }
    
    
    //MARK: Functions
    
    /** Load a GeographicalArea from a String dictionary code */
    public static func from(dictionaryCode code: String) -> GeographicalArea?
    {
        
        if let geographicalArea = GeographicalArea(rawValue: code)
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
    case X
    case A
    case B
    case C
    case D
    case E
    case I
    case M
    case N
    
    
    internal static let descriptions: [Frequency: String] =
    [
        .X: "Unknown",
        .A: "Very frequently in all Elementary Latin books", // Definitely top 1000 words
        .B: "Frequently", // next top 2000 words
        .C: "Commonly", //in the top 10,000 words"
        .D: "Infrequently;", //in top 20,1000 words
        .E: "Uncommonly", //2 or 3 citations
        .I: "In Inscription", //The only citation is scripture
        .M: "Rarely;", //Presently not used much
        .N: "In the Pliny" //Things that appear only in the Pliny Natural History
    ]
    
    internal static let frequencies: [Frequency] = [.X, .A, .B, .C, .D, .E, .I, .M, .N]
    
    internal static var codes: [String]
    {
        return frequencies.map() { $0.code }
    }
    
    public var code: String { return self.rawValue }
    
    public var description: String
    {
        return Frequency.descriptions[self] ?? "Uknown"
    }
    
    internal static func from(dictionaryCode code: String) -> Frequency?
    {
        
        if let frequency = Frequency(rawValue: code)
        {
            return frequency
        }
        else
        {
            LOG.warn("Failed to determine frequency from dictionary code: \(code)")
            return nil
        }
    }
    
}

/**
    The source of the word is the Dictionary or Grammar the word's
    definition and information was procured from.
 */
public enum Source: String
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
    case I
    case J
    case K
    case L
    case M
    case N
    case O
    case P
    case Q
    case R
    case S
    case T
    case U
    case V
    case W
    case Y
    case Z
    
    //MARK: Variables
    
    internal static let descriptions: [Source: String] =
    [
        .X: "General or unknown",
        .B: "C.H.Beeson, A Primer of Medieval Latin, 1925 (Bee)",
        .C: "Charles Beard, Cassell's Latin Dictionary 1892 (CAS)",
        .D: "J.N.Adams, Latin Sexual Vocabulary, 1982 (Sex)",
        .E: "L.F.Stelten, Dictionary of Eccles. Latin, 1995 (Ecc)",
        .F: "Roy J. Deferrari, Dictionary of St. Thomas Aquinas, 1960 (DeF)",
        .G: "Gildersleeve + Lodge, Latin Grammar 1895 (G+L)",
        .H: "Collatinus Dictionary by Yves Ouvrard",
        .I: "Leverett, F.P., Lexicon of the Latin Language, Boston 1845",
        .K: "Calepnus Novus, modern Latin, by Guy Licoppe (Cal)",
        .L: "Lewis, C.S., Elementary Latin Dictionary 1891",
        .M: "Latham, Revised Medieval Word List, 1980",
        .N: "Lynn Nelso, Wordlist",
        .O: "Oxford Latin Dictionary, 1982 (OLD)",
        .P: "Souter, A Glossary of Later Latin to 600 A.D., Oxford 1949",
        .Q: "Other, cited or unspecified dictionaries",
        .R: "Plater & White, A Grammar of the Vulgate, Oxford 1926",
        .S: "Lewis and Short, A Latin Dictionary, 1870 (L+S)",
        .T: "Found in a translation -- no dictionary reference",
        .U: "Du Cange",
        .V: "Vademecum in opus Saxonis - Franz Blatt (Saxo)",
        .W: "My personal guess"
    ]
    
    public static var codes: [String]
    {
        return sources.map() { $0.code }
    }
    
    public static let sources: [Source] = [.X, .A, .B, .C, .D, .E, .F, .G, .H, .I, .J, .K, .L, .M, .N, .O, .P, .Q, .R, .S, .T, .U, .V, .W, .Y, .Z]
    
    public var code: String { return self.rawValue }
    
    public var description: String
    {
        return Source.descriptions[self] ?? "No Dictionary Source"
    }
    
    
    //MARK: Functions
    public static func from(dictionaryCode code: String) -> Source?
    {
      
        if let source = Source(rawValue: code)
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
