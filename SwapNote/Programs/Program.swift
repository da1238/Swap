//
//  Program.swift
//  SwapNote
//
//  Created by David Abraham on 12/21/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit

class Program {
    
    //MARK: Properties
    
    var title: String
    var code: String
    var banner: UIImage
    
    //MARK: Initializers
    
    init?(title: String, code: String, banner: UIImage) {
        // Initialization should fail if there is no name or if the rating is negative.
        if title.isEmpty || code.isEmpty  {
            return nil
        }
        
        //Initialize stored properties
        self.title = title
        self.code = code
        self.banner = banner
        
        
    }
    
}
