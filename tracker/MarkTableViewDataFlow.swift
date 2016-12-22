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
    
    class func getMongoArrayOfMembers(cellGroup: String, completion:@escaping (NSArray)-> Void){
        Alamofire.request("http://localhost:8081/members-key/" + "0").responseJSON{ response in
            if let json = response.result.value {
                var arrayOfMembers : [String] = []
                
                let responseArr = json as! NSArray
                
                /*for individual in responseArr{
                    let individualArr = individual as! NSDictionary
                    let name = individualArr["name"] as! String
                    
                    arrayOfMembers.append(name)
                }*/
                
                //NSLog("hihihi" + String(describing: arrayOfMembers))
                completion(responseArr)
            }
        }
    }
    
    
}
