//
//  Settings.swift
//  tracker
//
//  Created by Joseph Liu on 10/22/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import DropDown

protocol MenuDialogDelegate: class{
    func logout()
}

class MenuDialog: ParentDialog {
    
    @IBOutlet weak var loggedInLabel: UILabel!
    @IBOutlet weak var dropdownView: UIView!
    
    let dropdown = DropDown()
    
    weak var delegate: MenuDialogDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if let email = FIRAuth.auth()?.currentUser?.email{
            loggedInLabel.text = "Logged in as " + email
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dropdown.dataSource = ["Car", "Motorcycle", "Truck"]
        dropdown.anchorView = dropdownView
        
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
    }
    
    @IBAction func dropdownPressed() {
        dropdown.show()
    }
    
    @IBAction func logoutButtonPressed(){
        delegate?.logout()
    }
}
