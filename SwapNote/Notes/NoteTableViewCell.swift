//
//  NoteTableViewCell.swift
//  SwapNote
//
//  Created by David Abraham on 12/25/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var noteTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
