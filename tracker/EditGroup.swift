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
        header.backDelegate = self
        header.showBackButton()
        
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
    
    func goBack(alert: UIAlertAction){
        performSegue(withIdentifier: "backToGroupsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "backToGroupsSegue"){
            let destinationVC = segue.destination as! UITabBarController
            destinationVC.selectedIndex = 2
        }
    }
    
    @IBAction func submitButtonPressed(){
        
    }
}

extension EditGroup: HeaderBackDelegate{
    func backButtonPressed(){
        let alert = UIAlertController(title: "Are you sure?", message: "You will lose all changes.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: goBack)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
