 //
//  ProgramDataPointController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

 import Foundation
 
 class ProgramDataPointController {
    
    // MARK: Properties
    static let sharedController = ProgramDataPointController()
    
    // MARK: Methods
    //Create
    static func createProgramDataPointForProgramSession(programSession: ProgramSession, dataPoint: String, completion: (programDataPoint: ProgramDataPoint?) -> Void) {
        if let programSessionIdentifier = programSession.identifier {
            var programDataPoint = ProgramDataPoint(programSessionIdentifier: programSessionIdentifier, dataPoint: dataPoint)
            programDataPoint.save()
            completion(programDataPoint: programDataPoint)
        } else {
            completion(programDataPoint: nil)
        }
    }
    
    //Read
    static func programDataPointsForProgramSession(programSession: ProgramSession, completion: (programDataPoints: [ProgramDataPoint]?) -> Void) {
        if let programSessionIdentifier = programSession.identifier {
            FirebaseController.base.childByAppendingPath("ProgramDataPoints").queryOrderedByChild("programSessionIdentifier").queryEqualToValue(programSessionIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let programDataPointDictionaries = snapshot.value as? [String: AnyObject] {
                    let programDataPoints = programDataPointDictionaries.flatMap({ProgramDataPoint(json: $0.1 as! [String: AnyObject], identifier: $0.0)}).sort({ (programDataPoint1, programDataPoint2) -> Bool in
                        programDataPoint1.pointTimestamp > programDataPoint2.pointTimestamp
                    })
                    completion(programDataPoints: programDataPoints)
                } else {
                    completion(programDataPoints: nil)
                }
            })
        } else {
            completion(programDataPoints: nil)
        }
    }
    
    static func programDataPointWithIdentifier(identifier: String, completion: (programDataPoint: ProgramDataPoint?) -> Void) {
        FirebaseController.dataAtEndpoint("ProgramDataPoints/\(identifier)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let programDataPoint = ProgramDataPoint(json: json, identifier: identifier)
                completion(programDataPoint: programDataPoint)
            } else {
                completion(programDataPoint: nil)
            }
        }
    }
    
    //Update
    static func updateProgramDataPoint(programDataPoint: ProgramDataPoint, dataPoint: String, completion: (programDataPoint: ProgramDataPoint?) -> Void) {
        if let identifier = programDataPoint.identifier {
            var updatedProgramDataPoint = ProgramDataPoint(programSessionIdentifier: programDataPoint.programSessionIdentifier, dataPoint: dataPoint, identifier: identifier)
            updatedProgramDataPoint.save()
            ProgramDataPointController.programDataPointWithIdentifier(identifier, completion: { (programDataPoint) -> Void in
                if let programDataPoint = programDataPoint {
                    completion(programDataPoint: programDataPoint)
                } else {
                    completion(programDataPoint: nil)
                }
            })
        } else {
            completion(programDataPoint: nil)
        }
    }
    
    //Delete
    static func deleteProgramDataPoint(programDataPoint: ProgramDataPoint) {
        programDataPoint.delete()
    }
    
 }
 

