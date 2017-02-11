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
    @IBOutlet weak var groupsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "My Groups")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createGroupPressed(_ sender: Any) {
        let createGroupDialog = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "createGroupDialog") as! CreateGroupDialog
        createGroupDialog.delegate = self
        present(createGroupDialog, animated: true, completion: nil)
    }
}

extension Groups: CreateGroupDialogDelegate{
    func createGroup(groupName: String) {
        print("Group created: " + groupName)
    }
}

extension Groups: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

/*
extension Groups: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
}*/
