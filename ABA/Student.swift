//
//  Student.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

struct Student: Equatable, FirebaseType {
    
    // MARK: Keys
    private let kUserIdentifier = "userIdentifier"
    private let kName = "name"
    private let kParentEmail = "parentEmail"
    private let kImageEndpoint = "imageEndpoint"
    
    // MARK: Properties
    var userIdentifier: String
    var name: String
    var imageEndpoint: String?
    var parentEmail: String
    var identifier: String?
    
    // MARK: Initializer
    init(userIdentifier: String, name: String, parentEmail: String, imageEndpoint: String?, identifier: String? = nil) {
        self.userIdentifier = userIdentifier
        self.name = name
        self.parentEmail = parentEmail
        self.imageEndpoint = imageEndpoint
        self.identifier = identifier
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "Students"
    }
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [kUserIdentifier: userIdentifier, kName: name, kParentEmail: parentEmail]
        if let imageEndpoint = imageEndpoint {
            json.updateValue(imageEndpoint, forKey: kImageEndpoint)
        }
        return json
    }
    
    init?(json: [String : AnyObject], identifier: String) {
        guard let userIdentifier = json[kUserIdentifier] as? String,
            let name = json[kName] as? String,
            let parentEmail = json[kParentEmail] as? String else {
                return nil
        }
        self.userIdentifier = userIdentifier
        self.name = name
        self.parentEmail = parentEmail
        if let imageEndpoint = json[kImageEndpoint] as? String {
            self.imageEndpoint = imageEndpoint
        }
        self.identifier = identifier
    }
    
}

// MARK: Equatable
func ==(lhs: Student, rhs: Student) -> Bool {
    return (lhs.userIdentifier == rhs.userIdentifier) && (lhs.name == rhs.name) && (lhs.parentEmail == rhs.parentEmail) && (lhs.identifier == rhs.identifier)
}