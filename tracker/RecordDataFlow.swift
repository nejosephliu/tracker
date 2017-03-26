//
//  RecordDataFlow.swift
//  tracker
//
//  Created by Joseph Liu on 12/23/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import Firebase
import Alamofire

class RecordDataFlow{
    class func getMongoArrayOfDates(groupID: String, completion:@escaping ([[String]])-> Void){
        Alamofire.request(Constants.baseURL + "dates/" + groupID).responseJSON{ response in
            
            if let dateJson = response.result.value {
                
                var arrayOfDates : [[String]] = []
                
                let dateResponseArr = dateJson as! NSArray
                
                NSLog("results: " + String(describing: dateJson))
                
                for date in dateResponseArr{
                    let dateArr = date as! NSDictionary
                    let dateId = dateArr["_id"] as! String
                    let dateString = dateArr["dateString"] as! String
                    arrayOfDates.append([dateId, dateString])
                }
                
                NSLog("current gid: " + GroupsDataFlow.getCurrentGroupID())
                
                NSLog("array of dates: " + String(describing: arrayOfDates))
                
                completion(arrayOfDates)
            }
        }
    }
    
    class func getMongoMembersArrayByDate(dateId: String, completion:@escaping ([String])-> Void){
        Alamofire.request(Constants.baseURL + "attendance-by-date/" + dateId).responseJSON{ response in
            if let json = response.result.value {
                let responseArr = json as! NSArray
                
                var idArray : [String] = []
                
                for individual in responseArr{
                    let individualArr = individual as! NSDictionary
                    idArray.append(individualArr["member_id"] as! String)
                }
                
                completion(idArray)
            }
        }
    }
    
    class func getMongoMemberInfoById(memberId: String, completion:@escaping (Member)-> Void){
        
        Alamofire.request(Constants.baseURL + "member-by-id/" + memberId).responseJSON{ response in
            if let memberJson = response.result.value{
                let memberResponseArr = memberJson as! NSArray
                if(memberResponseArr.count > 0){
                let memberIndividualArr = memberResponseArr.firstObject as! NSDictionary
                let id = memberIndividualArr["_id"] as! String
                let name = memberIndividualArr["name"] as! String
                print("name" + name)
                let g_id = memberIndividualArr["g_id"] as! String

                
                let individualMember = Member(id: id, name: name, g_id: g_id)
                
                completion(individualMember)
                }
            }
        }
    }
    
    class func getMongoArrayOfMembers(gID: String, completion:@escaping ([Member])-> Void){
        let currentGroup = GroupsDataFlow.getCurrentGroup()
        let groupID = currentGroup.id
        
        Alamofire.request(RequestManager.urlEncode(url: Constants.baseURL + "members-key/" + groupID)).responseJSON{ response in
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
                
                completion(membersArr)
            }else{
                completion([])
            }
        }
    }
    
    class func getMongoMemberAttendanceById(memberId: String, completion:@escaping ([Attendance])-> Void){
        Alamofire.request(RequestManager.urlEncode(url: Constants.baseURL + "attendance-by-member/" + memberId)).responseJSON{ response2 in
            if let json2 = response2.result.value {
                let responseArr2 = json2 as! NSArray
                
                var attArr : [Attendance] = []
                
                for attendance in responseArr2{
                    let individualAttendanceArr = attendance as! NSDictionary
                    let attendanceId = individualAttendanceArr["_id"] as! String
                    let attendanceDateId = individualAttendanceArr["date_id"] as! String
                    let attendanceDateString = individualAttendanceArr["date"] as! String
                    let attendanceName = individualAttendanceArr["name"] as! String
                    
                    let attendanceObj = Attendance(id: attendanceId, memberId: memberId, dateId: attendanceDateId, memberName: attendanceName, dateString: attendanceDateString)
                    
                    attArr.append(attendanceObj)
                }
                
                attArr.sort { $0.dateString < $1.dateString }
                completion(attArr)
            }
        }

    }
}
