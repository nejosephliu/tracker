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
    
    class func checkIfValid(username: String, password: String, completion:@escaping (String, Int)-> Void){
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        var userList : NSDictionary!
        
        var returnCode : Int! = invalidUsername
        
        ref.child("users").child(username).observeSingleEvent(of: .value, with: { (snapshot) in
            
            userList = snapshot.value as? NSDictionary
            
            var correctUsername: String = ""
            
            if let userDictionary = userList{
                if let correctPassword = userDictionary["password"] as! String?{
                    correctUsername = userDictionary["username"] as! String
                    
                    NSLog("entered pass: " + password)
                    NSLog("real pass: " + String(describing: correctPassword))
                    
                    if(password == correctPassword){
                        
                        returnCode = validCode
                    }else{
                        returnCode = invalidPassword
                    }
                }
            }
            
            completion(correctUsername, returnCode)
            
        }) { (error) in
            print("ERROR: " + error.localizedDescription)
        }
    }
    
    
}
