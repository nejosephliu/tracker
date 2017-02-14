//
//  EditGroupDataFlow.swift
//  tracker
//
//  Created by Joseph Liu on 2/13/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseAuth

class EditGroupDataFlow{
    class func createGroup(groupName: String, completion:@escaping (String)-> Void){
        let uid = UserDefaults.standard.value(forKey: "uid") as! String
        let url = Constants.baseURL + "create-group/" + groupName + "/" + uid
        
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!).responseJSON{ response in
            if let json = response.result.value{
                let jsonArr = json as! NSArray
                let groupID = jsonArr[0] as! String
                completion(groupID)
            }
        }
    }
    
    class func addMembers(memberArr: [String], groupID: String, completion:@escaping ()-> Void){
        var membersJSON : [NSDictionary] = []
        
        for member in memberArr{
            membersJSON.append(["name": member, "g_id": groupID])
        }
        
        let parameters: Parameters = ["members": membersJSON]
        
        _ = Alamofire.request(Constants.baseURL + "submit-members", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        completion()
    }
}
