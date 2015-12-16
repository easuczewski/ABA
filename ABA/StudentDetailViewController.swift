//
//  StudentDetailViewController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import UIKit

class StudentDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

// MARK: Properties
    var selectedStudent: Student?
    var programsForSelectedStudent: [Program] = [Program(studentIdentifier: "A", name: "Archaeology", domain: "Ancient History", antecedent: "A", longTermObjective: "A"), Program(studentIdentifier: "B", name: "Biology", domain: "Biological Sciences", antecedent: "B", longTermObjective: "B"), Program(studentIdentifier: "C", name: "Chaucer", domain: "Classic Lit", antecedent: "C", longTermObjective: "C")]
    var behaviorsForSelectedStudent: [Behavior] = [Behavior(studentIdentifier: "A", name: "Anger", abbreviation: "A", description: "A", withTime: "A"), Behavior(studentIdentifier: "B", name: "Biting", abbreviation: "B", description: "B", withTime: "B"), Behavior(studentIdentifier: "C", name: "Crying", abbreviation: "C", description: "C", withTime: "C")]
    var mode: Int {
        get {
            return modeSegmentedControl.selectedSegmentIndex
        }
        set { }
    }
    var filteredPrograms: [Program] = []
    var filteredBehaviors: [Behavior] = []
    var isFiltered: Bool = false
    
// MARK: UI Outlets
    
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
// MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
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
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
