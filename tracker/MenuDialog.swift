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
    @IBOutlet weak var selectedGroupLabel: UILabel!
    
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
        
        updateCurrentGroupLabel()
        
        dropdown.anchorView = dropdownView
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        dropdown.direction = .bottom
        dropdown.textFont = UIFont(name: "Courier New", size: 15)!
        
        let groupArr = GroupsDataFlow.getLocalGroupArray()
        populateDropDown(groupArr: groupArr)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func populateDropDown(groupArr: [Group]){
        var groupStrArr : [String] = []
        for group in groupArr{
            groupStrArr.append(group.name)
        }
        dropdown.dataSource = groupStrArr
    }
    
    func updateCurrentGroupLabel(){
        if let currentGroupObj = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "currentGroup") as! Data){
            let currentGroup = currentGroupObj as! Group
            
            selectedGroupLabel.text = currentGroup.name
        }
    }
    
    @IBAction func dropdownPressed() {
        dropdown.show()
    }
    
    @IBAction func logoutButtonPressed(){
        delegate?.logout()
    }
}
