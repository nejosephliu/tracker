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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteGroupButton: UIButton!
    
    var groupName: String!
    var groupID: String!
    
    
    
    var membersArr : [Member] = []
    var isNewGroup : Bool = true
    
    var newMembers : [Member] = []
    var editedMembers: [Member] = []
    var deletedMembers: [Member] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Edit Group")
        header.backDelegate = self
        header.showBackButton()
        
        if(!isNewGroup){
            deleteGroupButton.isHidden = false
        }
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        if let groupName = groupName{
            groupNameLabel.text = "GROUP NAME: " + groupName
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func setGroupName(name: String){
        groupName = name
    }
    
    func setGroupID(groupID: String){
        isNewGroup = false
        self.groupID = groupID
        getMembersOfExistingGroup()
    }
    
    func getMembersOfExistingGroup(){
        MarkTableViewDataFlow.getMongoArrayOfMembers(gID: groupID) { (arrayOfMembers) -> () in
            self.membersArr = arrayOfMembers
            self.tableView.reloadData()
        }
    }
    
    func goBack(alert: UIAlertAction){
        performSegue(withIdentifier: "backToGroupsSegue", sender: self)
    }
    
    func insertIntoEditedMembersArr(member: Member){
        for var index in 0..<editedMembers.count{
            let individualMember = editedMembers[index]
            if(individualMember.id == member.id){
                editedMembers.remove(at: index)
                index -= 1
            }
        }
        
        editedMembers.append(member)
        
        print("---------\nEdit Group Array:")
        
        for member in editedMembers{
            print("i: " + member.name)
            print("k: " + member.id)
        }
        
        print("---------")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "backToGroupsSegue"){
            let destinationVC = segue.destination as! UITabBarController
            destinationVC.selectedIndex = 2
        }
    }
    
    @IBAction func submitButtonPressed(){
        if(isNewGroup){
            if(membersArr.count > 0){
                EditGroupDataFlow.createGroup(groupName: groupName){ (result) -> () in
                    EditGroupDataFlow.addMembers(memberArr: self.membersArr, groupID: result){ () -> () in
                        self.performSegue(withIdentifier: "backToGroupsSegue", sender: self)
                    }
                }
            }
        }else{
            EditGroupDataFlow.updateGroup(groupID: groupID, newMemberArr: newMembers, editedMemberArr: editedMembers, deletedMemberArr: deletedMembers){ () -> () in
                self.performSegue(withIdentifier: "backToGroupsSegue", sender: self)
            }
        }
    }
    
    @IBAction func addMembers(){
        let addMemberDialog = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "addMemberDialog") as! AddMemberDialog
        addMemberDialog.delegate = self
        present(addMemberDialog, animated: true, completion: nil)
    }
    
    @IBAction func deleteGroupPressed(){
        let alert = UIAlertController(title: "Delete?", message: "You cannot undo this action.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: deleteGroup)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteGroup(alert: UIAlertAction){
        EditGroupDataFlow.deleteGroup(groupID: groupID){ () -> () in
            self.performSegue(withIdentifier: "backToGroupsSegue", sender: self)
        }
    }
}

extension EditGroup: HeaderBackDelegate{
    func backButtonPressed(){
        if(isNewGroup || (newMembers.count > 0 || editedMembers.count > 0 || deletedMembers.count > 0)){
            let alert = UIAlertController(title: "Are you sure?", message: "You will lose all changes.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .default, handler: goBack)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }else{
            performSegue(withIdentifier: "backToGroupsSegue", sender: self)
        }
    }
}

extension EditGroup: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let addMemberDialog = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "addMemberDialog") as! AddMemberDialog
        addMemberDialog.delegate = self
        present(addMemberDialog, animated: true, completion: nil)
        let cell = tableView.cellForRow(at: indexPath) as! AddMemberTableViewCell
        
        if let name = cell.nameLabel.text{
            addMemberDialog.changeEditingExisting(name: name, index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if(!isNewGroup){
                deletedMembers.append(membersArr[indexPath.row])
            }
            membersArr.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}


extension EditGroup: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddMemberTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "add_member_cell") as! AddMemberTableViewCell
        cell.nameLabel?.text = membersArr[indexPath.row].name
        return cell
    }
}

extension EditGroup: AddMemberDialogDelegate{
    func addMember(memberName: String, index: Int) {
        let newMember = Member(id: "", name: memberName, g_id: "")
        if(index == -1){
            if(!isNewGroup){
                newMembers.append(newMember)
            }
            membersArr.append(newMember)
        }else{
            if(!isNewGroup){
                let originalMember = membersArr[index]
                if(memberName != originalMember.name){
                    originalMember.name = memberName
                    insertIntoEditedMembersArr(member: originalMember)
                }
                membersArr[index] = originalMember
            }else{
                membersArr[index] = newMember
            }
        }
        
        tableView.reloadData()
    }
}
