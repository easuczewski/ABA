//
//  ProgramTactic.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

struct ProgramTactic: Equatable, FirebaseType {
    
    // MARK: Keys
    private let kProgramIdentifier = "programIdentifier"
    private let kStartProgramSessionIdentifier = "startProgramSessionIdentifier"
    private let kEndProgramSessionIdentifier = "endProgramSessionIdentifier"
    private let kName = "name"
    
    // MARK: Properties
    var programIdentifier: String
    var startProgramSessionIdentifier: String?
    var endProgramSessionIdentifier: String?
    var name: String
    var identifier: String?
    
    // MARK: Initializer
    init(programIdentifier: String, startProgramSessionIdentifier: String? = nil, endProgramSessionIdentifier: String? = nil, name: String, identifier: String? = nil) {
        self.programIdentifier = programIdentifier
        self.startProgramSessionIdentifier = startProgramSessionIdentifier
        self.endProgramSessionIdentifier = endProgramSessionIdentifier
        self.name = name
        self.identifier = identifier
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "ProgramTactics"
    }
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [kProgramIdentifier: programIdentifier, kName: name]
        if let startProgramSessionIdentifier = startProgramSessionIdentifier {
            json.updateValue(startProgramSessionIdentifier, forKey: kStartProgramSessionIdentifier)
        }
        if let endProgramSessionIdentifier = endProgramSessionIdentifier {
            json.updateValue(endProgramSessionIdentifier, forKey: kEndProgramSessionIdentifier)
        }
        return json
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        guard let programIdentifier = json[kProgramIdentifier] as? String,
            let name = json[kName] as? String else {
                return nil
        }
        self.programIdentifier = programIdentifier
        if let startProgramSessionIdentifier = json[kStartProgramSessionIdentifier] as? String {
            self.startProgramSessionIdentifier = startProgramSessionIdentifier
        }
        if let endProgramSessionIdentifier = json[kEndProgramSessionIdentifier] as? String {
            self.endProgramSessionIdentifier = endProgramSessionIdentifier
        }
        self.name = name
        self.identifier = identifier
    }
    
}

// MARK: Equatable
func ==(lhs: ProgramTactic, rhs: ProgramTactic) -> Bool {
    return (lhs.programIdentifier == rhs.programIdentifier) && (lhs.name == rhs.name) && (lhs.identifier == rhs.identifier)
}