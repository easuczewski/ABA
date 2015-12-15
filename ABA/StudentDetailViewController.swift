//
//  StudentDetailViewController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import UIKit

class StudentDetailViewController: UIViewController {

// MARK: Properties
    var selectedStudent: Student?
    var programsForSelectedStudent: [Program] = []
    var behaviorsForSelectedStudent: [Behavior] = []
    var mode: Int {
        get {
            return modeSegmentedControl.selectedSegmentIndex
        }
    }

// MARK: UI Outlets
    
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
