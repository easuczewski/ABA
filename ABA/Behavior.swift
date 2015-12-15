//
//  Behavior.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

struct Behavior: Equatable, FirebaseType {
    
    // MARK: Keys
    private let kStudentIdentifier = "studentIdentifier"
    private let kName = "name"
    private let kAbbreviation = "abbreviation"
    private let kDescription = "description"
    private let kWithTime = "withTime"
    private let kKey = "key"
    
    // MARK: Properties
    var studentIdentifier: String
    var name: String
    var abbreviation: String
    var description: String
    var withTime: String
    var key: String
    var identifier: String?
    
    // MARK: Initializer
    init(studentIdentifier: String, name: String, abbreviation: String, description: String, withTime: String, identifier: String? = nil) {
        self.studentIdentifier = studentIdentifier
        self.name = name
        self.abbreviation = abbreviation
        self.description = description
        self.withTime = withTime
        self.key = "untracked"
        self.identifier = identifier
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "Behaviors"
    }
    
    var jsonValue: [String: AnyObject] {
        return [kStudentIdentifier: studentIdentifier, kName: name, kAbbreviation: abbreviation, kDescription: description, kWithTime: withTime, kKey: key]
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        guard let studentIdentifier = json[kStudentIdentifier] as? String,
            let name = json[kName] as? String,
            let abbreviation = json[kAbbreviation] as? String,
            let description = json[kDescription] as? String,
            let withTime = json[kWithTime] as? String,
            let key = json[kKey] as? String else {
                return nil
        }
        self.studentIdentifier = studentIdentifier
        self.name = name
        self.abbreviation = abbreviation
        self.description = description
        self.withTime = withTime
        self.key = key
        self.identifier = identifier
    }
    
}

// MARK: Equatable
func ==(lhs: Behavior, rhs: Behavior) -> Bool {
    return (lhs.studentIdentifier == rhs.studentIdentifier) && (lhs.name == rhs.name) && (lhs.abbreviation == rhs.abbreviation) && (lhs.description == rhs.description) && (lhs.withTime == rhs.withTime) && (lhs.key == rhs.key) && (lhs.identifier == rhs.identifier)
}