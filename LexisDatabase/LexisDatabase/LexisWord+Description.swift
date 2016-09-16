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
    case H = "Modern; Coined recently; words for new things (1900 AD onwards)"
    
    public static func from(dictionaryCode code: String) -> Age?
    {
        switch code
        {
            case "X" : return .X
            case "A" : return .A
            case "B" : return .B
            case "C" : return .C
            case "D" : return .D
            case "E" : return .E
            case "F" : return .F
            case "H" : return .H
            default :
                LOG.warn("Unknown Dictionary code for Age: \(code)")
                return nil
        }
        
    }
}


//MARK: Functions for extracting descriptions from dictionary codes.
extension LexisWord
{
    

}
