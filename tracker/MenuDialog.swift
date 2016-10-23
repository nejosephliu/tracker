//
//  Settings.swift
//  tracker
//
//  Created by Joseph Liu on 10/22/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

protocol MenuDialogDelegate: class{
    func logout()
}

class MenuDialog: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    weak var delegate: MenuDialogDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        definesPresentationContext = true
        providesPresentationContextTransitionStyle = true
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let tapGestureRecgonizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        backgroundView.addGestureRecognizer(tapGestureRecgonizer)
    }
    
    @IBAction func logoutButtonPressed(){
        delegate?.logout()
    }
    
    func dismissDialog(){
        dismiss(animated: true, completion: nil)
    }
    
    
}
