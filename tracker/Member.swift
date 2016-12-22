//
//  Member.swift
//  tracker
//
//  Created by Joseph Liu on 12/22/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class Member {
    var id : String
    var name : String
    var g_id : Int
    var email : String
    
    init(id: String, name : String, g_id : Int, email : String){
        self.id = id
        self.name = name
        self.g_id = g_id
        self.email = email
    }
    
    func description() -> String {
        return name
    }
}
