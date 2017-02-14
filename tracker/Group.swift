//
//  Group.swift
//  tracker
//
//  Created by Joseph Liu on 2/14/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import UIKit

class Group: NSObject, NSCoding {
    var id : String
    var name : String
    var owner : String
    
    init(id: String, name: String, owner: String){
        self.id = id
        self.name = name
        self.owner = owner
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.owner = aDecoder.decodeObject(forKey: "owner") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.owner, forKey: "owner")
    }
}
