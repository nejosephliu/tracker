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
    
    class func checkIfValid() -> Int{
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            NSLog("value: " + String(describing: value))
            
            
            // ...
        }) { (error) in
            print("ERROR: " + error.localizedDescription)
        }
        
        //return validCode
        return invalidUsername
    }
}
