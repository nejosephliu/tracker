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
    
    var currentDay : Int!
    var currentMonth : Int!
    var currentYear : Int!
    
    var theMembersArray : [Member] = []
    var visitorsArray: [Member] = []
    var selectedMembers: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Mark")
        
        getListOfMembers()
        
        setDateHeader()
        
        NSLog("Current user: " + String(describing: UserDefaults.standard.value(forKey: "current_user")))
        
        reloadTableView()
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
        
        changeHeaderText(text: "\(components.month!)/\(components.day!)")
    }
    
    func getListOfMembers(){
        MarkTableViewDataFlow.getMongoArrayOfMembers(cellGroupId: 0) { (arrayOfMembers) -> () in
            
            for _ in 0...arrayOfMembers.count - 1{
                self.selectedMembers.append(false)
            }
            
            self.theMembersArray = arrayOfMembers
            self.membersTableView.reloadData()
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
        present(changeDateDialog, animated: true, completion: nil)
        
        changeDateDialog.setDate(year: currentYear, month: currentMonth, day: currentDay)
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
        
        let dateString = String(describing: currentYear!) + "-" + String(describing:currentMonth!) + "-" + String(describing: currentDay!);
        
        MarkTableViewDataFlow.submitMongoAttendance(attendanceArr: membersHereArr, dateString: dateString)
    }
}


extension Mark: ChangeDateDialogDelegate{
    func changeHeaderToDate(year: Int, month : Int, day: Int) {
        changeHeaderText(text: "\(month)/\(day)")
        
        currentDay = day
        currentMonth = month
        currentYear = year
    }
}

extension Mark: AddVisitorDialogDelegate{
    func addVisitor(visitorName: String) {
        let visitorMember = Member(id: NSUUID().uuidString, name: visitorName, g_id: 0, email: "")
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



