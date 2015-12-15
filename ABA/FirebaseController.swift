//
//  FirebaseController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    
    // MARK: Properties
    static let base = Firebase(url: "https://easyaba.firebaseio.com")
    
    // MARK: Methods
    static func dataAtEndpoint(endpoint: String, completion: (data: AnyObject?) -> Void) {
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        baseForEndpoint.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
    
    static func observeDataAtEndpoint(endpoint: String, completion: (data: AnyObject?) -> Void) {
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        baseForEndpoint.observeEventType(.Value, withBlock: { (snapshot) in
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
    
}

// MARK: Protocol - FirebaseType
protocol FirebaseType {
    var identifier: String? { get set }
    var endpoint: String { get }
    var jsonValue: [String: AnyObject] { get }
    
    init?(json: [String: AnyObject], identifier: String)
    
    mutating func save()
    mutating func delete()
}


// MARK: Extension - FirebaseType
extension FirebaseType {
    mutating func save() {
        var endpointBase: Firebase
        if let identifier = self.identifier {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(identifier)
        } else {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAutoId()
            self.identifier = endpointBase.key
        }
        endpointBase.updateChildValues(self.jsonValue)
    }
    
    func delete() {
        if let identifier = self.identifier {
            let endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(identifier)
            endpointBase.removeValue()
        }
    }
}