//
//  MarkTableViewDataFlow.swift
//  tracker
//
//  Created by Joseph Liu on 10/22/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import Firebase
import Alamofire

class MarkTableViewDataFlow{
    
    static public var validCode : Int = 0
    static public var invalidUsername : Int = 1
    static public var invalidPassword : Int = 2
    
    class func getArrayOfMembers(cellGroup: String, completion:@escaping (NSArray)-> Void){
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        var membersList : NSArray!
        
        ref.child("cell_groups").child(cellGroup).observeSingleEvent(of: .value, with: { (snapshot) in
            membersList = snapshot.value as? NSArray
            
            completion(membersList)
        })
    }
    
    class func getMongoArrayOfMembers(cellGroup: String, completion:@escaping ([Member])-> Void){
        Alamofire.request("http://localhost:8081/members-key/" + "0").responseJSON{ response in
            if let json = response.result.value {
                let responseArr = json as! NSArray
                var membersArr : [Member] = []
                
                for individual in responseArr{
                    let individualArr = individual as! NSDictionary
                    let id = individualArr["_id"] as! String
                    let name = individualArr["name"] as! String
                    let g_id = individualArr["g_id"] as! Int
                    let email = individualArr["email"] as! String
                    
                    let individualMember = Member(id: id, name: name, g_id: g_id, email: email)
                    membersArr.append(individualMember)
                }
                
                completion(membersArr)
            }
        }
    }
    
    class func submitMongoAttendance(attendanceArr: [Member]){
        var attendanceJSON : [NSDictionary] = []
        
        for member in attendanceArr{
            attendanceJSON.append(["id": member.id, "name": member.name, "g_id": member.g_id, "email": member.email])
            
            //ADD DATE
        }
        
        let parameters: Parameters = ["attendees": attendanceJSON]
        Alamofire.request("http://localhost:8081/submit-attendance", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            NSLog("hey")
        }
    }
    
}
