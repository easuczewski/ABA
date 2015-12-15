//
//  BehaviorDataPoint.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

struct BehaviorDataPoint: Equatable, FirebaseType {
    
    // MARK: Keys
    private let kBehaviorIdentifier = "behaviorIdentifier"
    private let kDate = "date"
    private let kDataPoint = "dataPoint"
    
    // MARK: Properties
    var behaviorIdentifier: String
    var date: NSDate
    var dataPoint: String
    var identifier: String?
    
    // MARK: Initializer
    init(behaviorIdentifier: String, dataPoint: String,identifier: String? = nil) {
        self.behaviorIdentifier = behaviorIdentifier
        self.date = NSDate()
        self.dataPoint = dataPoint
        self.identifier = identifier
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "BehaviorDataPoints"
    }
    
    var jsonValue: [String: AnyObject] {
        return [kBehaviorIdentifier: behaviorIdentifier, kDate: date.stringValue(), kDataPoint: dataPoint]
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        guard let behaviorIdentifier = json[kBehaviorIdentifier] as? String,
            let dateString = json[kDate] as? String,
            let date: NSDate? = dateString.dateValue(),
            let dataPoint = json[kDataPoint] as? String else {
                return nil
        }
        if date == nil {
            return nil
        }
        self.behaviorIdentifier = behaviorIdentifier
        self.date = date!
        self.dataPoint = dataPoint
    }
    
}

// MARK: Equatable
func ==(lhs: BehaviorDataPoint, rhs: BehaviorDataPoint) -> Bool {
    return (lhs.behaviorIdentifier == rhs.behaviorIdentifier) && (lhs.date == rhs.date) && (lhs.dataPoint == rhs.dataPoint) && (lhs.identifier == rhs.identifier)
}
