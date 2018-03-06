//
//  User.swift
//  Swap
//
//  Created by David Abraham on 2/7/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct User {
    var firstName:String
    var lastName: String
    
    var dictionary:[String:Any]{
        return [
            "firstName":firstName,
            "lastName": lastName

        ]
    }
}

extension User:DocumentSerialazable {
    init?(dictionary: [String:Any]) {
        guard let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String else {return nil}
        
        self.init(firstName: firstName, lastName: lastName)
        
    }
}
