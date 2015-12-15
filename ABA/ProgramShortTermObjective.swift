//
//  ProgramShortTermObjective.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

struct ProgramShortTermObjective: Equatable, FirebaseType {
    
    // MARK: Keys
    private let kProgramIdentifier = "programIdentifier"
    private let kProgramSessionIdentifier = "programSessionIdentifier"
    private let kName = "name"
    
    // MARK: Properties
    var programIdentifier: String
    var programSessionIdentifier: String?
    var name: String
    var identifier: String?
    
    // MARK: Initializer
    init(programIdentifier: String, programSessionIdentifier: String? = nil, name: String, identifier: String? = nil) {
        self.programIdentifier = programIdentifier
        self.programSessionIdentifier = programSessionIdentifier
        self.name = name
        self.identifier = identifier
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "ProgramShortTermObjectives"
    }
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [kProgramIdentifier: programIdentifier, kName: name]
        if let programSessionIdentifier = programSessionIdentifier {
            json.updateValue(programSessionIdentifier, forKey: kProgramSessionIdentifier)
        }
        return json
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        guard let programIdentifier = json[kProgramIdentifier] as? String,
            let name = json[kName] as? String else {
                return nil
        }
        self.programIdentifier = programIdentifier
        self.name = name
        if let programSessionIdentifier = json[kProgramSessionIdentifier] as? String {
            self.programSessionIdentifier = programSessionIdentifier
        }
        self.identifier = identifier
    }
    
}

// MARK: Equatable
func ==(lhs: ProgramShortTermObjective, rhs: ProgramShortTermObjective) -> Bool {
    return (lhs.programIdentifier == rhs.programIdentifier) && (lhs.name == rhs.name) &&  (lhs.identifier == rhs.identifier)
}