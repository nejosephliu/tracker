//
//  LoginDataFlow.swift
//  tracker
//
//  Created by Joseph Liu on 10/22/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class LoginDataFlow{
    
    static public var validCode : Int = 0
    static public var invalidUsername : Int = 1
    static public var invalidPassword : Int = 2
    
    class func checkIfValid(email: String, password: String, completion:@escaping (String)-> Void){
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if user != nil {
                UserDefaults.standard.setValue(user?.uid, forKey: "uid")
                UserDefaults.standard.synchronize()
                completion("")
            }else{
                completion((error?.localizedDescription)!)
            }
        }
    }
    
    class func checkIfLoggedIn(completion:@escaping (Bool)-> Void){
        if (FIRAuth.auth()?.currentUser) != nil{
            completion(true)
        }else{
            completion(false)
        }
    }
    
    class func logout(completion:@escaping ()-> Void){
        try! FIRAuth.auth()!.signOut()
        UserDefaults.standard.setValue(nil, forKey: "uid")
        completion()
    }
}
