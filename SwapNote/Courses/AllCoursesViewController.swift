//
//  AllCoursesViewController.swift
//  SwapNote
//
//  Created by David Abraham on 3/12/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit

class AllCoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sections = [
        Section(title: "Academic English Program (IAEP)", courses: [], expanded: false),
        Section(title: "Accounting (ACCT)", courses: [], expanded: false),
        Section(title: "Adventure Education (ADED) ", courses: [], expanded: false),
        Section(title: "Applied Health Science (APHS)", courses: [], expanded: false),
        Section(title: "Art (ART)", courses: [], expanded: false),
        Section(title: "Art History (ARTH)", courses: [], expanded: false),
        Section(title: "Athletic Training", courses: [], expanded: false),
        Section(title: "Bible (BIBL)", courses: [], expanded: false),
        Section(title: "Biology (BIOL)", courses: ["Life Sciences (106)"], expanded: false),
        Section(title: "Business Administration (BUSA)", courses: [], expanded: false),
        Section(title: "Chemistry (CHEM)", courses: [], expanded: false),
        Section(title: "Chinese (CHIN)", courses: [], expanded: false),
        Section(title: "Christian Ministries (CHRM)", courses: [], expanded: false),
        Section(title: "Communications (COMM)", courses: [], expanded: false),
        Section(title: "Computer Science (CIS)", courses: ["Computer Programming I (181)"], expanded: false),
        Section(title: "Counseling (COUN)", courses: [], expanded: false),
        Section(title: "Criminal Justice (CRIJ)", courses: [], expanded: false),
        Section(title: "Dance (DANC)", courses: [], expanded: false),
        Section(title: "Digital Media (DIGM)", courses: [], expanded: false),
        Section(title: "Economics (ECON)", courses: [], expanded: false),
        Section(title: "Education (EDUC)", courses: [], expanded: false),
        Section(title: "Engineering (ENGR)", courses: [], expanded: false),
        Section(title: "English (ENGL)", courses: [], expanded: false),
        Section(title: "External Program (EXPR)", courses: [], expanded: false),
        Section(title: "Finance (FINA)", courses: [], expanded: false),
        Section(title: "French (FREN)", courses: [], expanded: false),
        Section(title: "General Studies (GEST)", courses: [], expanded: false),
        Section(title: "German (GERM)", courses: [], expanded: false),
        Section(title: "Greek (GREK)", courses: [], expanded: false),
        Section(title: "Health, Physical Education (HPED)", courses: [], expanded: false),
        Section(title: "Hebrew (HEBR)", courses: [], expanded: false)
        
        
        
      
       
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar customization
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Search Bar
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].courses.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded){
           return 44
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Expandable()
        header.customInit(title: sections[section].title, section: section, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = sections[indexPath.section].courses[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell!
    }
    func toggleSection(header: Expandable, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        for i in 0 ..< sections[section].courses.count{
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController.init(title: "Add Course", message: "Do you want to add this course to your pins?", preferredStyle: UIAlertControllerStyle.alert)
        
        let action1 = UIAlertAction(title: "Yes", style: .default)
        let action2 = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
