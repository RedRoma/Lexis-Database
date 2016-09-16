//
//  LexisWord+Description.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/15/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus

public extension LexisWord
{
    
}


/**
    The Age represents a Words' Age and in what time-period it was used.
 */
public enum Age: String
{
    case X = "In use throughout the ages/unknown"
    case A = "Archaic; Very early forms, obsolete by classical times"
    case B = "Early Latin, pre-classical, used for effect and poetry"
    case C = "Classical; limited to classical (-150 BC - 200 AD)"
    case D = "Late, post-classical period (300-500 AD)"
    case E = "Later; Latin not in use during Classical times (600-1000 AD) Christian"
    case F = "In use throughout the Medieval period (1600-1800 AD)"
    case G = "In use during the Scholarly/Scientific period (1600-1800 AD)"
    case H = "Modern; Coined recently; words for new things (1900 AD onwards)"
    
    public static func from(dictionaryCode code: String) -> Age?
    {
        let codes: [String: Age] =
        [
            "X": .X,
            "A": .A,
            "B": .B,
            "C": .C,
            "D": .D,
            "E": .E,
            "F": .F,
            "G": .G,
            "H": .H
        ]
        
        if let age = codes[code]
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
    case X = "All areas"
    case A = "Agriculture, Flora, Fauna, Land, Equipment, Rural"
    case B = "Biological, Medical, Body Parts"
    case D = "Drama, Music, Theatre, Art, Painting, Sculpture"
    case E = "Ecclesiastic, Biblical, Religious"
    case G = "Grammar, Retoric, Logic, Literature, Schools"
    case L = "Legal, Goverment, Tax, Financial, Political, Titles"
    case P = "Poetic"
    case S = "Science, Philosophy, Mathematics, Units/Measurements"
    case T = "Technical, Architecture, Topography, Surveying"
    case W = "Warn, Military, Naval, Ships, Armor"
    case Y = "Muthology"

    public var parts: [String]
    {
        return self.rawValue.components(separatedBy: ", ")
    }
    
    public static func from(dictionaryCode code: String) -> SubjectArea?
    {
        let codes: [String: SubjectArea] =
        [
            "X": .X,
            "A": .A,
            "B": .B,
            "D": .D,
            "E": .E,
            "G": .G,
            "L": .L,
            "P": .P,
            "S": .S,
            "T": .T,
            "W": .W,
            "Y": .Y
        ]
        
        if let subjectArea = codes[code]
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
    
    
    public static func from(dictionaryCode code: String) -> GeographicalArea?
    {
        let codes: [String: GeographicalArea] =
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
        
        if let geographicalArea = codes[code]
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
    
    public static func from(dictionaryCode code: String) -> Frequency?
    {
        
        let codes: [String: Frequency] =
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
        
        if let frequency = codes[code]
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

//MARK: Functions for extracting descriptions from dictionary codes.
extension LexisWord
{
    

}
