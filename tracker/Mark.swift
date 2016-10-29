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
    
    var membersArray: [String] = []
    var selectedMembers: [Bool] = []
    
    var visitorsArray: [String] = []
    
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
        
        let dateString = "\(components.month!)/\(components.day!)"
        changeHeaderText(text: dateString)
    }
    
    func getListOfMembers(){
        MarkTableViewDataFlow.getArrayOfMembers(cellGroup: "cup_1") { (arrayOfMembers) -> () in
            for member in arrayOfMembers{
                self.membersArray.append(member as! String)
                self.selectedMembers.append(false)
            }
            
            self.membersArray.sort()
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
}


extension Mark: ChangeDateDialogDelegate{
    func changeHeaderToDate(date: String) {
        changeHeaderText(text: date)
    }
}

extension Mark: AddVisitorDialogDelegate{
    func addVisitor(visitorName: String) {
        visitorsArray.append(visitorName)
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
        return membersArray.count + visitorsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell: AttendanceTableViewCell = self.membersTableView.dequeueReusableCell(withIdentifier: "custom_cell") as! AttendanceTableViewCell
        
        if(row < membersArray.count){
            cell.cellLabel.text = membersArray[row]
            cell.cellLabel.textColor = UIColor.black
        }else{
            cell.cellLabel.text = visitorsArray[row - membersArray.count]
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




