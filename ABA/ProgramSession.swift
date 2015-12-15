//
//  ProgramSession.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

struct ProgramSession: Equatable, FirebaseType {
    
    // MARK: Keys
    private let kProgramIdentifier = "programIdentifier"
    private let kSessionTimestamp = "sessionTimestamp"
    
    // MARK: Properties
    var programIdentifier: String
    var sessionTimestamp: NSDate
    var identifier: String?
    
    // MARK: Initializer
    init(programIdentifier: String, sessionTimestamp: NSDate, identifier: String? = nil) {
        self.programIdentifier = programIdentifier
        self.sessionTimestamp = sessionTimestamp
        self.identifier = identifier
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "ProgramSessions"
    }
    
    var jsonValue: [String: AnyObject] {
        return [kProgramIdentifier: programIdentifier, kSessionTimestamp: sessionTimestamp.stringValue()]
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        guard let programIdentifier = json[kProgramIdentifier] as? String,
            let sessionTimestampString = json[kSessionTimestamp] as? String,
            let sessionTimestamp: NSDate? = sessionTimestampString.dateValue() else {
                return nil
        }
        if sessionTimestamp == nil {
            return nil
        }
        self.programIdentifier = programIdentifier
        self.sessionTimestamp = sessionTimestamp!
        self.identifier = identifier
    }
}

// MARK: Equatable
func ==(lhs: ProgramSession, rhs: ProgramSession) -> Bool {
    return (lhs.programIdentifier == rhs.programIdentifier) && (lhs.sessionTimestamp == rhs.sessionTimestamp) && (lhs.identifier == rhs.identifier)
}