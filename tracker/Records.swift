//
//  SecondViewController.swift
//  tracker
//
//  Created by Joseph Liu on 10/21/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit
import Alamofire

class Records: ParentViewController {
    
    @IBOutlet weak var headerViewContainer: UIView!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl : UISegmentedControl!
    
    var arrayOfAttendanceDates : [AttendanceSet] = []
    var arrayOfMembers: [Member] = []
    
    var currentGroupID : String = ""
    
    var currentModeIsDates : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Records")
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        currentGroupID = GroupsDataFlow.getCurrentGroupID()
        
        updateDates()
        updateMembers()
        segmentedControl.addTarget(self, action: #selector(controlChanged), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(currentGroupID != GroupsDataFlow.getCurrentGroupID()){
            NSLog("group changed!")
            currentGroupID = GroupsDataFlow.getCurrentGroupID()
            updateDates()
            updateMembers()
        }
        
        if let newSubmit = UserDefaults.standard.value(forKey: "new-submit"){
            let newSubmitBool = newSubmit as! Bool
            if(newSubmitBool){
                UserDefaults.standard.setValue(false, forKey: "new-submit")
                updateDates()
            }
        }
        
        groupNameLabel.text = GroupsDataFlow.getCurrentGroupName()
        
        if(segmentedControl.selectedSegmentIndex == 0){
            //changeToByDate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableView(){
        self.tableView.reloadData()
        updateAverage()
    }
    
    func updateAverage(){
        var sum : Int = 0
        
        for attendanceObj in arrayOfAttendanceDates{
            sum += attendanceObj.getCount()
        }
        
        if(arrayOfAttendanceDates.count != 0){
            let average = Float(sum) / Float(arrayOfAttendanceDates.count)
            averageLabel.text = "AVERAGE ATTENDANCE: " + String(describing: Int(average.rounded()))
        }else{
            averageLabel.text = "AVERAGE ATTENDANCE: N/A"
        }
    }
    
    func controlChanged(){
        let state = segmentedControl.selectedSegmentIndex
        NSLog("STATE: " + String(describing: state))
        
        if(state == 0){
            currentModeIsDates = true
            updateDates()
        }else{
            currentModeIsDates = false
            NSLog("Change to By Member")
            updateMembers()
        }
    }
    
    func updateDates(){
        KVSpinnerView.showLoading()
        
        RecordDataFlow.getMongoArrayOfDates(groupID: GroupsDataFlow.getCurrentGroupID()) { (arrayOfDates) -> () in
            self.arrayOfAttendanceDates = []
            
            if(arrayOfDates.count == 0){
                KVSpinnerView.dismiss()
                self.reloadTableView()
            }
            
            for dateArr in arrayOfDates{
                let dateId = dateArr[0]
                let dateString = dateArr[1]
                
                RecordDataFlow.getMongoMembersArrayByDate(dateId: dateId) { (arrayOfMemberIds) -> () in
                    let attendanceObj = AttendanceSet(dateId: dateId, dateString: dateString)
                    
                    var count = 0
                    
                    for memberId in arrayOfMemberIds{
                        RecordDataFlow.getMongoMemberInfoById(memberId: memberId){ (memberObj) -> () in
                            attendanceObj.membersArr.append(memberObj)
                            
                            self.arrayOfAttendanceDates.sort { $0.dateString < $1.dateString }
                            self.reloadTableView()
                            
                            count += 1
                            if(count >= arrayOfMemberIds.count){
                                KVSpinnerView.dismiss()
                            }
                        }
                    }
                    
                    self.arrayOfAttendanceDates.append(attendanceObj)
                    
                    if(self.arrayOfAttendanceDates.count >= arrayOfDates.count){
                        self.reloadTableView()
                    }
                }
            }
        }
    }
        
    func updateMembers(){
        KVSpinnerView.showLoading()
        
        RecordDataFlow.getMongoArrayOfMembers(gID: GroupsDataFlow.getCurrentGroupID()) { (arrayOfMembers) -> () in
            self.arrayOfMembers = []
            
            for member in arrayOfMembers{
                
                RecordDataFlow.getMongoMemberAttendanceById(memberId: member.id) { (attendanceArr) -> () in
                    member.setAttendanceArr(attendanceArr: attendanceArr)
                    
                    self.arrayOfMembers.append(member)
                    
                    self.arrayOfMembers.sort { $0.name < $1.name }
                    
                    if(self.arrayOfMembers.count == arrayOfMembers.count){
                        KVSpinnerView.dismiss()
                        self.reloadTableView()
                    }
                }
            }
        }
    }
}

extension Records: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(currentModeIsDates){
            if(arrayOfAttendanceDates.count > 0){
                let attendanceObj = arrayOfAttendanceDates[indexPath.row]
                /*let alertController = UIAlertController(title: Helpers.getFormattedDateFromDateString(dateString: attendanceObj.dateString), message: attendanceObj.getMembers(), preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true)*/
                let menuDialog = UIStoryboard(name: "CustomAlerts", bundle: nil).instantiateViewController(withIdentifier: "attendanceRecord") as! AttendanceRecordAlert
                menuDialog.setTitle(title: Helpers.getFormattedDateFromDateString(dateString: attendanceObj.dateString))
                menuDialog.setMessage(message: attendanceObj.getMembers(), numberOfLines: attendanceObj.getCount())
                present(menuDialog, animated: true, completion: nil)
            }
        }else{
            let memberObj = arrayOfMembers[indexPath.row]
            let alertController = UIAlertController(title: memberObj.name, message: String(describing: memberObj.getAttendanceString()), preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return currentModeIsDates && arrayOfAttendanceDates.count > 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let attendanceSet = arrayOfAttendanceDates[indexPath.row]
            let dateID = attendanceSet.dateId
            
            RecordDataFlow.deleteAttendanceSet(dateID: dateID!, completion: {
                self.arrayOfAttendanceDates.remove(at: indexPath.row)
                self.reloadTableView()
            })
        }
    }
}

extension Records: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_group_cell") as! CellGroupTableViewCell
        if(currentModeIsDates){
            if(arrayOfAttendanceDates.count == 0){
                cell.dateLabel.text = "No Records"
                cell.countLabel.text = ""
            }else{
                //cell.dateLabel.text = arrayOfAttendanceDates[indexPath.row].dateString
                cell.dateLabel.text = Helpers.getFormattedDateFromDateString(dateString: arrayOfAttendanceDates[indexPath.row].dateString)
                cell.countLabel.text = String(describing: arrayOfAttendanceDates[indexPath.row].getCount())
            }
        }else{
            cell.dateLabel.text = arrayOfMembers[indexPath.row].name
            cell.countLabel.text = String(describing: arrayOfMembers[indexPath.row].attendance.count)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(currentModeIsDates){
            if(arrayOfAttendanceDates.count == 0){
                return 1
            }
            return arrayOfAttendanceDates.count
        }else{
            return arrayOfMembers.count
        }
    }
}
