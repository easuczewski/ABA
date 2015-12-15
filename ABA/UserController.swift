//
//  UserController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

class UserController: NSObject {
    
    // MARK: Properties
    private let kUser = "userKey"
    
    static let sharedController = UserController()
    
    var currentUser: User? {
        get {
            guard let uid = FirebaseController.base.authData?.uid,
                let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(kUser) as? [String: AnyObject] else { return nil }
            return User(json: userDictionary, identifier: uid)
        }
        set {
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    // MARK: Methods
    //Create
    
    // Read
    static func authenticateUser(email: String, password: String, completion: (user: User?, error: NSError?) -> Void) {
        FirebaseController.base.authUser(email, password: password) { (error, response) -> Void in
            if error != nil {
                completion(user: nil, error: error)
            } else {
                UserController.userWithIdentifier(response.uid, completion: { (user) -> Void in
                    completion(user: user, error: nil)
                })
            }
        }
    }
    
    static func userWithIdentifier(identifier: String, completion: (user: User?) -> Void) {
        FirebaseController.dataAtEndpoint("Users/\(identifier)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, identifier: identifier)
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    // Update
    static func updateUser(user: User, email: String, completion: (user: User?) -> Void) {
        if let identifier = user.identifier {
            var updatedUser = User(email: email, uid: identifier)
            updatedUser.save()
            UserController.userWithIdentifier(identifier, completion: { (user) -> Void in
                if let user = user {
                    sharedController.currentUser = user
                    completion(user: user)
                } else {
                    completion(user: nil)
                }
            })
        }
    }
    
    static func logoutCurrentUser() {
        FirebaseController.base.unauth()
        sharedController.currentUser = nil
    }
    
    // Delete
    static func deleteUser(user: User, password: String) {
        FirebaseController.base
            .removeUser(user.email, password: password) { (error) -> Void in
                if error == nil {
                    user.delete()
                }
        }
    }
    
}