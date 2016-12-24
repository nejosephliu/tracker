//
//  Attendance.swift
//  tracker
//
//  Created by Joseph Liu on 12/23/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class Attendance {
    var date : String!
    var membersArr: [Member]
    
    init(date: String, membersArr: [Member]){
        self.date = date
        self.membersArr = membersArr
    }
    
    func getCount() -> Int{
        return membersArr.count
    }
    
}
