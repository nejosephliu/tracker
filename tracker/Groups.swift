//
//  Groups.swift
//  tracker
//
//  Created by Joseph Liu on 2/10/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

class Groups: ParentViewController {
    
    @IBOutlet weak var headerViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "My Groups")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

