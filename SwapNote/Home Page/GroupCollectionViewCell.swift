//
//  GroupCollectionViewCell.swift
//  SwapNote
//
//  Created by David Abraham on 5/27/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var GroupImage: UIImageView!
    
    override func awakeFromNib() {
        GroupImage.contentMode = UIViewContentMode.scaleAspectFit
        GroupImage.layer.cornerRadius = GroupImage.frame.size.height/2
        GroupImage.layer.masksToBounds = true
        GroupImage.layer.borderWidth = 2
        GroupImage.layer.borderColor = UIColor(red:0.00, green:0.80, blue:0.61, alpha:1.0).cgColor
    }
}
