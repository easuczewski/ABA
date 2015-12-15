//
//  ProgramController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

class ProgramController {
    
    // MARK: Properties
    static let sharedController = ProgramController()
    
    // MARK: Methods
    //Create
    static func createProgramForStudent(student: Student, name: String, domain: String, antecedent: String, longTermObjective: String,  completion: (program: Program?) -> Void) {
        if let studentIdentifier = student.identifier {
            var program = Program(studentIdentifier: studentIdentifier, name: name, domain: domain, antecedent: antecedent, longTermObjective: longTermObjective)
            program.save()
            completion(program: program)
        } else {
            completion(program: nil)
        }
    }
    
    //Read
    static func programsForStudent(student: Student, completion: (programs: [Program]?) -> Void) {
        if let studentIdentifier = student.identifier {
            FirebaseController.base.childByAppendingPath("Programs").queryOrderedByChild("studentIdentifier").queryEqualToValue(studentIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let programDictionaries = snapshot.value as? [String: AnyObject] {
                    let programs = programDictionaries.flatMap({Program(json: $0.1 as! [String: AnyObject], identifier: $0.0)}).sort({ (program1, program2) -> Bool in
                        program1.name < program2.name
                    })
                    completion(programs: programs)
                } else {
                    completion(programs: nil)
                }
            })
        } else {
            completion(programs: nil)
        }
    }
    
    static func programWithIdentifier(identifier: String, completion: (program: Program?) -> Void) {
        FirebaseController.dataAtEndpoint("Programs/\(identifier)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let program = Program(json: json, identifier: identifier)
                completion(program: program)
            } else {
                completion(program: nil)
            }
        }
    }
    
    //Update
    static func updateProgram(program: Program, name: String, domain: String, antecedent: String, longTermObjective: String, completion: (program: Program?) -> Void) {
        if let identifier = program.identifier {
            var updatedProgram = Program(studentIdentifier: program.studentIdentifier, name: name, domain: domain, antecedent: antecedent, longTermObjective: longTermObjective, identifier: identifier)
            updatedProgram.save()
            ProgramController.programWithIdentifier(identifier, completion: { (program) -> Void in
                if let program = program {
                    completion(program: program)
                } else {
                    completion(program: nil)
                }
            })
        } else {
            completion(program: nil)
        }
    }
    
    //Delete
    static func deleteProgram(program: Program) {
        program.delete()
    }
    
}
