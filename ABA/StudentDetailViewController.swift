//
//  StudentDetailViewController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import UIKit

class StudentDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    var selectedStudent: Student?
    var programsForSelectedStudent: [Program] = [Program(studentIdentifier: "a", name: "Arithmetic", domain: "Math", antecedent: "a", longTermObjective: "a"), Program(studentIdentifier: "b", name: "Bottle Opening", domain: "OT", antecedent: "b", longTermObjective: "b"), Program(studentIdentifier: "c", name: "Counting", domain: "Math", antecedent: "c", longTermObjective: "c"), Program(studentIdentifier: "d", name: "Directions (verbal)", domain: "Communication", antecedent: "d", longTermObjective: "d"), Program(studentIdentifier: "e", name: "Estimating Money", domain: "Math", antecedent: "e", longTermObjective: "e"), Program(studentIdentifier: "f", name: "Fingerpainting", domain: "OT", antecedent: "f", longTermObjective: "f"), Program(studentIdentifier: "g", name: "Grip Pencil", domain: "OT", antecedent: "g", longTermObjective: "g"), Program(studentIdentifier: "h", name: "Handling Coins", domain: "OT", antecedent: "h", longTermObjective: "h")]
    var behaviorsForSelectedStudent: [Behavior] = [Behavior(studentIdentifier: "s", name: "Scripting", abbreviation: "s", description: "s", withTime: "s"), Behavior(studentIdentifier: "c", name: "Crying", abbreviation: "c", description: "c", withTime: "c"), Behavior(studentIdentifier: "b", name: "Biting", abbreviation: "b", description: "b", withTime: "b"), Behavior(studentIdentifier: "e", name: "Eating Penicl Erasers", abbreviation: "e", description: "e", withTime: "e")]
    var mode: Int {
        get {
            return modeSegmentedControl.selectedSegmentIndex
        }
    }
    var filteredPrograms: [Program] = []
    var filteredBehaviors: [Behavior] = []
    var isFiltered: Bool = false
    var isAdding: Bool = true
    
    // MARK: UI Outlets
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var studentNameTextField: UITextField!
    @IBOutlet weak var parentEmailTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    
    // MARK: Alerts
    func addStudentAlert() {
        let alert = UIAlertController(title: "Add New Student", message: "Let's get started by giving your new student a name.", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "student name"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (_) -> Void in
            guard let textFields = alert.textFields else {
                return
            }
            if let userIdentifier = UserController.sharedController.currentUser?.identifier {
                if let name = textFields[0].text {
                    if name != "" {
                        StudentController.createStudentWithName(name, userIdentifier: userIdentifier, completion: { (student) -> Void in
                            if let student = student {
                                self.selectedStudent = student
                            }
                        })
                    }
                }
            }
            if let student = self.selectedStudent {
                self.studentNameTextField.text = student.name
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func photoChoiceAlertForImagePicker(imagePicker: UIImagePickerController) {
        let photoChoiceAlert = UIAlertController(title: "Select Photo Option", message: nil, preferredStyle: .ActionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            photoChoiceAlert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            photoChoiceAlert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        photoChoiceAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(photoChoiceAlert, animated: true, completion: nil)
    }
    
    // MARK: Methods
    func checkForUpdates() {
        if let student = self.selectedStudent {
            self.studentNameTextField.text = student.name
            if let parentEmail = student.parentEmail {
                self.parentEmailTextField.text = parentEmail
            }
            if let imageEndpoint = student.imageEndpoint {
                ImageController.imageForIdentifier(imageEndpoint, completion: { (image) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.imageButton.setBackgroundImage(image, forState: .Normal)
                        self.imageButton.setTitle("", forState: .Normal)
                    })
                })
            }
            ProgramController.programsForStudent(student, completion: { (programs) -> Void in
                if let programs = programs {
                    self.programsForSelectedStudent = programs
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            })
            BehaviorController.behaviorsForStudent(student, completion: { (behaviors) -> Void in
                if let behaviors = behaviors {
                    self.behaviorsForSelectedStudent = behaviors
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            })
        }
    }
    
    func saveStudent() {
        if let student = selectedStudent {
            if let name = studentNameTextField.text {
                if studentNameTextField.text != "" {
                    StudentController.updateStudent(student, name: name, parentEmail: parentEmailTextField.text, completion: { (student) -> Void in
                        if let student = student {
                            self.selectedStudent = student
                        }
                    })
                }
            }
        }
    }
    

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        if isAdding {
            addStudentAlert()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.checkForUpdates()
    }

    // MARK: UI Actions
    @IBAction func modeChanged(sender: UISegmentedControl) {
        tableView.reloadData()
        if mode == 0 {
            searchBar.placeholder = "Search for a program name or domain"
        } else {
            searchBar.placeholder = "Search for a behavior"
        }
    }
    
    @IBAction func addPhotoButtonTapped(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        photoChoiceAlertForImagePicker(imagePicker)
    }
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        saveStudent()
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        if mode == 0 {
            self.performSegueWithIdentifier("addProgram", sender: nil)
        } else if mode == 1 {
            self.performSegueWithIdentifier("addBehavior", sender: nil)
        }
    }
    
    // MARK: UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isFiltered = false
        } else {
            isFiltered = true
            filteredPrograms = programsForSelectedStudent.filter(({($0.name.lowercaseString.containsString(searchText))||($0.domain.lowercaseString.containsString(searchText))}))
            filteredBehaviors = behaviorsForSelectedStudent.filter(({$0.name.lowercaseString.containsString(searchText)}))
        }
        self.tableView.reloadData()
    }
    
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        if let student = self.selectedStudent {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                StudentController.addImageForStudent(student, image: image) { (student) -> Void in
                    if let student = student {
                        self.selectedStudent = student
                        if let imageEndpoint = student.imageEndpoint {
                            ImageController.imageForIdentifier(imageEndpoint, completion: { (image) -> Void in
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.imageButton.setBackgroundImage(image, forState: .Normal)
                                    self.imageButton.setTitle("", forState: .Normal)
                                })
                            })
                        }
                    }
                }
            }
        }
        
    }
    
    // MARK: TableView Data Source & TableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered == false {
            if mode == 0 {
                return programsForSelectedStudent.count
            } else {
                return behaviorsForSelectedStudent.count
            }
        } else {
            if mode == 0 {
                return filteredPrograms.count
            } else {
                return filteredBehaviors.count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("programBehaviorCell", forIndexPath: indexPath)
        if isFiltered == false {
            if mode == 0 {
                cell.textLabel?.text = programsForSelectedStudent[indexPath.row].name
                cell.detailTextLabel?.text = programsForSelectedStudent[indexPath.row].domain
            } else {
                cell.textLabel?.text = behaviorsForSelectedStudent[indexPath.row].name
                cell.detailTextLabel?.text = behaviorsForSelectedStudent[indexPath.row].key
            }
        } else {
            if mode == 0 {
                cell.textLabel?.text = filteredPrograms[indexPath.row].name
                cell.detailTextLabel?.text = filteredPrograms[indexPath.row].domain
            } else {
                cell.textLabel?.text = filteredBehaviors[indexPath.row].name
                cell.detailTextLabel?.text = filteredBehaviors[indexPath.row].key
            }
        }
        return cell
    }


}
