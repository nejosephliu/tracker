//
//  AddVisitorDialog.swift
//  tracker
//
//  Created by Joseph Liu on 10/29/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

protocol AddVisitorDialogDelegate: class{
    func addVisitor(visitorName: String)
}

class AddVisitorDialog: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var loggedInLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: AddVisitorDialogDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        definesPresentationContext = true
        providesPresentationContextTransitionStyle = true
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad() {
        nameTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        addButton.isEnabled = false
        
        let tapGestureRecgonizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        backgroundView.addGestureRecognizer(tapGestureRecgonizer)
    }
    
    
    func dismissDialog(){
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidChange(){
        if let stringLength = nameTF.text?.characters.count{
            addButton.isEnabled = stringLength > 0
        }
    }
    
    @IBAction func addButtonPressed(){
        delegate?.addVisitor(visitorName: nameTF.text!)
        dismissDialog()
    }
}
