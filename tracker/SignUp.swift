//
//  SignUp.swift
//  tracker
//
//  Created by Joseph Liu on 4/16/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import UIKit

class SignUp: UIViewController{
    @IBOutlet weak var signUpButton : UIButton!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    private var canSignUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.addTarget(self, action: #selector(textFieldChanged), for: UIControlEvents.editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldChanged), for: UIControlEvents.editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRec)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        LoginDataFlow.checkIfLoggedIn() { (loggedIn) -> ()
            in
            if(loggedIn){
                print("i'm logged in")
                self.callSegue()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonPressed(){
        if(canSignUp){
            KVSpinnerView.showLoading()
            SignUpDataFlow.signUp(email: emailTF.text!, password: passwordTF.text!) {(error) -> ()
                in
                KVSpinnerView.dismiss()
                if(error == ""){
                    self.callSegue()
                }else{
                    CustomAlertHelper.presentCustomAlert(title: "Error!", message: error, viewController: self)
                }
            }
        }
    }
    
    @IBAction func goToLoginPressed(){
        performSegue(withIdentifier: "goLoginSegue", sender: nil)
    }
    
    func textFieldChanged(){
        if((emailTF.text?.characters.count)! > 0 && (passwordTF.text?.characters.count)! > 0){
            signUpButton.isEnabled = true
            canSignUp = true
        }else{
            signUpButton.isEnabled = false
            canSignUp = false
        }
    }
    
    func dismissKeyboard(){
        if(emailTF.isEditing){
            emailTF.endEditing(true)
        }
        if(passwordTF.isEditing){
            passwordTF.endEditing(true)
        }
    }
    
    func callSegue(){
        performSegue(withIdentifier: "signUpSegue", sender: nil)
    }
    
    func displayErrorAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height/2
            }
        }
    }

}
