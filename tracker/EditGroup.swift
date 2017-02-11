//
//  EditGroup.swift
//  tracker
//
//  Created by Joseph Liu on 2/11/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

class EditGroup: ParentViewController{
    
    @IBOutlet weak var headerViewContainer: UIView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    var groupName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Edit Group")
        
        if let groupName = groupName{
            groupNameLabel.text = "GROUP NAME: " + groupName
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setGroupName(name: String){
        print("the!! name is: " + name)
        groupName = name
    }
}
