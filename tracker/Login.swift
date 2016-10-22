//
//  FirstViewController.swift
//  tracker
//
//  Created by Joseph Liu on 10/21/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class Login: UIViewController {
    
    @IBOutlet weak var loginButton : UIButton!
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    private var canLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTF.addTarget(self, action: #selector(textFieldChanged), for: UIControlEvents.editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldChanged), for: UIControlEvents.editingChanged)
        
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRec)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(){
        if(canLogin){
            let result = LoginDataFlow.checkIfValid(username: usernameTF.text!, password: passwordTF.text!)
            
            if(result == LoginDataFlow.validCode){
                callSegue()
            }else if(result == LoginDataFlow.invalidUsername){
                displayErrorAlert(title: "Invalid Username", message: "Username was not found.")
            }else if(result == LoginDataFlow.invalidPassword){
                displayErrorAlert(title: "Incorrect Password", message: "Please try again.")
            }
        }
    }
    
    func textFieldChanged(){
        if((usernameTF.text?.characters.count)! > 0 && (passwordTF.text?.characters.count)! > 0){
            loginButton.setImage(UIImage(named: "login_active"), for: UIControlState.normal)
            canLogin = true
        }else{
            loginButton.setImage(UIImage(named: "login_inactive"), for: UIControlState.normal)
            canLogin = false
        }
    }
    
    func dismissKeyboard(){
        if(usernameTF.isEditing){
            usernameTF.endEditing(true)
        }
        if(passwordTF.isEditing){
            passwordTF.endEditing(true)
        }
    }
    
    func callSegue(){
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    func displayErrorAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

