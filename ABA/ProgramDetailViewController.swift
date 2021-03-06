//
//  ProgramDetailViewController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import UIKit
@IBDesignable

class ProgramDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    var selectedStudent: Student?
    var selectedProgram: Program?
    var shortTermObjectivesForSelectedProgram: [ProgramShortTermObjective] = []
    var tacticsForSelectedProgram: [ProgramTactic] = []
    var sectionTitleArray: [String] = ["Program", "Domain", "Antecedent", "LTO - swipe to complete", "STO - swipe to complete", "Tactics - swipe to begin or end"]
    var defaultCellTitleArray: [String] = ["Tap to add program name", "Tap to add domain", "Tap to add antecedent", "Tap to add long-term objective", "Tap to add a short-term objective", "Tap to add a tactic"]
    
    // MARK: UIOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let student = selectedStudent {
            sectionTitleArray[0] = "Program for \(student.name)"
        }
        if let program = selectedProgram {
            ProgramShortTermObjectiveController.programShortTermObjectivesForProgram(program, completion: { (programShortTermObjectives) -> Void in
                if let objectives = programShortTermObjectives {
                    self.shortTermObjectivesForSelectedProgram = objectives
                }
            })
            ProgramTacticController.programTacticsForProgram(program, completion: { (programTactics) -> Void in
                if let tactics = programTactics {
                    self.tacticsForSelectedProgram = tactics
                }
            })
        }
    
    }
    
    // MARK: UIActions
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
    }
    
    
    
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section <= 3 {
            return 1
        } else if section == 4 {
            if shortTermObjectivesForSelectedProgram.count == 0 {
                return 1
            } else {
                return shortTermObjectivesForSelectedProgram.count
            }
        } else if section == 5 {
            if tacticsForSelectedProgram.count == 0 {
                return 1
            } else {
                return shortTermObjectivesForSelectedProgram.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let textFieldCell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as! TextFieldCell
        let textFieldWithDetailCell = tableView.dequeueReusableCellWithIdentifier("textFieldWithDetailCell", forIndexPath: indexPath) as! TextFieldWithDetailCell
        if let program = selectedProgram {
            let programCellTitleArray: [String] = [program.name, program.domain, program.antecedent, program.longTermObjective]
            if indexPath.section <= 3 {
                textFieldCell.updateWithText(programCellTitleArray[indexPath.section])
                return textFieldCell
            } else if indexPath.section == 4 {
                if shortTermObjectivesForSelectedProgram.count == 0 {
                    textFieldWithDetailCell.updateWithText(self.defaultCellTitleArray[indexPath.section], detail: "")
                } else {
                    let shortTermObjective: ProgramShortTermObjective = shortTermObjectivesForSelectedProgram[indexPath.row]
                    ProgramShortTermObjectiveController.completionDateStringForProgramShortTermObjective(shortTermObjective, completion: { (dateString) -> Void in
                        textFieldWithDetailCell.updateWithText(shortTermObjective.name, detail: dateString)
                    })
                }
                return textFieldWithDetailCell
            } else if indexPath.section == 5 {
                if tacticsForSelectedProgram.count == 0 {
                    textFieldWithDetailCell.updateWithText(self.defaultCellTitleArray[indexPath.section], detail: "")
                } else {
                    let tactic: ProgramTactic = tacticsForSelectedProgram[indexPath.row]
                    ProgramTacticController.startStopDateStringForProgramTactic(tactic, completion: { (dateString) -> Void in
                        textFieldWithDetailCell.updateWithText(tactic.name, detail: dateString)
                    })
                }
                return textFieldWithDetailCell
            } else {
                return textFieldCell
            }
        } else {
            return textFieldCell
        }
    }
                
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame: CGRect = tableView.frame
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, headerFrame.size.width, headerFrame.size.height))
        headerView.backgroundColor = UIColor.lightGrayColor()
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = sectionTitleArray[section]
        headerView.addSubview(title)
        let margins = headerView.layoutMarginsGuide
        let titleXConstraint = title.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 5)
        let titleYConstraint = title.centerYAnchor.constraintEqualToAnchor(margins.centerYAnchor)
        headerView.addConstraints([titleXConstraint, titleYConstraint])
        if section == 4 || section == 5 {
            let button: UIButton = UIButton(type: .System) as UIButton
            let image = UIImage(named: "Plus")
            button.setBackgroundImage(image, forState: .Normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.enabled = true
            headerView.addSubview(button)
            let buttonXConstraint = button.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
            let buttonYConstraint = button.centerYAnchor.constraintEqualToAnchor(margins.centerYAnchor)
            headerView.addConstraints([buttonXConstraint, buttonYConstraint])
        }
        return headerView
    }
    
        
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
