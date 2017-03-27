//
//  AddVisitorDialog.swift
//  tracker
//
//  Created by Joseph Liu on 10/29/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

protocol EditGroupNameDialogDelegate: class{
    func editName(groupName: String)
}

class EditGroupNameDialog: ParentDialog {
    
    @IBOutlet weak var loggedInLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: EditGroupNameDialogDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        addButton.isEnabled = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func dismissKeyboard(){
        nameTF.resignFirstResponder()
    }
    
    func textFieldDidChange(){
        if let stringLength = nameTF.text?.characters.count{
            addButton.isEnabled = stringLength > 0
        }
    }
    
    @IBAction func addButtonPressed(){
        delegate?.editName(groupName: nameTF.text!)
        dismissDialog()
    }
}
