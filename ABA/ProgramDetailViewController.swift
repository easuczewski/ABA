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
    
    var selectedStudent: Student?
    var selectedProgram: Program?
    var shortTermObjectivesForSelectedProgram: [ProgramShortTermObjective] = []
    var tacticsForSelectedProgram: [ProgramTactic] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section <= 3 {
            return 1
        } else if section == 4 {
            return shortTermObjectivesForSelectedProgram.count
        } else if section == 5 {
            return tacticsForSelectedProgram.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if let student = selectedStudent {
                return "Program for \(student.name)"
            } else {
                return "Program"
            }
        case 1:
            return "Domain"
        case 2:
            return "Antecedent"
        case 3:
            return "LTO - swipe to complete"
        case 4:
            return "STO - swipe to complete"
        case 5:
            return "Tactic - swipe to start/stop"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("programDetailCell", forIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame: CGRect = tableView.frame
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, headerFrame.size.width, headerFrame.size.height))
        headerView.backgroundColor = UIColor.purpleColor()

        if section == 5 {
            let button: UIButton = UIButton(type: .ContactAdd) as UIButton
//            let image = UIImage(named: "Plus")
//            button.setBackgroundImage(image, forState: .Normal)
            headerView.addSubview(button)
            let margins = headerView.layoutMarginsGuide
            let constraint = button.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
            constraint.active = true
//            button.heightAnchor.constraintEqualToAnchor(margins.heightAnchor).active = true
//            button.widthAnchor.constraintEqualToAnchor(button.heightAnchor).active = true
            button.addConstraint(constraint)
            return headerView

        } else {
            return headerView
        }
        
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
