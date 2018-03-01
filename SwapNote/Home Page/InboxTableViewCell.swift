//
//  InboxTableViewCell.swift
//  SwapNote
//
//  Created by David Abraham on 2/10/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell {

    //MARK: Properites
    @IBOutlet weak var chatName: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
