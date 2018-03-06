//
//  InboxTableViewController.swift
//  SwapNote
//
//  Created by David Abraham on 2/10/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit

class InboxTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var chats = [Chat]()
    
    private func loadSampleChat(){
        
        guard let chat1 = Chat(chatName: "David") else {
            fatalError("Error")
        }
        
        chats += [chat1]
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
        
        loadSampleChat()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? InboxTableViewCell  else {
            fatalError("The dequeued cell is not an instance.")
        }
        
        let chat = chats[indexPath.row]
        
        cell.chatName.text = "CIS Group Chat"
        

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
    
    //Swipe right to mark as read
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let read = UIContextualAction(style: .normal, title: "Mark as read") { action, view, completionHandler in
            print("Marking as read!")
            completionHandler(true)
        }
        
        read.backgroundColor = UIColor.blue
        
        return UISwipeActionsConfiguration(actions: [read])
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
