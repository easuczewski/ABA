//
//  ProgramDataPoint.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

import Foundation

struct ProgramDataPoint: Equatable, FirebaseType {
    
    // MARK: Keys
    private let kProgramSessionIdentifier = "programSessionIdentifier"
    private let kPointTimestamp = "pointTimestamp"
    private let kDataPoint = "dataPoint"
    
    // MARK: Properties
    var programSessionIdentifier: String
    var pointTimestamp: NSDate
    var dataPoint: String
    var identifier: String?
    
    // MARK: Initializer
    init(programSessionIdentifier: String, dataPoint: String, identifier: String? = nil) {
        self.programSessionIdentifier = programSessionIdentifier
        self.pointTimestamp = NSDate()
        self.dataPoint = dataPoint
        self.identifier = identifier
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "ProgramDataPoints"
    }
    
    var jsonValue: [String: AnyObject] {
        return [kProgramSessionIdentifier: programSessionIdentifier, kPointTimestamp: pointTimestamp.stringValue(), kDataPoint: dataPoint]
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        guard let programSessionIdentifier = json[kProgramSessionIdentifier] as? String,
            let pointTimestampString = json[kPointTimestamp] as? String,
            let pointTimestamp: NSDate? = pointTimestampString.dateValue(),
            let dataPoint = json[kDataPoint] as? String else {
                return nil
        }
        if (pointTimestamp == nil) {
            return nil
        }
        self.programSessionIdentifier = programSessionIdentifier
        self.pointTimestamp = pointTimestamp!
        self.dataPoint = dataPoint
        self.identifier = identifier
    }
}

// MARK: Equatable
func ==(lhs: ProgramDataPoint, rhs: ProgramDataPoint) -> Bool {
    return (lhs.programSessionIdentifier == rhs.programSessionIdentifier) && (lhs.pointTimestamp == rhs.pointTimestamp) && (lhs.dataPoint == rhs.dataPoint) && (lhs.identifier == rhs.identifier)
}
