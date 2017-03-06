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
    class func getMongoArrayOfDates(cellGroupId: Int, completion:@escaping ([[String]])-> Void){
        Alamofire.request(Constants.baseURL + "dates/" + GroupsDataFlow.getCurrentGroupID()).responseJSON{ response in
            
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
                let memberIndividualArr = memberResponseArr.firstObject as! NSDictionary
                let id = memberIndividualArr["_id"] as! String
                let name = memberIndividualArr["name"] as! String
                let g_id = memberIndividualArr["g_id"] as! String

                
                let individualMember = Member(id: id, name: name, g_id: g_id)
                
                completion(individualMember)
            }
        }
    }
    
    
}
