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
    class func getMongoArrayOfDates(cellGroupId: Int, completion:@escaping ([String])-> Void){
        Alamofire.request(Constants.baseURL + "dates/" + "0").responseJSON{ response in
            
            if let dateJson = response.result.value {
                
                var arrayOfDates : [String] = []
                
                let dateResponseArr = dateJson as! NSArray
                
                for date in dateResponseArr{
                    let dateArr = date as! NSDictionary
                    let dateId = dateArr["_id"] as! String
                    arrayOfDates.append(dateId)
                }
                
                completion(arrayOfDates)
            }
            
        }
    }
    
    class func getMongoArrayByDate(dateId: String, completion:@escaping ([Member])-> Void){
        Alamofire.request(Constants.baseURL + "attendance-by-date/" + "0" + "/" + dateId).responseJSON{ response in
            if let json = response.result.value {
                let responseArr = json as! NSArray
                
                for individual in responseArr{
                    let individualArr = individual as! NSDictionary
                    let id = individualArr["member_id"] as! String
                    
                    Alamofire.request(Constants.baseURL + "member-by-id/" + id).responseJSON{ response in
                        
                        if let memberJson = response.result.value{
                            let memberResponseArr = memberJson as! NSArray
                            let memberIndividualArr = memberResponseArr.firstObject as! NSDictionary
                            
                            NSLog("response: " + String(describing: memberIndividualArr))
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    
}
