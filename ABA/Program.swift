//
//  Program.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

struct Program: Equatable, FirebaseType {
    
    // MARK: Keys
    private let kStudentIdentifier = "studentIdentifier"
    private let kName = "name"
    private let kDomain = "domain"
    private let kAntecedent = "antecedent"
    private let kLongTermObjective = "longTermObjective"
    private let kCompletionDate = "completionDate"
    
    
    // MARK: Properties
    var studentIdentifier: String
    var name: String
    var domain: String
    var antecedent: String
    var longTermObjective: String
    var completionDate: NSDate?
    var identifier: String?
    
    // MARK: Initializer
    init(studentIdentifier: String, name: String, domain: String, antecedent: String, longTermObjective: String, completionDate: NSDate? = nil, identifier: String? = nil) {
        self.studentIdentifier = studentIdentifier
        self.name = name
        self.domain = domain
        self.antecedent = antecedent
        self.longTermObjective = longTermObjective
        self.completionDate = completionDate
        self.identifier = identifier
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "Programs"
    }
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [kStudentIdentifier: studentIdentifier, kName: name, kDomain: domain, kAntecedent: antecedent, kLongTermObjective: longTermObjective]
        if let completionDate = completionDate {
            json.updateValue(completionDate.stringValue(), forKey: kCompletionDate)
        }
        return json
    }
    
    init?(json: [String : AnyObject], identifier: String) {
        guard let studentIdentifier = json[kStudentIdentifier] as? String,
            let name = json[kName] as? String,
            let domain = json[kDomain] as? String,
            let antecedent = json[kAntecedent] as? String,
            let longTermObjective = json[kLongTermObjective] as? String else {
                return nil
        }
        
        self.studentIdentifier = studentIdentifier
        self.name = name
        self.domain = domain
        self.antecedent = antecedent
        self.longTermObjective = longTermObjective
        if let completionDateString = json[kCompletionDate] as? String {
            self.completionDate = completionDateString.dateValue()
            if self.completionDate == nil {
                return nil
            }
        }
        self.identifier = identifier
    }
    
}

// MARK: Equatable

func ==(lhs: Program, rhs: Program) -> Bool {
    return (lhs.studentIdentifier == rhs.studentIdentifier) && (lhs.name == rhs.name) && (lhs.domain == rhs.domain) && (lhs.antecedent == rhs.antecedent) && (lhs.longTermObjective == rhs.longTermObjective) && (lhs.identifier == rhs.identifier)
}