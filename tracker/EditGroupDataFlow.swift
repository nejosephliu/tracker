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
    
    class func addMembers(memberArr: [Member], groupID: String, completion:@escaping ()-> Void){
        var membersJSON : [NSDictionary] = []
        
        for member in memberArr{
            membersJSON.append(["name": member.name, "g_id": groupID])
        }
        
        let parameters: Parameters = ["members": membersJSON]
        
        Alamofire.request(Constants.baseURL + "submit-members", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            completion()
        }
    }
    
    class func updateGroup(groupID: String, newMemberArr: [Member], editedMemberArr: [Member], deletedMemberArr: [Member], completion:@escaping ()-> Void){
        var newJSON : [NSDictionary] = []
        for member in newMemberArr{
             newJSON.append(["name": member.name, "g_id": groupID])
        }
        
        var editedJSON : [NSDictionary] = []
        for member in editedMemberArr{
            editedJSON.append(["id": member.id, "name": member.name, "g_id": groupID])
        }
        
        var deletedJSON : [NSDictionary] = []
        for member in deletedMemberArr{
            deletedJSON.append(["id": member.id])
        }
        
        let parameters: Parameters = ["newMemberArr": newJSON, "editedMemberArr": editedJSON, "deletedMemberArr": deletedJSON]
        
        Alamofire.request(Constants.baseURL + "update-members", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            completion()
        }
        
        
    }
    
    class func getJsonForUpdating(memberArr : [Member]) -> [NSDictionary]{
        var json : [NSDictionary] = []
        
        let groupID = GroupsDataFlow.getCurrentGroupID()
        
        for member in memberArr{
            json.append(["id": member.id, "name": member.name, "g_id": groupID])
        }
        
        return json
    }
}
