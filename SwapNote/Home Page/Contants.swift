//
//  Contants.swift
//  SwapNote
//
//  Created by David Abraham on 2/10/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import Foundation
import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
