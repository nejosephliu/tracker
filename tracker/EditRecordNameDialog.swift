//
//  EditRecordNameDialog.swift
//  tracker
//
//  Created by Joseph Liu on 6/8/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

protocol EditRecordNameDialogDelegate: class{
	func editName(recordName: String)
}

class EditRecordNameDialog: ParentDialog, UITextFieldDelegate {
	
	@IBOutlet weak var loggedInLabel: UILabel!
	@IBOutlet weak var nameTF: UITextField!
	@IBOutlet weak var addButton: UIButton!
	
	weak var delegate: EditRecordNameDialogDelegate?
	
	var defaultText : String!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//nameTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
		
		addButton.isEnabled = true
		
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
	
	/*func textFieldDidChange(){
		if let stringLength = nameTF.text?.characters.count{
			addButton.isEnabled = stringLength > 0
		}
	}*/
	
	func setDefaultText(recordName: String){
		defaultText = recordName
	}
	
	@IBAction func addButtonPressed(){
		delegate?.editName(recordName: nameTF.text!)
		dismissDialog()
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let maxLength = 17
		let currentString: NSString = textField.text! as NSString
		let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
		return newString.length <= maxLength
	}
}
