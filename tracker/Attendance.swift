//
//  Attendance.swift
//  tracker
//
//  Created by Joseph Liu on 3/17/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import UIKit

class Attendance{
    var id: String
    var memberId: String
    var dateId: String
    var memberName: String
    var dateString: String
    
    init(id: String, memberId: String, dateId: String, memberName: String, dateString: String){
        self.id = id
        self.memberId = memberId
        self.dateId = dateId
        self.memberName = memberName
        self.dateString = dateString
    }
}
