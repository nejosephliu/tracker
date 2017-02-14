//
//  GroupsDataFlow.swift
//  tracker
//
//  Created by Joseph Liu on 2/14/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import Foundation
import Alamofire

class GroupsDataFlow {
    class func updateUserGroupArray(completion: @escaping () -> Void){
        let uid = UserDefaults.standard.value(forKey: "uid") as! String
        
        Alamofire.request(Constants.baseURL + "groups-by-uid/" + uid).responseJSON{ response in
            if let json = response.result.value {
                let responseArr = json as! NSArray
                
                var groupArr : [Group] = []
                
                var groupStringArr : [String] = []
                
                for group in responseArr{
                    let individualGroupArr = group as! NSDictionary
                    
                    let groupID = individualGroupArr["_id"] as! String
                    let groupName = individualGroupArr["name"] as! String
                    
                    let groupObj = Group(id: groupID, name: groupName, owner: uid)
                    groupArr.append(groupObj)
                    
                    groupStringArr.append(groupName)
                }
                
                UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: groupArr), forKey: "groups")
                UserDefaults.standard.synchronize()
                
                completion()
            }
        }
    }
    
    class func getLocalGroupArray() -> [Group] {
        return NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "groups") as! Data) as! [Group]
    }
    
    class func setDefaultCurrentGroup(){
        let arr = getLocalGroupArray()
        
        if arr.count > 0{
            UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: arr[0]), forKey: "currentGroup")
            UserDefaults.standard.synchronize()
        }
    }
}
