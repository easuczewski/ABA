//
//  ProgramSessionController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

class ProgramSessionController {
    
    // MARK: Properties
    static let sharedController = ProgramSessionController()
    
    // MARK: Methods
    //Create
    static func createProgramSessionForProgram(program: Program, completion: (programSession: ProgramSession?) -> Void) {
        if let programIdentifier = program.identifier {
            var programSession = ProgramSession(programIdentifier: programIdentifier, sessionTimestamp: NSDate())
            programSession.save()
            completion(programSession: programSession)
        } else {
            completion(programSession: nil)
        }
    }
    
    //Read
    static func programSessionsForProgram(program: Program, completion: (programSessions: [ProgramSession]?) -> Void) {
        if let programIdentifier = program.identifier {
            FirebaseController.base.childByAppendingPath("ProgramSessions").queryOrderedByChild("programIdentifier").queryEqualToValue(programIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let programSessionDictionaries = snapshot.value as? [String: AnyObject] {
                    let programSessions = programSessionDictionaries.flatMap({ProgramSession(json: $0.1 as! [String: AnyObject], identifier: $0.0)}).sort({ (programSession1, programSession2) -> Bool in
                        programSession1.sessionTimestamp > programSession2.sessionTimestamp
                    })
                    completion(programSessions: programSessions)
                } else {
                    completion(programSessions: nil)
                }
            })
        } else {
            completion(programSessions: nil)
        }
    }
    
    static func programSessionWithIdentifier(identifier: String, completion: (programSession: ProgramSession?) -> Void) {
        FirebaseController.dataAtEndpoint("ProgramSessions/\(identifier)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let programSession = ProgramSession(json: json, identifier: identifier)
                completion(programSession: programSession)
            } else {
                completion(programSession: nil)
            }
        }
    }
    
    //Update
    static func updateProgramSession(programSession: ProgramSession, sessionTimestamp: NSDate, completion: (programSession: ProgramSession?) -> Void) {
        if let identifier = programSession.identifier {
            var updatedProgramSession = ProgramSession(programIdentifier: programSession.programIdentifier, sessionTimestamp: sessionTimestamp, identifier: identifier)
            updatedProgramSession.save()
            ProgramSessionController.programSessionWithIdentifier(identifier, completion: { (programSession) -> Void in
                if let programSession = programSession {
                    completion(programSession: programSession)
                } else {
                    completion(programSession: nil)
                }
            })
        } else {
            completion(programSession: nil)
        }
    }
    
    //Delete
    static func deleteProgramSession(programSession: ProgramSession) {
        programSession.delete()
    }
    
}


