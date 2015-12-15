//
//  BehaviorController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

class BehaviorController {
    
    // MARK: Properties
    static let sharedController = BehaviorController()
    
    // MARK: Methods
    //Create
    static func createBehaviorForStudent(student: Student, name: String, abbreviation: String, description: String, withTime: String,  completion: (behavior: Behavior?) -> Void) {
        if let studentIdentifier = student.identifier {
            var behavior = Behavior(studentIdentifier: studentIdentifier, name: name, abbreviation: abbreviation, description: description, withTime: withTime)
            behavior.save()
            completion(behavior: behavior)
        } else {
            completion(behavior: nil)
        }
    }
    
    //Read
    static func behaviorsForStudent(student: Student, completion: (behaviors: [Behavior]?) -> Void) {
        if let studentIdentifier = student.identifier {
            FirebaseController.base.childByAppendingPath("Behaviors").queryOrderedByChild("studentIdentifier").queryEqualToValue(studentIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let behaviorDictionaries = snapshot.value as? [String: AnyObject] {
                    let behaviors = behaviorDictionaries.flatMap({Behavior(json: $0.1 as! [String: AnyObject], identifier: $0.0)}).sort({ (behavior1, behavior2) -> Bool in
                        behavior1.name < behavior2.name
                    })
                    completion(behaviors: behaviors)
                } else {
                    completion(behaviors: nil)
                }
            })
        } else {
            completion(behaviors: nil)
        }
    }
    
    static func behaviorWithIdentifier(identifier: String, completion: (behavior: Behavior?) -> Void) {
        FirebaseController.dataAtEndpoint("Behaviors/\(identifier)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let behavior = Behavior(json: json, identifier: identifier)
                completion(behavior: behavior)
            } else {
                completion(behavior: nil)
            }
        }
    }
    
    //Update
    static func updateBehavior(behavior: Behavior, name: String, abbreviation: String, description: String, withTime: String, completion: (behavior: Behavior?) -> Void) {
        if let identifier = behavior.identifier {
            var updatedBehavior = Behavior(studentIdentifier: behavior.studentIdentifier, name: name, abbreviation: abbreviation, description: description, withTime: withTime, identifier: identifier)
            updatedBehavior.save()
            BehaviorController.behaviorWithIdentifier(identifier, completion: { (behavior) -> Void in
                if let behavior = behavior {
                    completion(behavior: behavior)
                } else {
                    completion(behavior: nil)
                }
            })
        } else {
            completion(behavior: nil)
        }
    }
    
    //Delete
    static func deleteBehavior(behavior: Behavior) {
        behavior.delete()
    }
    
}

