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
    
    var arrayOfAttendanceDates : [Attendance] = []
    
    var currentGroupID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Records")
        
        currentGroupID = GroupsDataFlow.getCurrentGroupID()
        
        updateDates()
        segmentedControl.addTarget(self, action: #selector(controlChanged), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(currentGroupID != GroupsDataFlow.getCurrentGroupID()){
            NSLog("group changed!")
            currentGroupID = GroupsDataFlow.getCurrentGroupID()
            updateDates()
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
            updateDates()
        }else{
            NSLog("Change to By Member")
        }
    }
    
    func updateDates(){
        RecordDataFlow.getMongoArrayOfDates(groupID: GroupsDataFlow.getCurrentGroupID()) { (arrayOfDates) -> () in
            NSLog("the array of dates: " + String(describing: arrayOfDates))
            
            self.arrayOfAttendanceDates = []
            
            if(arrayOfDates.count == 0){
                self.reloadTableView()
            }
            
            for dateArr in arrayOfDates{
                let dateId = dateArr[0]
                let dateString = dateArr[1]
                
                RecordDataFlow.getMongoMembersArrayByDate(dateId: dateId) { (arrayOfMemberIds) -> () in
                    let attendanceObj = Attendance(dateId: dateId, dateString: dateString)
                    
                    for memberId in arrayOfMemberIds{
                        RecordDataFlow.getMongoMemberInfoById(memberId: memberId){ (memberObj) -> () in
                            attendanceObj.membersArr.append(memberObj)
                            if(attendanceObj.membersArr.count >= arrayOfMemberIds.count && self.arrayOfAttendanceDates.count >= arrayOfDates.count){
                                self.arrayOfAttendanceDates.sort { $0.dateString < $1.dateString }
                                self.reloadTableView()
                            }
                        }
                    }
                    
                    self.arrayOfAttendanceDates.append(attendanceObj)
                    
                    if(self.arrayOfAttendanceDates.count >= arrayOfDates.count){
                        //self.reloadTableView()
                    }
                }
            }
        }
    }
}

extension Records: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let attendanceObj = arrayOfAttendanceDates[indexPath.row]
        let alertController = UIAlertController(title: attendanceObj.dateString, message: attendanceObj.getMembers(), preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

extension Records: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_group_cell") as! CellGroupTableViewCell
        cell.dateLabel.text = arrayOfAttendanceDates[indexPath.row].dateString
        cell.countLabel.text = String(describing: arrayOfAttendanceDates[indexPath.row].getCount())
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfAttendanceDates.count
    }
}
