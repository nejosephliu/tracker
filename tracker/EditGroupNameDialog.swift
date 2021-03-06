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

class EditGroupNameDialog: ParentDialog, UITextFieldDelegate {
    
    @IBOutlet weak var loggedInLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: EditGroupNameDialogDelegate?
    
    var defaultText : String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        
        addButton.isEnabled = false
        
        nameTF.text = defaultText
		
		nameTF.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTF.becomeFirstResponder()
    }
    
    func dismissKeyboard(){
        nameTF.resignFirstResponder()
    }
    
    func textFieldDidChange(){
        if let stringLength = nameTF.text?.characters.count{
            addButton.isEnabled = stringLength > 0
        }
    }
    
    func setDefaultText(groupName: String){
        defaultText = groupName
    }
    
    @IBAction func addButtonPressed(){
        delegate?.editName(groupName: nameTF.text!)
        dismissDialog()
    }
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let maxLength = 17
		let currentString: NSString = textField.text! as NSString
		let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
		return newString.length <= maxLength
	}
}
