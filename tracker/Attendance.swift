//
//  Attendance.swift
//  tracker
//
//  Created by Joseph Liu on 12/23/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class Attendance {
    var dateId : String!
    var dateString: String!
    var membersArr: [Member]
    
    init(dateId: String, dateString: String){
        self.dateId = dateId
        self.dateString = dateString
        self.membersArr = []
    }
    
    func getCount() -> Int{
        return membersArr.count
    }
    
    func printArr(){
        for member in membersArr{
            NSLog(dateString + " | Name: " + member.name)
        }
    }
}
