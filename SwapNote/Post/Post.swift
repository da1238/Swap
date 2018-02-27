//
//  Post.swift
//  SwapNote
//
//  Created by David Abraham on 2/3/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerialazable {
    init?(dictionary:[String:Any])
}

struct Post {
    var photo: Data
    var name:String
    var userName:String
    var content: String
    var timeStamp: Date
    
    
    var dictionary:[String:Any]{
        return [
            "name": name,
            "photo": photo,
            "userName":userName,
            "content":content,
            "timeStamp":timeStamp,
        ]
    }
}

extension Post:DocumentSerialazable {
    init?(dictionary: [String:Any]) {
        guard let userName = dictionary["userName"] as? String,
        let photo = dictionary["photo"] as? Data,
        let name = dictionary["name"] as? String,
        let content = dictionary["content"] as? String,
        let timeStamp = dictionary["timeStamp"] as? Date else {return nil}
        
        self.init(photo: photo, name: name, userName: userName, content: content, timeStamp: timeStamp)
        
    }
}
