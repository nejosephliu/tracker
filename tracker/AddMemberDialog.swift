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
    func addMember(memberName: String, index: Int)
}

class AddMemberDialog: ParentDialog {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addMoreButton: UIButton!
    @IBOutlet weak var addMemberLabel: UILabel!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: AddMemberDialogDelegate?
    
    var isEditingExisting: Bool = false
    var currentIndex: Int = -1
    
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
    
    func changeEditingExisting(name: String, index: Int){
        //isEditingExisting = true
        nameTF.text = name
        currentIndex = index
        addMoreButton.isHidden = true
        addButton.setTitle("CHANGE", for: .normal)
        addMemberLabel.text = "EDIT MEMBER"
        viewHeightConstraint.constant = -30
        checkIfTextFieldIsValid()
        
    }
    
    func checkIfTextFieldIsValid(){
        if let stringLength = nameTF.text?.characters.count{
            addButton.isEnabled = stringLength > 0
            addMoreButton.isEnabled = stringLength > 0
        }
    }
    
    func textFieldDidChange(){
        checkIfTextFieldIsValid()
    }
    
    @IBAction func addButtonPressed(){
        delegate?.addMember(memberName: nameTF.text!, index: currentIndex)
        dismissDialog()
    }
    
    @IBAction func addMoreButtonPressed(){
        delegate?.addMember(memberName: nameTF.text!, index: currentIndex)
        nameTF.text = ""
        checkIfTextFieldIsValid()
    }
}
