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
    var chatName: String
    
    //MARK: Initialization
    init?(chatName: String) {
        
        if chatName.isEmpty {
            return nil
        }
        
        //Initialize stored properties
        self.chatName = chatName

        
    }
    
}
