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
        
        guard let Art = Program(title: "Art & Performing Arts", banner: #imageLiteral(resourceName: "Art")) else {
            fatalError("Unable to instantiate")
        }
        guard let Business = Program(title: "Business & Leadership", banner: #imageLiteral(resourceName: "Business")) else {
            fatalError("Unable to instantiate")
        }
        guard let Communication = Program(title: "Communication & Media", banner: #imageLiteral(resourceName: "Communication")) else {
            fatalError("Unable to instantiate")
        }
        guard let Education = Program(title: "Education", banner: #imageLiteral(resourceName: "Education")) else {
            fatalError("Unable to instantiate")
        }
        guard let Engineering = Program(title: "Engineering", banner: #imageLiteral(resourceName: "Engineering")) else {
            fatalError("Unable to instantiate")
        }
        guard let Finance = Program(title: "Finance & Mathematics", banner: #imageLiteral(resourceName: "Finance")) else {
            fatalError("Unable to instantiate")
        }
        guard let Government = Program(title: "Government & Law", banner: #imageLiteral(resourceName: "Government")) else {
            fatalError("Unable to instantiate")
        }
        guard let Health = Program(title: "Health & Medecine", banner: #imageLiteral(resourceName: "Health")) else {
            fatalError("Unable to instantiate")
        }
        guard let History = Program(title: "History", banner: #imageLiteral(resourceName: "History")) else {
            fatalError("Unable to instantiate")
        }
        guard let Information = Program(title: "Information Technology", banner: #imageLiteral(resourceName: "Information")) else {
            fatalError("Unable to instantiate")
        }
        guard let Language = Program(title: "Language & Culture", banner: #imageLiteral(resourceName: "Language")) else {
            fatalError("Unable to instantiate")
        }
        guard let Ministry = Program(title: "Ministry", banner: #imageLiteral(resourceName: "Ministry")) else {
            fatalError("Unable to instantiate")
        }
        guard let Outdoors = Program(title: "Outdoors", banner: #imageLiteral(resourceName: "Outdoors")) else {
            fatalError("Unable to instantiate")
        }
        guard let Social = Program(title: "Social Sciences", banner: #imageLiteral(resourceName: "Social")) else {
            fatalError("Unable to instantiate")
        }
        guard let Sustainability = Program(title: "Sustainability", banner: #imageLiteral(resourceName: "Sustainability")) else {
            fatalError("Unable to instantiate")
        }

        programs += [Art, Business, Communication, Education, Engineering, Finance, Government, Health, History, Information, Language, Ministry, Outdoors, Social, Sustainability]
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
        
        cell.dptTitle.text = program.title
        cell.dptBanner.image = program.banner
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let programName: String = self.programs[indexPath.row].title
        let alert = UIAlertController.init(title: "Subscribe", message: "Suscribe to \(programName)?", preferredStyle: UIAlertControllerStyle.alert)
        
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
