//
//  FeedTableViewController.swift
//  SwapNote
//
//  Created by David Abraham on 1/28/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FeedTableViewController: UITableViewController {
    
    //MARK: Properties
    let databaseRef = Database.database().reference()
    
    //MARK: Variables
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    // Database Reference
    var database = Firestore.firestore()
    var postArray = [Post]()
    
    override func viewDidLoad() {
    
        self.refreshControl?.addTarget(self, action: #selector(FeedTableViewController.updateFeed), for: UIControlEvents.valueChanged)
        
        // Activity Indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
//        UIApplication.shared.beginIgnoringInteractionEvents()
        
        super.viewDidLoad()

        loadData()
        updateFeed()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composePressed))
        
    }
    
    func loadData(){
        
        database.collection("posts").getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
                self.refreshControl?.endRefreshing()
            } else{
                self.postArray = querySnapshot!.documents.flatMap({Post(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
//                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
        
    }
    
    @objc func updateFeed(){
        
        database.collection("posts").whereField("timeStamp", isGreaterThan: Date())
            .addSnapshotListener{
                querySnapshot, error in
                
                guard let snapshot = querySnapshot else {return}
                
                snapshot.documentChanges.forEach{
                    diff in
                    
                    if diff.type == .added{
                        self.postArray.append(Post(dictionary: diff.document.data())!)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    }
                }
        }
    }
    
    
    @objc func composePressed(sender: UIBarButtonItem){

        performSegue(withIdentifier: "newPost", sender: nil)
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
    
        return postArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
   
        let cell: FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        let post = postArray[indexPath.row]
        
        cell.activityIndicator.startAnimating()
        cell.lblPost.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.lblPost?.text = post.content
        cell.lblUserName?.text = post.userName
        cell.lblFirstName.text = post.name
        cell.lblTimeStamp?.text = post.timeStamp.toString(dateFormat: "dd/MM/YYYY")
        
        
        if let uid = Auth.auth().currentUser?.uid{
            
            let storageRef = Storage.storage().reference().child("profile_picture").child(uid)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (data == nil) {
                    cell.profilePicture.image = #imageLiteral(resourceName: "UserIcon")
                }
                else {
                let pic = UIImage(data: post.photo)
                cell.profilePicture.image = pic
                cell.activityIndicator.stopAnimating()
                }
            }
        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Auto resizing Table cells
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
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
