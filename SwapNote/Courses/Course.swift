//
//  Course.swift
//  SwapNote
//
//  Created by David Abraham on 12/22/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit

class Course {
    
    //MARK: Properties
    
    var code: Int
    var name: String
    var program: String
    
    //MARK: Initialization
    init?(name: String, code: Int, program: String) {
        
        if name.isEmpty || code < 0 || program.isEmpty{
            return nil
        }
        
        //Initialize stored properties
        self.name = name
        self.code = code
        self.program = program
    }

}
