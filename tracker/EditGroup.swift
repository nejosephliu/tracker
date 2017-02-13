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
    
    var groupName: String!
    
    var membersArr : [String] = []
    
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
    
    @IBAction func addMembers(){
        let addMemberDialog = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "addMemberDialog") as! AddMemberDialog
        addMemberDialog.delegate = self
        present(addMemberDialog, animated: true, completion: nil)
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
}


 extension EditGroup: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let cell: AddMemberTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "add_member_cell") as! AddMemberTableViewCell
        cell.nameLabel?.text = membersArr[indexPath.row]
        return cell
    }
 }

extension EditGroup: AddMemberDialogDelegate{
    func addMember(memberName: String, index: Int) {
        if(index == -1){
            membersArr.append(memberName)
        }else{
            membersArr[index] = memberName
        }
        
        tableView.reloadData()
    }
}
