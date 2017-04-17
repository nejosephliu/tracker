//
//  SignUpDataFlow.swift
//  tracker
//
//  Created by Joseph Liu on 4/16/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class SignUpDataFlow{
    class func signUp(email: String, password: String, completion:@escaping (String)-> Void){
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if user != nil {
                UserDefaults.standard.setValue(user?.uid, forKey: "uid")
                UserDefaults.standard.synchronize()
                completion("")
            }else{
                completion((error?.localizedDescription)!)
            }
        }
    }
}
