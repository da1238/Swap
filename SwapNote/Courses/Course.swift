//
//  Course.swift
//  SwapNote
//
//  Created by David Abraham on 12/22/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Course{
    
    //MARK: Properties
    var department: String
    var code: Int
    var name: String
    var notes: [Note]
    var ref: DocumentReference!
    
    //MARK: Initialization
    init?(name: String, department: String, code: Int, notes: [Note]) {
        if name.isEmpty || department.isEmpty {
            return nil
        }
        
        self.department = department
        self.name = name
        self.code = code
        self.notes = notes
    }
}
