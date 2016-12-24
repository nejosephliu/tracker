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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl : UISegmentedControl!
    
    var arrayOfAttendanceDates : [Attendance] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Records")
        changeToByDate()
        segmentedControl.addTarget(self, action: #selector(controlChanged), for: UIControlEvents.valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controlChanged(){
        NSLog("STATE: " + String(describing: segmentedControl.selectedSegmentIndex))
        changeToByDate()
    }
    
    func changeToByDate(){
        RecordDataFlow.getMongoArrayOfDates(cellGroupId: 0) { (arrayOfDates) -> () in
            NSLog(String(describing: arrayOfDates))
            
            self.arrayOfAttendanceDates = []
            
            for dateArr in arrayOfDates{
                let dateId = dateArr[0]
                
                NSLog("date array: " + String(describing: dateArr))
                
                RecordDataFlow.getMongoMembersArrayByDate(dateId: dateId) { (arrayOfMemberIds) -> () in
                    
                    var arrayOfMembers : [Member] = []
                    
                    let attendanceObj = Attendance(dateId: dateId, dateString: dateArr[1])
                    
                    for memberId in arrayOfMemberIds{
                        RecordDataFlow.getMongoMemberInfoById(memberId: memberId){ (memberObj) -> () in
                            attendanceObj.membersArr.append(memberObj)
                            self.tableView.reloadData()
                        }
                    }
                    
                    self.arrayOfAttendanceDates.append(attendanceObj)
                }
            }
        }
    }
}

extension Records: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
