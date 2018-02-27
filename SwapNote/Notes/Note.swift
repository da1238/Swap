//
//  Note.swift
//  SwapNote
//
//  Created by David Abraham on 12/25/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit

class Note {

    //MARK: Properties
    var name: String
    var rating: Int
    var createdBy: String
    var courseTitle: String
    var courseNumber: Int
    let dateCreated = Date()
    
    
    //MARK: Inititialization
    init?(name: String, createdBy: String, courseTitle: String, courseNumber: Int) {
        
        if name.isEmpty || createdBy.isEmpty || courseTitle.isEmpty || courseNumber < 0{
            return nil
        }
        
        // Initiliaze stored properties
        self.name = name
        self.rating = 0
        self.createdBy = createdBy
        self.courseTitle = courseTitle
        self.courseNumber = courseNumber
    }
    
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
