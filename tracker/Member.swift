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
    var attendance: [Attendance] = []
    
    init(id: String, name : String, g_id : String){
        self.id = id
        self.name = name
        self.g_id = g_id
    }
    
    func description() -> String {
        return name
    }
    
    func addAttendance(attendanceObj: Attendance){
        attendance.append(attendanceObj)
    }
    
    func setAttendanceArr(attendanceArr: [Attendance]){
        attendance = attendanceArr
    }
    
    func getAttendanceString() -> String{
        if(attendance.count == 0){
            return "No Attendance Records"
        }else{
            var str = ""
            for attendanceObj in attendance{
                str += getFormattedDateFromDateString(dateString: attendanceObj.dateString) + "\n"
            }
            return str.substring(to: str.index(str.endIndex, offsetBy: -1))
        }
    }
    
    func getFormattedDateFromDateString(dateString: String) -> String{
        let year = String(describing: Int(dateString.substring(to: dateString.index(dateString.startIndex, offsetBy: 4)))!)
        
        let month = Int(dateString.substring(with: dateString.index(dateString.startIndex, offsetBy: 5)..<dateString.index(dateString.startIndex, offsetBy: 7)))
        let day = String(describing: Int(dateString.substring(with: dateString.index(dateString.startIndex, offsetBy: 8)..<dateString.index(dateString.startIndex, offsetBy: 10)))!)
        
        return Constants.monthArr[month! - 1] + " " + day + ", " + year
    }
}
