//
//  CourseTableViewCell.swift
//  SwapNote
//
//  Created by David Abraham on 12/22/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var courseCode: UILabel!
    @IBOutlet weak var courseName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
