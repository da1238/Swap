//
//  CoursesTableViewController.swift
//  SwapNote
//
//  Created by David Abraham on 12/21/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import os.log

class CoursesTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
        
    //MARK: Properties
    var courses = [Course]()
    var coursesCount: Int!
    
    //MARK: Variables
    
    //Loading Screen
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    
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
        
        // Empty Data Set
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
    }
    
    private func getRemoteCourses() {
        if let user: User = Auth.auth().currentUser {
            let splitEmail = user.email!.split(separator: "@")
            let username: String = splitEmail.prefix(splitEmail.count - 1).joined()
            
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(username)
            courses = []
            
            docRef.getDocument { (document, error) in
                if let document = document {
                    let courseRefs = document.data()!["courses"] as! [DocumentReference]
                    self.coursesCount = courseRefs.count
                    
                    if self.coursesCount != 0{
                        for courseRef in courseRefs {
                        self.fetchCourse(withRef: courseRef)
                    }
                        print("Document data: \(String(describing: document.data()))")
                } else { 
                    print("Document does not exist")
                    self.removeLoadingScreen()
                }
            }
        }
    }
}
    
    private func fetchCourse(withRef: DocumentReference) {
        withRef.getDocument(completion: {(document, error) in
            if let document = document {
                let data = document.data()
                let department: String = data!["department"] as! String
                let code: Int = data!["code"] as! Int
                let name: String = data!["name"] as! String
                let notes: [DocumentReference] = data!["notes"] as! [DocumentReference]
                var noteArr: [Note] = []
                
                for note in notes {
                    noteArr.append(Note.init(documentRef: note, downloadContent: true))
                }
                
                let course: Course = Course.init(name: name, department: department, code: code, notes: noteArr)!
                course.ref = withRef
                
                self.courses.append(course)
                if self.courses.count == self.coursesCount {
                    self.tableView.reloadData()
                    self.removeLoadingScreen()

                }
            } else {}
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRemoteCourses()

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
        performSegue(withIdentifier: "showNotes", sender: courses[indexPath.row])
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
    
    //Swipe left to delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let unpin = UIContextualAction(style: .normal, title: "Unpin") { action, view, completionHandler in
            
            self.setLoadingScreen()
                let user: User = Auth.auth().currentUser!
                let splitEmail = user.email!.split(separator: "@")
                let username: String = splitEmail.prefix(splitEmail.count - 1).joined()
                UIApplication.shared.beginIgnoringInteractionEvents()
                Firestore.firestore().collection("users").document(username).getDocument(completion: {(document, error) in
                    var courseArr: [DocumentReference] = document?.data()!["courses"] as! [DocumentReference]
                    
                    if let index = courseArr.index(of: self.courses[indexPath.row].ref) {
                        courseArr.remove(at: index)
                    }
                    Firestore.firestore().collection("users").document(username).updateData(["courses": courseArr], completion: {(error) in
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.courses.remove(at: indexPath.row)
//                        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.right)
                        self.tableView.reloadData()
                        self.getRemoteCourses()
                        self.removeLoadingScreen()
                    })
                })
        }
        
        unpin.backgroundColor = UIColor.red
        unpin.image = UIImage(named: "unPin")
        let config = UISwipeActionsConfiguration(actions: [unpin])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    // Empty Data Sets
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Pin Your Courses."
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Tap the the plus button above to browse and add a course."
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyPin")
    }

}

