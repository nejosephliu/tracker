//
//  LoginDataFlow.swift
//  tracker
//
//  Created by Joseph Liu on 10/22/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import Firebase

class LoginDataFlow{
    
    static public var validCode : Int = 0
    static public var invalidUsername : Int = 1
    static public var invalidPassword : Int = 2
    
    class func checkIfValid(username: String, password: String) -> Int{
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        var userList : NSDictionary!
        
        var returnCode : Int!
        
        ref.child("users").child(username).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            userList = snapshot.value as? NSDictionary
            
            if let correctPassword = userList["password"] as! String?{
                NSLog("entered pass: " + password)
                NSLog("real pass: " + correctPassword)
                
                if(password == String(describing: correctPassword)){
                    returnCode = validCode
                }else{
                    returnCode = invalidPassword
                }
            }
            
        }) { (error) in
            print("ERROR: " + error.localizedDescription)
        }
        
        if(returnCode != nil){
            return returnCode
        }else{
            return invalidUsername
        }
    }
}
