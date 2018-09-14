//
//  Note.swift
//  SwapNote
//
//  Created by David Abraham on 12/25/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit
import FirebaseFirestore


struct Note {
    var photo: String
    var owner:String
    var instructor:String
    var description: String
    var title: String
    
    
    var dictionary:[String:Any]{
        return [
            "owner": owner,
            "instructor": instructor,
            "description": description,
            "photo": photo,
            "title":title,
        ]
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
