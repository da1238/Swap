//
//  CreateChatTableViewCell.swift
//  SwapNote
//
//  Created by David Abraham on 4/22/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit

class CreateChannelCell: UITableViewCell {
    
    @IBOutlet weak var newChannelNameField: UITextField!
    @IBOutlet weak var createChannelButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
