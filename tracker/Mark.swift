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
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var currentDay : Int!
    var currentMonth : Int!
    var currentYear : Int!
    
    var theMembersArray : [Member] = []
    var visitorsArray: [Member] = []
    var selectedMembers: [Bool] = []
    
    var currentGroupID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Mark")
        
        setDateHeader()
        
        NSLog("Current user: " + String(describing: UserDefaults.standard.value(forKey: "current_user")))
        
        reloadTableView()
        
        GroupsDataFlow.updateUserGroupArray(){
            () in
            if(UserDefaults.standard.value(forKey: "currentGroup") == nil){
                GroupsDataFlow.setDefaultCurrentGroup()
                self.currentGroupID = GroupsDataFlow.getCurrentGroupID()
                //self.groupNameLabel.text = GroupsDataFlow.getCurrentGroupName()
                self.changeHeaderText(text: GroupsDataFlow.getCurrentGroupName())
            }
            self.getListOfMembers()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let newGroupID = GroupsDataFlow.getCurrentGroupID()
        
        if(currentGroupID != newGroupID){
            currentGroupID = newGroupID
            //groupNameLabel.text = GroupsDataFlow.getCurrentGroupName()
            changeHeaderText(text: GroupsDataFlow.getCurrentGroupName())
            visitorsArray = []
            getListOfMembers()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDateHeader(){
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(Set<Calendar.Component>([.year, .month, .day]), from: date as Date)
        
        currentDay = components.day
        currentMonth = components.month
        currentYear = components.year
        
        //changeHeaderText(text: "\(components.month!)/\(components.day!)")
        dateLabel.text = "\(components.month!)/\(components.day!)"
    }
    
    func getListOfMembers(){
        KVSpinnerView.showLoading()
        MarkTableViewDataFlow.getMongoArrayOfMembers(gID: currentGroupID) { (arrayOfMembers) -> () in
            if(arrayOfMembers.count == 0){
                /*let alert = UIAlertController(title: "Cannot get members", message: "Please check your connection to the internet.  ", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)*/
            }else{
                self.selectedMembers = []
                
                for _ in 0...arrayOfMembers.count - 1{
                    self.selectedMembers.append(false)
                }
                
                self.theMembersArray = arrayOfMembers
                self.reloadTableView()
                KVSpinnerView.dismiss()
            }
        }
    }
    
    func updateCountLabel(){
        let peopleCount = selectedMembers.filter { $0 == true }.count
        countLabel.text = String(describing: peopleCount)
    }
    
    func clearTable(alert: UIAlertAction!){
        for row in 0...selectedMembers.count - 1{
            selectedMembers[row] = false
        }
        
        visitorsArray = []
        
        reloadTableView()
    }
    
    func updateClearButton(){
        let peopleCount = selectedMembers.filter { $0 == true }.count
        
        if(peopleCount == 0){
            clearButton.isEnabled = false
        }else{
            clearButton.isEnabled = true
        }
    }
    
    func reloadTableView(){
        updateCountLabel()
        updateClearButton()
        membersTableView.reloadData()
    }
    
    @IBAction func changeDateButtonPressed(){
        let changeDateDialog = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "changeDateDialog") as! ChangeDateDialog
        changeDateDialog.delegate = self
        changeDateDialog.setDate(year: currentYear, month: currentMonth, day: currentDay)
        present(changeDateDialog, animated: true, completion: nil)
        
        
    }
    
    @IBAction func clearButtonPressed(){
        let alertController = UIAlertController(title: "Are you sure you want to clear?", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Clear", style: .default, handler: clearTable)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addVisitorButtonPressed(){
        let addVisitorDialog = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "addVisitorDialog") as! AddVisitorDialog
        addVisitorDialog.delegate = self
        present(addVisitorDialog, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(){
        var membersHereArr : [Member] = []
        
        for i in 0...selectedMembers.count - 1{
            let isHere = selectedMembers[i]
            var member : Member
            if i < theMembersArray.count{
                member = theMembersArray[i]
            }else{
                member = visitorsArray[i - theMembersArray.count]
            }
            
            if isHere {
                membersHereArr.append(member)
            }
        }
        
//        let dateString = String(describing: currentYear!) + "-" + String(describing:currentMonth!) + "-" + String(describing: currentDay!);
        
        let dateString = setDateString(year: currentYear!, month: currentMonth!, day: currentDay!)
        
        MarkTableViewDataFlow.submitMongoAttendance(attendanceArr: membersHereArr, dateString: dateString) { () -> () in
            let alert = UIAlertController(title: "Success!", message: "Attendance record submitted.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            UserDefaults.standard.setValue(true, forKey: "new-submit")
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
    }
    
    func setDateString(year: Int, month: Int, day: Int) -> String{
        var dateString = String(describing: year)
        
        dateString += "-"
        
        if(month <= 9){
            dateString += "0" + String(describing: month)
        }else{
            dateString += String(describing: month)
        }
        
        dateString += "-"
        
        if(day <= 9){
            dateString += "0" + String(describing: day)
        }else{
            dateString += String(describing: day)
        }
        
        return dateString
    }
}


extension Mark: ChangeDateDialogDelegate{
    func changeHeaderToDate(year: Int, month : Int, day: Int) {
        //changeHeaderText(text: "\(month)/\(day)")
        dateLabel.text = "\(month)/\(day)"
        
        currentDay = day
        currentMonth = month
        currentYear = year
    }
}

extension Mark: AddVisitorDialogDelegate{
    func addVisitor(visitorName: String) {
        let visitorMember = Member(id: NSUUID().uuidString, name: visitorName, g_id: GroupsDataFlow.getCurrentGroupID())
        visitorsArray.append(visitorMember)
        selectedMembers.append(true)
        reloadTableView()
    }
}


extension Mark: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        selectedMembers[row] = !selectedMembers[row]
        
        reloadTableView()
    }
}


extension Mark: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theMembersArray.count + visitorsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell: AttendanceTableViewCell = self.membersTableView.dequeueReusableCell(withIdentifier: "custom_cell") as! AttendanceTableViewCell
        
        if(row < theMembersArray.count){
            cell.cellLabel.text = theMembersArray[row].name
            cell.cellLabel.textColor = UIColor.black
        }else{
            cell.cellLabel.text = visitorsArray[row - theMembersArray.count].name
            cell.cellLabel.textColor = UIColor.blue
        }
        
        if(selectedMembers[row] == true){
            cell.showCheckMark()
        }else{
            cell.hideCheckMark()
        }
        
        return cell
    }
}

