//
//  LexisWord+SupplementalInformation.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus


internal typealias SupplementalInformation = LexisWord.SupplementalInformation

//MARK: Supplemental Information and Functions for extracting descriptions from dictionary codes.
public extension LexisWord
{
    public class SupplementalInformation: NSObject, NSCoding
    {
        public let age: Age
        public let subjectArea: SubjectArea
        public let geographicalArea: GeographicalArea
        public let frequency: Frequency
        public let source: Source
        
        public init(age: Age, subjectArea: SubjectArea, geographicalArea: GeographicalArea, frequency: Frequency, source: Source)
        {
            self.age = age
            self.subjectArea = subjectArea
            self.geographicalArea = geographicalArea
            self.frequency = frequency
            self.source = source
        }
        
        public convenience required init?(coder decoder: NSCoder)
        {
            guard let ageString = decoder.decodeObject(forKey: Keys.age) as? String,
                let age = Age.from(dictionaryCode: ageString),
                let subjectAreaString = decoder.decodeObject(forKey: Keys.subjectArea) as? String,
                let subjectArea = SubjectArea.from(dictionaryCode: subjectAreaString),
                let geographicalAreaString = decoder.decodeObject(forKey: Keys.geopgraphicalArea) as? String,
                let geographicalArea = GeographicalArea.from(dictionaryCode: geographicalAreaString),
                let frequencyString = decoder.decodeObject(forKey: Keys.frequency) as? String,
                let frequency = Frequency.from(dictionaryCode: frequencyString),
                let sourceString = decoder.decodeObject(forKey: Keys.source) as? String,
                let source = Source.from(dictionaryCode: sourceString)
                else
            {
                LOG.warn("Failed to decode Supplemental information")
                return nil
            }
            
            self.init(age: age, subjectArea: subjectArea, geographicalArea: geographicalArea, frequency: frequency, source: source)
        }
        
        public func encode(with encoder: NSCoder)
        {
            encoder.encode(self.age.code, forKey: Keys.age)
            encoder.encode(self.subjectArea.code, forKey: Keys.subjectArea)
            encoder.encode(self.geographicalArea.code, forKey: Keys.geopgraphicalArea)
            encoder.encode(self.frequency.code, forKey: Keys.frequency)
            encoder.encode(self.source.code, forKey: Keys.source)
        }
        
        public override var description: String
        {
            return "[\(age.code)\(subjectArea.code)\(geographicalArea.code)\(frequency.code)\(source.code)]"
        }
        
        public override var hashValue: Int
        {
            return description.hashValue
        }
        
        //Used for NSCoding
        private class Keys
        {
            static let age = "age"
            static let subjectArea = "subject_area"
            static let geopgraphicalArea = "geographical_location"
            static let frequency = "frequency"
            static let source = "source"
        }
    }
    
}


public func ==(left: LexisWord.SupplementalInformation, right: LexisWord.SupplementalInformation) -> Bool
{
    //Description is a quick and simple way to test equality
    return left.description == right.description
}
