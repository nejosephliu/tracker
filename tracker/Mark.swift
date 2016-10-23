//
//  FirstViewController.swift
//  tracker
//
//  Created by Joseph Liu on 10/21/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit
import SnapKit

class Mark: ParentViewController {
    
    @IBOutlet weak var headerViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Mark Attendance")
        
        NSLog("Current user: " + String(describing: UserDefaults.standard.value(forKey: "current_user")))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*@IBAction func logout(){
        UserDefaults.standard.setValue("", forKey: "current_user")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }*/

    
}

