//
//  Section.swift
//  SwapNote
//
//  Created by David Abraham on 3/12/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import Foundation

struct Section{
    var title: String!
    var courses: [String]!
    var expanded: Bool!
    
    init(title: String, courses: [String]!, expanded: Bool) {
        self.title = title
        self.courses = courses
        self.expanded = expanded
    }
}
