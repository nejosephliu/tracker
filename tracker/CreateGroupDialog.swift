//
//  CreateGroupDialog.swift
//  tracker
//
//  Created by Joseph Liu on 2/10/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

protocol CreateGroupDialogDelegate: class{
    func createGroup(groupName: String)
}

class CreateGroupDialog: ParentDialog, UITextFieldDelegate {
    
    @IBOutlet weak var loggedInLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    weak var delegate: CreateGroupDialogDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        createButton.isEnabled = false
		
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
            createButton.isEnabled = stringLength > 0
        }
    }
    
    @IBAction func createButtonPressed(){
        dismiss(animated: true, completion: create)
    }
    
    func create(){
        delegate?.createGroup(groupName: nameTF.text!)
    }
    
    func setIsFirstGroup(){
        isFirstGroup = true
    }
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let maxLength = 17
		let currentString: NSString = textField.text! as NSString
		let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
		return newString.length <= maxLength
	}
}
