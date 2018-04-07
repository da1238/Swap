//
//  AllCoursesTableViewController.swift
//  SwapNote
//
//  Created by David Abraham on 3/30/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class AllCoursesTableViewController: UITableViewController {
    
    //MARK: Properties
    var courses = [Course]()
    var coursesCount: Int!
    
    //MARK: Variables
    
    //Loading Screen
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    
    // Database Reference
    var database = Firestore.firestore()
    let databaseRef = Database.database().reference()
    
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
        
        setLoadingScreen()
        getRemoteCourses()

    }
    
    
    func getRemoteCourses() {
        
        let db = Firestore.firestore()
        let docRef = db.collection("courses")
        courses = []
        
        docRef.getDocuments { (document, error) in
            if let document = document
            {
                self.coursesCount = document.documents.count
                for doc in document.documents
                {
                    let data = doc.data()
                    let department: String = data["department"] as! String
                    let code: Int = data["code"] as! Int
                    let name: String = data["name"] as! String
                    let notes: [DocumentReference] = data["notes"] as! [DocumentReference]
                    var noteArr: [Note] = []
                    
                    for note in notes {
                        noteArr.append(Note.init(documentRef: note, downloadContent: true))
                    }
                    
                    let course: Course = Course.init(name: name, department: department, code: code, notes: noteArr)!
                    course.ref = db.collection("courses").document(doc.documentID)
                    
                    self.courses.append(course)
                    if self.courses.count == self.coursesCount {
                        self.tableView.reloadData()
                        self.removeLoadingScreen()
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        loadingView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.width, height: tableView.frame.height-200)
        loadingView.backgroundColor = UIColor.white
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = .gray
        spinner.center = self.loadingView.center
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingView.isHidden = true
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let courseName: String = self.courses[indexPath.row].name
        let alert = UIAlertController.init(title: "Pin", message: "Pin \(courseName)?", preferredStyle: UIAlertControllerStyle.alert)
        
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.setLoadingScreen()
            let user: User = Auth.auth().currentUser!
            let splitEmail = user.email!.split(separator: "@")
            let username: String = splitEmail.prefix(splitEmail.count - 1).joined()
            UIApplication.shared.beginIgnoringInteractionEvents()
            Firestore.firestore().collection("users").document(username).getDocument(completion: {(document, error) in
                var courseArr: [DocumentReference] = document?.data()!["courses"] as! [DocumentReference]
                courseArr.append(self.courses[indexPath.row].ref)
                Firestore.firestore().collection("users").document(username).updateData(["courses": courseArr], completion: {(error) in
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.navigationController?.popViewController(animated: true)
                    self.tableView.reloadData()
                })
                
            })
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CourseTableViewCell  else {
            fatalError("The dequeued cell is not an instance.")
        }
        
        let course = courses[indexPath.row]
        
        cell.courseCode.text = course.department + " " + "\(course.code)"
        cell.courseName.text = course.name
        
        return cell
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
