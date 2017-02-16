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
    var g_id : String
    
    init(id: String, name : String, g_id : String){
        self.id = id
        self.name = name
        self.g_id = g_id
    }
    
    func description() -> String {
        return name
    }
}
