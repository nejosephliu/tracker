//
//  ChangeDateDialog.swift
//  tracker
//
//  Created by Joseph Liu on 10/23/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

protocol ChangeDateDialogDelegate: class{
    func changeHeaderToDate(date: String)
}

class ChangeDateDialog: ParentDialog {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: ChangeDateDialogDelegate!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    func setDate(date: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "MM:dd"
        
        let date = dateFormatter.date(from: "12:01")
        
        datePicker.date = date!
    }
    
    @IBAction func submitDate(){
        let components = datePicker.calendar.dateComponents(Set<Calendar.Component>([.year, .month, .day]), from: datePicker.date as Date)
        
        let month = components.month!
        let day = components.day!
        
        delegate.changeHeaderToDate(date: "\(month)/\(day)")
        dismissDialog()
    }

}
