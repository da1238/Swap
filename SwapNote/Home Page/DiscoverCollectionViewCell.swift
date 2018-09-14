//
//  DiscoverCollectionViewCell.swift
//  SwapNote
//
//  Created by David Abraham on 5/28/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var discoverImage: UIImageView!
    
    override func awakeFromNib() {
        
        discoverImage.layer.cornerRadius = 15
        discoverImage.layer.masksToBounds = true
    }
}
