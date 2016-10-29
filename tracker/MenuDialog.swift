//
//  Settings.swift
//  tracker
//
//  Created by Joseph Liu on 10/22/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

protocol MenuDialogDelegate: class{
    func logout()
}

class MenuDialog: ParentDialog {
    @IBOutlet weak var loggedInLabel: UILabel!
    
    weak var delegate: MenuDialogDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if let username = UserDefaults.standard.value(forKey: "current_user") as! String?{
            loggedInLabel.text = "Logged in as " + username
        }
    }
    
    @IBAction func logoutButtonPressed(){
        delegate?.logout()
    }
}
