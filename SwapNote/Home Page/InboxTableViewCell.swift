//
//  InboxTableViewCell.swift
//  SwapNote
//
//  Created by David Abraham on 2/10/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lastText: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicture.contentMode = UIViewContentMode.scaleAspectFit
        profilePicture.layer.cornerRadius = 25
        profilePicture.layer.masksToBounds = true
        
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
