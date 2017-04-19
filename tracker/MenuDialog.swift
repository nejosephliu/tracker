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
    func callViewWillAppear()
}

class MenuDialog: ParentDialog {
    
    @IBOutlet weak var loggedInLabel: UILabel!
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var selectedGroupLabel: UILabel!
    
    let dropdown = DropDown()
    
    var groupArr: [Group] = []
    
    var comingFromMark : Bool = false
    
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
        
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.updateCurrentGroup(index: index)
            self.updateCurrentGroupLabel()
        }
        
        groupArr = GroupsDataFlow.getLocalGroupArray()
        populateDropDown(groupArr: groupArr)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.callViewWillAppear()
    }
    
    func setComingFromMark(){
        comingFromMark = true
    }
    
    func populateDropDown(groupArr: [Group]){
        var groupStrArr : [String] = []
        for group in groupArr{
            groupStrArr.append(group.name)
        }
        dropdown.dataSource = groupStrArr
    }
    
    func updateCurrentGroup(index: Int){
        let group = groupArr[index]
        GroupsDataFlow.setCurrentGroup(group: group)
    }
    
    func updateCurrentGroupLabel(){
        selectedGroupLabel.text = GroupsDataFlow.getCurrentGroupName()
    }
    
    @IBAction func dropdownPressed() {
        dropdown.show()
    }
    
    @IBAction func logoutButtonPressed(){
        KVSpinnerView.dismiss()
        delegate?.logout()
    }
}
