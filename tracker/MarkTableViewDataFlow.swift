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
    class func getMongoArrayOfMembers(gID: String, completion:@escaping ([Member])-> Void){
        //let currentGroup = GroupsDataFlow.getCurrentGroup()
        //let groupID = currentGroup.id
        
        Alamofire.request(RequestManager.urlEncode(url: Constants.baseURL + "members-key/" + gID)).responseJSON{ response in
            if let json = response.result.value {
                let responseArr = json as! NSArray
                var membersArr : [Member] = []
                
                for individual in responseArr{
                    let individualArr = individual as! NSDictionary
                    let id = individualArr["_id"] as! String
                    let name = individualArr["name"] as! String
                    let g_id = individualArr["g_id"] as! String
                    
                    let individualMember = Member(id: id, name: name, g_id: g_id)
                    membersArr.append(individualMember)
                }
                
                membersArr.sort { $0.name < $1.name }
                completion(membersArr)
            }else{
                completion([])
            }
        }
    }
    
    class func submitMongoAttendance(attendanceArr: [Member], dateString: String, completion:@escaping ()-> Void){
        var attendanceJSON : [NSDictionary] = []
        
        //change cell group
        let dateParameters: Parameters = ["dateString": ["dateString": dateString, "g_id": GroupsDataFlow.getCurrentGroupID()]]
        Alamofire.request(Constants.baseURL + "create-attendance-record", method: .post, parameters: dateParameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            if let dateID = response.result.value{
                let dateIDString = dateID as! NSArray
                
                if let dateIDString = dateIDString.firstObject{
                    for member in attendanceArr{
                        attendanceJSON.append(["date_id": dateIDString, "date": dateString, "member_id": member.id, "name": member.name, "g_id": member.g_id])
                    }
                    
                    let parameters: Parameters = ["attendees": attendanceJSON]
                    Alamofire.request(Constants.baseURL + "submit-attendance", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
                        completion()
                    }
                }
            }
        }
    }
    
}
