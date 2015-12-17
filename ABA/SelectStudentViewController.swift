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
    
    // MARK: Alerts
    func confirmDeleteAlertForStudent(student: Student, indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "Delete \(student.name)?", message: "Are you sure you want to permanently delete \(student.name) and all of this student's program data?", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (_) -> Void in
            StudentController.deleteStudent(student)
            self.studentsForCurrentUser.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Methods
    func checkForUpdates() {
        if let user = UserController.sharedController.currentUser {
            StudentController.studentsForUser(user, completion: { (students) -> Void in
                if let students = students {
                    self.studentsForCurrentUser = students
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            })
        }
    }
    
    // MARK: View Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        checkForUpdates()
    }
    
    // MARK: TableView Data Source & TableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsForCurrentUser.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell",
            forIndexPath: indexPath)
        let student = studentsForCurrentUser[indexPath.row]
        cell.textLabel?.text = student.name
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete",
            handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
                self.confirmDeleteAlertForStudent(self.studentsForCurrentUser[indexPath.row], indexPath: indexPath)
        })
        deleteAction.backgroundColor = UIColor.redColor()
        return [deleteAction]
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editStudent" {
            if let studentDetailViewController = segue.destinationViewController as? StudentDetailViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                    studentDetailViewController.selectedStudent = self.studentsForCurrentUser[indexPath.row]
                    studentDetailViewController.isAdding = false
                }
            }
        }
    }
    
}
