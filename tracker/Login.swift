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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(){
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    
}

