//
//  CoursesTableViewController.swift
//  SwapNote
//
//  Created by David Abraham on 12/21/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit
import os.log

class CoursesTableViewController: UITableViewController {
        
    //MARK: Properties
    
    var courses = [Course]()
    
    private func loadSampleCourses(){
        
        guard let course1 = Course(name: "Problem Solving with Computers", code: 171, program: "CIS") else {
            fatalError("Unable to instantiate")
        }
        guard let course2 = Course(name: "Instructional Design II", code: 430, program: "ART") else {
            fatalError("Unable to instantiate")
        }
        
        courses += [course1, course2]
    }
    
    var course: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar customization
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // No Text on back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Search Bar
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        if let course = course {
            navigationItem.title = course.program
            
        }
        
        loadSampleCourses()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "Cell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CourseTableViewCell  else {
            fatalError("The dequeued cell is not an instance.")
        }
        
        let course = courses[indexPath.row]
        
        cell.courseCode.text = course.program + " " + "\(course.code)"
        cell.courseName.text = course.name
        
        return cell
    }
    
    //Swipe left to delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { action, view, completionHandler in
            print("Deleting!")
            completionHandler(true)
        }
        
        delete.backgroundColor = UIColor.red
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

