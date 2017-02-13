//
//  AddMemberDialog.swift
//  tracker
//
//  Created by Joseph Liu on 2/12/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

protocol AddMemberDialogDelegate: class{
    func addMember(memberName: String)
}

class AddMemberDialog: ParentDialog {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addMoreButton: UIButton!
    
    weak var delegate: AddMemberDialogDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        addButton.isEnabled = false
        addMoreButton.isEnabled = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func dismissKeyboard(){
        nameTF.resignFirstResponder()
    }
    
    func textFieldDidChange(){
        if let stringLength = nameTF.text?.characters.count{
            addButton.isEnabled = stringLength > 0
            addMoreButton.isEnabled = stringLength > 0
        }
    }
    
    @IBAction func addButtonPressed(){
        delegate?.addMember(memberName: nameTF.text!)
        dismissDialog()
    }
    
    @IBAction func addMoreButtonPressed(){
        delegate?.addMember(memberName: nameTF.text!)
        nameTF.text = ""
    }
}
