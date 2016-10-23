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
    
    var membersArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Mark")
        
        getData()
        
        setDateHeader()
        
        NSLog("Current user: " + String(describing: UserDefaults.standard.value(forKey: "current_user")))
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
    
    func getData(){
        MarkTableViewDataFlow.getArrayOfMembers(cellGroup: "cup_1") { (arrayOfMembers) -> () in
            for member in arrayOfMembers{
                NSLog("member: " + String(describing: member))
                self.membersArray.append(member as! String)
            }
            
            self.membersArray.sort()
            
            self.membersTableView.reloadData()
        }
    }
    
    @IBAction func changeDateButtonPressed(){
        let changeDateDialog = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "changeDateDialog") as! ChangeDateDialog
        //changeDateDialog.delegate = self
        present(changeDateDialog, animated: true, completion: nil)
    }
}


extension Mark: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension Mark: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("yo: " + String(describing: membersTableView))
        
        self.membersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let cell:UITableViewCell = self.membersTableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        
        
        cell.textLabel?.text = membersArray[indexPath.row]
        
        return cell
    }
    
}


