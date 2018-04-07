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

class FeedTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    //MARK: Properties
    let databaseRef = Database.database().reference()
    
    //MARK: Variables
    
    //Loading Screen
    let loadingView = UIView()
    let loadingLabel = UILabel()
    let spinner = UIActivityIndicatorView()
    
    var noPic: UIImage!
    
    // Database Reference
    var database = Firestore.firestore()
    var postArray = [Post]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Refresh Control
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(FeedTableViewController.updateData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!)
        
        setLoadingScreen()
        loadData()
        updateFeed()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composePressed))
        
        // Empty Data Set
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
    }
    
    func loadData(){
        
        database.collection("posts").getDocuments() {
            querySnapshot, error in
            self.setLoadingScreen()
            if let error = error {
                print("\(error.localizedDescription)")
            } else{
                self.postArray = querySnapshot!.documents.flatMap({Post(dictionary: $0.data())})
                DispatchQueue.main.async {
                    if self.postArray.count == 0{
                        self.removeLoadingScreen()
                    }else{
                        self.removeLoadingScreen()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func updateData(){
        
        database.collection("posts").getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else{
                self.postArray = querySnapshot!.documents.flatMap({Post(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    func updateFeed(){
        
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
                        }
                    }
                }
        }
    }
    
    
    @objc func composePressed(sender: UIBarButtonItem){
        
        performSegue(withIdentifier: "newPost", sender: nil)
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
        
        return postArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell: FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        let post = postArray[indexPath.row]
        
        cell.activityIndicator.startAnimating()
        cell.lblPost.textContainerInset = UIEdgeInsetsMake(0, 0, 10, 0)
        cell.lblPost?.text = post.content
        cell.lblUserName?.text = post.userName
        cell.lblFirstName.text = post.name
        cell.lblTimeStamp?.text = post.timeStamp.toString(dateFormat: "dd/MM/YYYY")
        
        
        if let uid = Auth.auth().currentUser?.uid{
            
            let storageRef = Storage.storage().reference().child("profile_picture").child(uid)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (data == nil) {
                    cell.profilePicture.image = self.noPic
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
        
        updateFeed()
        // Auto resizing Table cells
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    // Empty Data Sets
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Welcome to the Feed."
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "The latest posts from your subscribed programs will appear here."
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyFeed")
    }
    
}
