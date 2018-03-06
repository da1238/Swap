//
//  FeedTableViewCell.swift
//  SwapNote
//
//  Created by David Abraham on 1/28/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class FeedTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPost: UITextView!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicture.contentMode = UIViewContentMode.scaleAspectFit
        profilePicture.layer.cornerRadius = 20
        profilePicture.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
