//
//  StudentController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation
import UIKit

class StudentController {
    
    // MARK: Properties
    static let sharedController = StudentController()
    
    // MARK: Methods
    //Create
    static func createStudentWithName(name: String, userIdentifier: String, completion: (student: Student?) -> Void) {
        if let userIdentifier = UserController.sharedController.currentUser?.identifier {
            var student = Student(userIdentifier: userIdentifier, name: name, parentEmail: nil, imageEndpoint: nil)
                student.save()
                completion(student: student)
        } else {
            completion(student: nil)
        }
    }
    
    //Read
    static func studentsForUser(user: User, completion: (students: [Student]?) -> Void) {
        if let userIdentifier = user.identifier {
            FirebaseController.base.childByAppendingPath("Students").queryOrderedByChild("userIdentifier").queryEqualToValue(userIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let studentDictionaries = snapshot.value as? [String: AnyObject] {
                    let students = studentDictionaries.flatMap({Student(json: $0.1 as! [String: AnyObject], identifier: $0.0)}).sort({ (student1, student2) -> Bool in
                        student1.name < student2.name
                    })
                    completion(students: students)
                } else {
                    completion(students: nil)
                }
            })
        } else {
            completion(students: nil)
        }
    }
    
    static func studentWithIdentifier(identifier: String, completion: (student: Student?) -> Void) {
        FirebaseController.dataAtEndpoint("Students/\(identifier)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let student = Student(json: json, identifier: identifier)
                completion(student: student)
            } else {
                completion(student: nil)
            }
        }
    }
    
    //Update
    static func updateStudent(student: Student, name: String, parentEmail: String?, completion: (student: Student?) -> Void) {
        if let identifier = student.identifier {
            var updatedStudent = Student(userIdentifier: student.userIdentifier, name: name, parentEmail: parentEmail, imageEndpoint: student.imageEndpoint, identifier: identifier)
            updatedStudent.save()
            StudentController.studentWithIdentifier(identifier, completion: { (student) -> Void in
                if let student = student {
                    completion(student: student)
                } else {
                    completion(student: nil)
                }
            })
        }
    }
    
    static func addImageForStudent(student: Student, image: UIImage, completion: (student: Student?) -> Void) {
        if let identifier = student.imageEndpoint {
            ImageController.deleteImageWithIdentifier(identifier)
        }
        ImageController.uploadImage(image, completion: { (identifier) -> Void in
            if let imageEndpoint = identifier {
                if student.identifier != nil {
                    var updatedStudent = Student(userIdentifier: student.userIdentifier, name: student.name, parentEmail: student.parentEmail, imageEndpoint: imageEndpoint, identifier: student.identifier)
                    updatedStudent.save()
                    StudentController.studentWithIdentifier(student.identifier!, completion: { (student) -> Void in
                        if let student = student {
                            completion(student: student)
                        } else {
                            completion(student: nil)
                        }
                    })
                }
            }
        })
    }
    
    
    //Delete
    static func deleteStudent(student: Student) {
        if let identifier = student.imageEndpoint {
            ImageController.deleteImageWithIdentifier(identifier)
        }
        if let imageEndpoint = student.imageEndpoint {
            let endpointBase = FirebaseController.base.childByAppendingPath("images/\(imageEndpoint)")
            endpointBase.removeValue()
        }
        student.delete()
    }
    
}
