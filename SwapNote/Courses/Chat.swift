//
//  Chat.swift
//  SwapNote
//
//  Created by David Abraham on 2/10/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import Foundation

class Chat {
    
    //MARK: Properties
    
    var userName: String
    var lastText: String
    
    //MARK: Initialization
    init?(userName: String, lastText: String) {
        
        if userName.isEmpty || lastText.isEmpty{
            return nil
        }
        
        //Initialize stored properties
        self.userName = userName
        self.lastText = lastText
        
    }
    
}
