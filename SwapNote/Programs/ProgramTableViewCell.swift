//
//  ProgramTableViewCell.swift
//  SwapNote
//
//  Created by David Abraham on 12/21/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit

class ProgramTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var dptTitle: UILabel!
    @IBOutlet weak var dptBanner: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
