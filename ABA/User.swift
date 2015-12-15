//
//  User.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

import Foundation

struct User: Equatable, FirebaseType {
    
    // MARK: Keys
    private let kEmail = "email"
    
    // MARK: Properties
    var email: String
    var identifier: String?
    
    // MARK: Initializer
    init(email: String, uid: String) {
        self.email = email
        self.identifier = uid
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "Users"
    }
    
    var jsonValue: [String: AnyObject] {
        return [kEmail: email]
    }
    
    init?(json: [String : AnyObject], identifier: String) {
        guard let email = json[kEmail] as? String else {
            return nil
        }
        self.email = email
        self.identifier = identifier
    }
    
}

// MARK: Equatable
func ==(lhs: User, rhs: User) -> Bool {
    return (lhs.email == rhs.email) && (lhs.identifier == rhs.identifier)
}