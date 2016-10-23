//
//  SupplementalInformation+JSON.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/19/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Archeota

fileprivate class Keys
{
    static let age = "age"
    static let subjectArea = "subject_area"
    static let geographicalArea = "geographical_area"
    static let frequency = "frequency"
    static let source = "source"
}

//MARK: Supplemental Information
extension SupplementalInformation: JSONConvertible
{
    
    func asJSON() -> Any?
    {
        let json = NSMutableDictionary()
        
        json[Keys.age] = self.age.code
        json[Keys.subjectArea] = self.subjectArea.code
        json[Keys.geographicalArea] = self.geographicalArea.code
        json[Keys.frequency] = self.frequency.code
        json[Keys.source] = self.source.code
        
        return json
    }
    
    static func fromJSON(json: Any) -> JSONConvertible?
    {
        guard let dictionary = json as? [String: Any]
        else
        {
            LOG.warn("Failed to deserialize json String as a Dictionary: \(json)")
            return nil
        }
        
        guard let ageCode = dictionary[Keys.age] as? String
        else
        {
            LOG.warn("Could not load age code from dictionary: \(dictionary)")
            return nil
        }
        
        guard let subjectAreaCode = dictionary[Keys.subjectArea] as? String
        else
        {
            LOG.warn("Could not load subject area code from dictionary: \(dictionary)")
            return nil
        }
        
        guard let geographicalAreaCode = dictionary[Keys.geographicalArea] as? String
        else
        {
            LOG.warn("Could not load geographical area code from dictionary: \(dictionary)")
            return nil
        }
        
        guard let frequencyCode = dictionary[Keys.frequency] as? String
        else
        {
            LOG.warn("Could not load frequency from Dictionary: \(dictionary)")
            return nil
        }
        
        guard let sourceCode = dictionary[Keys.source] as? String
        else
        {
            LOG.warn("Could not load source code from dictionary: \(dictionary)")
            return nil
        }
        
        guard let age = Age.from(dictionaryCode: ageCode),
            let subjectArea = SubjectArea.from(dictionaryCode: subjectAreaCode),
            let geographicalArea = GeographicalArea.from(dictionaryCode: geographicalAreaCode),
            let frequency = Frequency.from(dictionaryCode: frequencyCode),
            let source = Source.from(dictionaryCode: sourceCode)
        else
        {
            LOG.warn("Could not interpret dictionary codes: \(dictionary)")
            return nil
        }
        
        return SupplementalInformation(age: age, subjectArea: subjectArea, geographicalArea: geographicalArea, frequency: frequency, source: source)
    }
    
}
