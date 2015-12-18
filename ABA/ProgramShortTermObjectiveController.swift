//
//  ProgramShortTermObjectiveController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

class ProgramShortTermObjectiveController {
    
    // MARK: Properties
    static let sharedController = ProgramShortTermObjectiveController()
    
    // MARK: Methods
    //Create
    static func createProgramShortTermObjectiveForProgram(program: Program, name: String, completion: (programShortTermObjective: ProgramShortTermObjective?) -> Void) {
        if let programIdentifier = program.identifier {
            var programShortTermObjective = ProgramShortTermObjective(programIdentifier: programIdentifier, name: name)
            programShortTermObjective.save()
            completion(programShortTermObjective: programShortTermObjective)
        } else {
            completion(programShortTermObjective: nil)
        }
    }
    
    //Read
    static func programShortTermObjectivesForProgram(program: Program, completion: (programShortTermObjectives: [ProgramShortTermObjective]?) -> Void) {
        if let programIdentifier = program.identifier {
            FirebaseController.base.childByAppendingPath("ProgramShortTermObjectives").queryOrderedByChild("programIdentifier").queryEqualToValue(programIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let programShortTermObjectiveDictionaries = snapshot.value as? [String: AnyObject] {
                    let programShortTermObjectives = programShortTermObjectiveDictionaries.flatMap({ProgramShortTermObjective(json: $0.1 as! [String: AnyObject], identifier: $0.0)}).sort({ (programShortTermObjective1, programShortTermObjective2) -> Bool in
                        programShortTermObjective1.name < programShortTermObjective2.name
                    })
                    completion(programShortTermObjectives: programShortTermObjectives)
                } else {
                    completion(programShortTermObjectives: nil)
                }
            })
        } else {
            completion(programShortTermObjectives: nil)
        }
    }
    
    static func programShortTermObjectivesForProgramSession(programSession: ProgramSession, completion: (programShortTermObjectives: [ProgramShortTermObjective]?) -> Void) {
        if let programSessionIdentifier = programSession.identifier {
            FirebaseController.base.childByAppendingPath("ProgramShortTermObjectives").queryOrderedByChild("programSessionIdentifier").queryEqualToValue(programSessionIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let programShortTermObjectiveDictionaries = snapshot.value as? [String: AnyObject] {
                    let programShortTermObjectives = programShortTermObjectiveDictionaries.flatMap({ProgramShortTermObjective(json: $0.1 as! [String: AnyObject], identifier: $0.0)}).sort({ (programShortTermObjective1, programShortTermObjective2) -> Bool in
                        programShortTermObjective1.name < programShortTermObjective2.name
                    })
                    completion(programShortTermObjectives: programShortTermObjectives)
                } else {
                    completion(programShortTermObjectives: nil)
                }
            })
        } else {
            completion(programShortTermObjectives: nil)
        }
    }
    
    static func programShortTermObjectiveWithIdentifier(identifier: String, completion: (programShortTermObjective: ProgramShortTermObjective?) -> Void) {
        FirebaseController.dataAtEndpoint("ProgramShortTermObjectives/\(identifier)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let programShortTermObjective = ProgramShortTermObjective(json: json, identifier: identifier)
                completion(programShortTermObjective: programShortTermObjective)
            } else {
                completion(programShortTermObjective: nil)
            }
        }
    }
    
    static func completionDateStringForProgramShortTermObjective(programShortTermObjective: ProgramShortTermObjective, completion: (dateString: String) -> Void) {
        if let identifier = programShortTermObjective.programSessionIdentifier {
            ProgramSessionController.programSessionWithIdentifier(identifier, completion: { (programSession) -> Void in
                if let programSession = programSession {
                    let dateString = programSession.sessionTimestamp.shortStringValue()
                    completion(dateString: dateString)
                } else {
                    completion(dateString: "incomplete")
                }
            })
        } else {
            completion(dateString: "incomplete")
        }
    }

   
    
    //Update
    static func updateProgramShortTermObjective(programShortTermObjective: ProgramShortTermObjective, name: String, completion: (programShortTermObjective: ProgramShortTermObjective?) -> Void) {
        if let identifier = programShortTermObjective.identifier {
            var updatedProgramShortTermObjective = ProgramShortTermObjective(programIdentifier: programShortTermObjective.programIdentifier, programSessionIdentifier: programShortTermObjective.programSessionIdentifier, name: name, identifier: identifier)
            updatedProgramShortTermObjective.save()
            ProgramShortTermObjectiveController.programShortTermObjectiveWithIdentifier(identifier, completion: { (programShortTermObjective) -> Void in
                if let programShortTermObjective = programShortTermObjective {
                    completion(programShortTermObjective: programShortTermObjective)
                } else {
                    completion(programShortTermObjective: nil)
                }
            })
        } else {
            completion(programShortTermObjective: nil)
        }
    }
    
    static func completeProgramShortTermObjective(programShortTermObjective: ProgramShortTermObjective, programSession: ProgramSession, completion: (programShortTermObjective: ProgramShortTermObjective?) -> Void) {
        if let identifier = programShortTermObjective.identifier {
            var updatedProgramShortTermObjective = ProgramShortTermObjective(programIdentifier: programShortTermObjective.programIdentifier, programSessionIdentifier: programSession.identifier, name: programShortTermObjective.name, identifier: identifier)
            updatedProgramShortTermObjective.save()
            ProgramShortTermObjectiveController.programShortTermObjectiveWithIdentifier(identifier, completion: { (programShortTermObjective) -> Void in
                if let programShortTermObjective = programShortTermObjective {
                    completion(programShortTermObjective: programShortTermObjective)
                } else {
                    completion(programShortTermObjective: nil)
                }
            })
        } else {
            completion(programShortTermObjective: nil)
        }
    }
    
    //Delete
    static func deleteProgramShortTermObjective(programShortTermObjective: ProgramShortTermObjective) {
        programShortTermObjective.delete()
    }
    
}
