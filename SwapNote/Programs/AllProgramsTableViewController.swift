//
//  AllProgramsTableViewController.swift
//  SwapNote
//
//  Created by David Abraham on 12/21/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit

class AllProgramsTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var programs = [Program]()
    
    private func loadPrograms(){

        guard let ACCT = Program(title: "Accounting", code: "ACCT", banner: #imageLiteral(resourceName: "ACCT") )else {
            fatalError("Unable to instantiate")
        }
        guard let EDUC = Program(title: "Education", code: "EDUC", banner: #imageLiteral(resourceName: "EDUC"))else {
            fatalError("Unable to instantiate")
        }
        guard let ART = Program(title: "Art (Business)", code: "ART", banner: #imageLiteral(resourceName: "ART"))else {
            fatalError("Unable to instantiate")
        }
        guard let APHS = Program(title: "Applied Health Sciences", code: "APHS", banner: #imageLiteral(resourceName: "APHS"))else {
            fatalError("Unable to instantiate")
        }

        programs += [ACCT, APHS, ART, EDUC]
    }
    
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
        
        loadPrograms()

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
        
        return programs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "Cell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProgramTableViewCell  else {
            fatalError("The dequeued cell is not an instance.")
        }
        
        
        let program = programs[indexPath.row]
        
        
        cell.dptCode.text = program.code
        cell.dptTitle.text = program.title
        cell.dptBanner.image = program.banner
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let programName: String = self.programs[indexPath.row].title
        let alert = UIAlertController.init(title: "Add Program", message: "Do you want to add \(programName) to your courses?", preferredStyle: UIAlertControllerStyle.alert)
        
        let action1 = UIAlertAction(title: "Yes", style: .default)
        let action2 = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
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
