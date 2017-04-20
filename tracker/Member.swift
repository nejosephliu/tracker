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
                str += Helpers.getFormattedDateFromDateString(dateString: attendanceObj.dateString) + "\n"
            }
            return str.substring(to: str.index(str.endIndex, offsetBy: -1))
        }
    }
}
