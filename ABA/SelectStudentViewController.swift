//
//  SelectStudentViewController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import UIKit

class SelectStudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    var studentsForCurrentUser: [Student] = []
    
    // MARK: UIOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = UserController.sharedController.currentUser {
            StudentController.studentsForUser(user, completion: { (students) -> Void in
                if let students = students {
                    self.studentsForCurrentUser = students
                }
            })
        }
    }
    
    // MARK: Table View DataSource & Table View Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsForCurrentUser.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell",
            forIndexPath: indexPath)
        let student = studentsForCurrentUser[indexPath.row]
        cell.textLabel?.text = student.name
        if let imageEndpoint = student.imageEndpoint {
            ImageController.imageForIdentifier(imageEndpoint, completion: { (image) -> Void in
                if let image = image {
                    cell.imageView?.image = image
                }
            })
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editStudent" {
            if let studentDetailViewController = segue.destinationViewController as? StudentDetailViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                    studentDetailViewController.selectedStudent = self.studentsForCurrentUser[indexPath.row]
                }
            }
        }
    }
    
}
