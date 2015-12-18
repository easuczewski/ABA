//
//  ProgramTacticController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

class ProgramTacticController {
    
    // MARK: Properties
    static let sharedController = ProgramTacticController()
    
    // MARK: Methods
    //Create
    static func createProgramTacticForProgram(program: Program, name: String, completion: (programTactic: ProgramTactic?) -> Void) {
        if let programIdentifier = program.identifier {
            var programTactic = ProgramTactic(programIdentifier: programIdentifier, name: name)
            programTactic.save()
            completion(programTactic: programTactic)
        } else {
            completion(programTactic: nil)
        }
    }
    
    //Read
    static func programTacticsForProgram(program: Program, completion: (programTactics: [ProgramTactic]?) -> Void) {
        if let programIdentifier = program.identifier {
            FirebaseController.base.childByAppendingPath("ProgramTactics").queryOrderedByChild("programIdentifier").queryEqualToValue(programIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let programTacticDictionaries = snapshot.value as? [String: AnyObject] {
                    let programTactics = programTacticDictionaries.flatMap({ProgramTactic(json: $0.1 as! [String: AnyObject], identifier: $0.0)}).sort({ (programTactic1, programTactic2) -> Bool in
                        programTactic1.name < programTactic2.name
                    })
                    completion(programTactics: programTactics)
                } else {
                    completion(programTactics: nil)
                }
            })
        } else {
            completion(programTactics: nil)
        }
    }
    
    static func programTacticsStartedForProgramSession(programSession: ProgramSession, completion: (programTactics: [ProgramTactic]?) -> Void) {
        if let programSessionIdentifier = programSession.identifier {
            FirebaseController.base.childByAppendingPath("ProgramTactics").queryOrderedByChild("startProgramSessionIdentifier").queryEqualToValue(programSessionIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let programTacticDictionaries = snapshot.value as? [String: AnyObject] {
                    let programTactics = programTacticDictionaries.flatMap({ProgramTactic(json: $0.1 as! [String: AnyObject], identifier: $0.0)}).sort({ (programTactic1, programTactic2) -> Bool in
                        programTactic1.name < programTactic2.name
                    })
                    completion(programTactics: programTactics)
                } else {
                    completion(programTactics: nil)
                }
            })
        } else {
            completion(programTactics: nil)
        }
    }
    
    static func programTacticsEndedForProgramSession(programSession: ProgramSession, completion: (programTactics: [ProgramTactic]?) -> Void) {
        if let programSessionIdentifier = programSession.identifier {
            FirebaseController.base.childByAppendingPath("ProgramTactics").queryOrderedByChild("endProgramSessionIdentifier").queryEqualToValue(programSessionIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let programTacticDictionaries = snapshot.value as? [String: AnyObject] {
                    let programTactics = programTacticDictionaries.flatMap({ProgramTactic(json: $0.1 as! [String: AnyObject], identifier: $0.0)}).sort({ (programTactic1, programTactic2) -> Bool in
                        programTactic1.name < programTactic2.name
                    })
                    completion(programTactics: programTactics)
                } else {
                    completion(programTactics: nil)
                }
            })
        } else {
            completion(programTactics: nil)
        }
    }
    
    static func programTacticWithIdentifier(identifier: String, completion: (programTactic: ProgramTactic?) -> Void) {
        FirebaseController.dataAtEndpoint("ProgramTactics/\(identifier)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let programTactic = ProgramTactic(json: json, identifier: identifier)
                completion(programTactic: programTactic)
            } else {
                completion(programTactic: nil)
            }
        }
    }
    
    static func startStopDateStringForProgramTactic(programTactic: ProgramTactic, completion: (dateString: String) -> Void) {
        if let startIdentifier = programTactic.startProgramSessionIdentifier {
            // BREAK THIS DOWN INTO A SINGLE CALL FOR BOTH PROGRAM SESSIONS AND 
            ProgramSessionController.programSessionWithIdentifier(startIdentifier, completion: { (programSession) -> Void in
                if let startProgramSession = programSession {
                    if let endIdentifier = programTactic.endProgramSessionIdentifier {
                        ProgramSessionController.programSessionWithIdentifier(endIdentifier, completion: { (programSession) -> Void in
                            if let endProgramSession = programSession {
                                completion(dateString: "\(startProgramSession.sessionTimestamp.shortStringValue())- \(endProgramSession.sessionTimestamp.shortStringValue())")
                            } else {
                                completion(dateString: "\(startProgramSession.sessionTimestamp.shortStringValue())-")
                            }
                        })
                    } else {
                        completion(dateString: "\(startProgramSession.sessionTimestamp.shortStringValue())-")
                    }
                } else {
                    completion(dateString: "not started")
                }
            })
        } else {
            completion(dateString: "not started")
        }
    }
    
    //Update
    static func updateProgramTactic(programTactic: ProgramTactic, name: String, completion: (programTactic: ProgramTactic?) -> Void) {
        if let identifier = programTactic.identifier {
            var updatedProgramTactic = ProgramTactic(programIdentifier: programTactic.programIdentifier, startProgramSessionIdentifier: programTactic.startProgramSessionIdentifier, endProgramSessionIdentifier: programTactic.endProgramSessionIdentifier, name: name, identifier: identifier)
            updatedProgramTactic.save()
            ProgramTacticController.programTacticWithIdentifier(identifier, completion: { (programTactic) -> Void in
                if let programTactic = programTactic {
                    completion(programTactic: programTactic)
                } else {
                    completion(programTactic: nil)
                }
            })
        } else {
            completion(programTactic: nil)
        }
    }
    
    static func startProgramTactic(programTactic: ProgramTactic, programSession: ProgramSession, completion: (programTactic: ProgramTactic?) -> Void) {
        if let identifier = programTactic.identifier {
            if let startProgramSessionIdentifier = programSession.identifier {
                var updatedProgramTactic = ProgramTactic(programIdentifier: programTactic.programIdentifier, startProgramSessionIdentifier: startProgramSessionIdentifier, endProgramSessionIdentifier: programTactic.endProgramSessionIdentifier, name: programTactic.name, identifier: identifier)
                updatedProgramTactic.save()
                ProgramTacticController.programTacticWithIdentifier(identifier, completion: { (programTactic) -> Void in
                    if let programTactic = programTactic {
                        completion(programTactic: programTactic)
                    } else {
                        completion(programTactic: nil)
                    }
                })
            } else {
                completion(programTactic: nil)
            }
        } else {
            completion(programTactic: nil)
        }
    }
    
    static func endProgramTactic(programTactic: ProgramTactic, programSession: ProgramSession, completion: (programTactic: ProgramTactic?) -> Void) {
        if let identifier = programTactic.identifier {
            if let endProgramSessionIdentifier = programSession.identifier {
                var updatedProgramTactic = ProgramTactic(programIdentifier: programTactic.programIdentifier, startProgramSessionIdentifier: programTactic.startProgramSessionIdentifier, endProgramSessionIdentifier: endProgramSessionIdentifier, name: programTactic.name, identifier: identifier)
                updatedProgramTactic.save()
                ProgramTacticController.programTacticWithIdentifier(identifier, completion: { (programTactic) -> Void in
                    if let programTactic = programTactic {
                        completion(programTactic: programTactic)
                    } else {
                        completion(programTactic: nil)
                    }
                })
            } else {
                completion(programTactic: nil)
            }
        } else {
            completion(programTactic: nil)
        }
    }
    
    //Delete
    static func deleteProgramTactic(programTactic: ProgramTactic) {
        programTactic.delete()
    }
    
}
