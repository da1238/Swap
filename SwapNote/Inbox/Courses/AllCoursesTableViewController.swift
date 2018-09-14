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
import Alamofire
import StatusAlert

class AllCoursesTableViewController: UITableViewController {
    
    //MARK: Properties
    var courses = [Course]()
    var filteredCourses = [Course]()
    var coursesCount: Int!
    var courseRef = [DocumentReference]()
    var selectedCourse: Any!
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchFooter: SearchFooter!
    
    //MARK: Variables
    let pinAlert = StatusAlert.instantiate(withImage: #imageLiteral(resourceName: "pinnedIcon"), title: "Pinned", message: "This course has been added to your pins.", canBePickedOrDismissed: true)
    
    
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
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search courses"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Setup the search footer
        tableView.tableFooterView = searchFooter
        
        setLoadingScreen()
        getRemoteCourses()
        loadData()

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
                    
//                    let notes: [DocumentReference] = data["notes"] as! [DocumentReference]
                    let noteArr: [Note] = []
//                    for note in notes {
//                        noteArr.append(Note.init(documentRef: note, downloadContent: true))
//                    }
                    
                    let course: Course = Course.init(name: name, department: department, code: code, notes: noteArr)!
                    course.ref = db.collection("courses").document(doc.documentID)
                    
                    self.courses.append(course)
                    if self.courses.count == self.coursesCount {
                        self.tableView.reloadData()
                        self.removeLoadingScreen()
                    }
                }
            } else {
                print("No Pins")
            }
        }
        
    }
    
    func loadData(){
        
        let user: User = Auth.auth().currentUser!
        let splitEmail = user.email!.split(separator: "@")
        let username: String = splitEmail.prefix(splitEmail.count - 1).joined()
        
        let docRef = Firestore.firestore().collection("users").document(username)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }

        
//        Firestore.firestore().collection("users").document(username).getDocument {
//            querySnapshot, error in
//            if let error = error {
//                print("\(error.localizedDescription)")
//            } else{
//
//                for document in querySnapshot!.data()! {
//                    print("\(document.key) => \(document.value)")
//                    self.courseRef.append(document.value)
//                }
//
//                    }
//                }
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
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCourses = courses.filter({( course: Course) -> Bool in
            return course.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredCourses.count, of: courses.count)
            return filteredCourses.count
        }
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let courseName: String = self.courses[indexPath.row].name
        let alert = UIAlertController.init(title: "Pin", message: "Do you want to pin \(courseName)?", preferredStyle: UIAlertControllerStyle.alert)
        
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.setLoadingScreen()
            let user: User = Auth.auth().currentUser!
            let splitEmail = user.email!.split(separator: "@")
            let username: String = splitEmail.prefix(splitEmail.count - 1).joined()
            UIApplication.shared.beginIgnoringInteractionEvents()
            Firestore.firestore().collection("users").document(username).getDocument(completion: {(document, error) in
                var courseArr: [DocumentReference] = document?.data()!["courses"] as! [DocumentReference]
                
                self.selectedCourse = self.courses[indexPath.row].ref
//
//                if self.courseRef.contains(where: self.selectedCourse as! (Any) throws -> Bool){
//                    print("Course already pinned")
//                }else{
                courseArr.append(self.courses[indexPath.row].ref)
                Firestore.firestore().collection("users").document(username).updateData(["courses": courseArr], completion: {(error) in
                    UIApplication.shared.endIgnoringInteractionEvents()
                })
                
//            }
            })
                
            
            self.removeLoadingScreen()
            self.pinAlert.showInKeyWindow()
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
        
        let course: Course
        
        if isFiltering() {
            course = filteredCourses[indexPath.row]
        } else {
            course = courses[indexPath.row]
        }
        
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

extension AllCoursesTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
