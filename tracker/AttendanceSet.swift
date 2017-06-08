//
//  AttendanceSet.swift
//  tracker
//
//  Created by Joseph Liu on 12/23/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class AttendanceSet {
    var dateId : String!
    var dateString: String!
    var membersArr: [Member]
	var recordName: String = ""
    
    init(dateId: String, dateString: String){
        self.dateId = dateId
        self.dateString = dateString
        self.membersArr = []
    }
	
	init(dateId: String, dateString: String, recordName: String){
		self.dateId = dateId
		self.dateString = dateString
		self.membersArr = []
		self.recordName = recordName
	}
	
    func getCount() -> Int{
        return membersArr.count
    }
    
    func printArr(){
        for member in membersArr{
            NSLog(dateString + " | Name: " + member.name)
        }
    }
    
    func getMembers() -> String{
        if(membersArr.count == 0){
            return "No Members"
        }else{
            var str = ""
            for member in membersArr{
                str += member.name + "\n"
            }
            return str.substring(to: str.index(str.endIndex, offsetBy: -1))
        }
    }
	
	func abbreviatedDateString() -> String{
		let year = String(describing: Int(dateString.substring(to: dateString.index(dateString.startIndex, offsetBy: 4)))!)
		
		let month = Int(dateString.substring(with: dateString.index(dateString.startIndex, offsetBy: 5)..<dateString.index(dateString.startIndex, offsetBy: 7)))
		let day = Int(dateString.substring(with: dateString.index(dateString.startIndex, offsetBy: 8)..<dateString.index(dateString.startIndex, offsetBy: 10)))
		
		return String(describing: month!) + "/" + String(describing: day!)// + "/" + year.substring(from: dateString.index(dateString.startIndex, offsetBy: 2))
	}
	
	func hasName() -> Bool{
		return recordName.characters.count > 0
	}
}
