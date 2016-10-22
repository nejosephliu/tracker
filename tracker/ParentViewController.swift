//
//  ParentViewController.swift
//  tracker
//
//  Created by Joseph Liu on 10/22/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

class ParentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addHeaderView(headerViewContainer: UIView, pageLabel: String){
        let header = Header(frame: headerViewContainer.frame)
        
        headerViewContainer.addSubview(header)
        
        header.setPageLabel(page: pageLabel)
    }

}
