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
    
    var groupArr : [Group] = []
    
    var selectedGroupID: String!
    
    var newGroupName: String!
    var creatingNewGroup: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "My Groups")
        
        GroupsDataFlow.updateUserGroupArray { 
            self.groupArr = GroupsDataFlow.getLocalGroupArray()
            self.groupsTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createGroupPressed(_ sender: Any) {
        creatingNewGroup = true
        let createGroupDialog = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "createGroupDialog") as! CreateGroupDialog
        createGroupDialog.delegate = self
        present(createGroupDialog, animated: true, completion: nil)
    }
    
    func editGroup(groupID: String, groupName: String){
        creatingNewGroup = false
        newGroupName = groupName
        selectedGroupID = groupID
        performSegue(withIdentifier: "editGroupSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editGroupSegue"){
            let editGroupViewController = segue.destination as! EditGroup
            editGroupViewController.setGroupName(name: newGroupName)
            if(!creatingNewGroup){
                editGroupViewController.setGroupID(groupID: selectedGroupID)
            }
        }
    }
}

extension Groups: CreateGroupDialogDelegate{
    func createGroup(groupName: String) {
        newGroupName = groupName
        performSegue(withIdentifier: "editGroupSegue", sender: self)
    }
}

extension Groups: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedGroup = groupArr[indexPath.row]
        let groupID = selectedGroup.id
        let groupName = selectedGroup.name
        editGroup(groupID: groupID, groupName: groupName)
    }
}


extension Groups: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GroupTableViewCell = self.groupsTableView.dequeueReusableCell(withIdentifier: "group_cell") as! GroupTableViewCell
        cell.nameLabel.text = groupArr[indexPath.row].name
        return cell
    }
}
