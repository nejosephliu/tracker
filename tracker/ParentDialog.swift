//
//  ParentDialog.swift
//  tracker
//
//  Created by Joseph Liu on 10/29/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

class ParentDialog: UIViewController{
    @IBOutlet weak var backgroundView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        definesPresentationContext = true
        providesPresentationContextTransitionStyle = true
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecgonizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        backgroundView.addGestureRecognizer(tapGestureRecgonizer)
    }
    
    func dismissDialog(){
        dismiss(animated: true, completion: nil)
    }
    
    
}
