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
    func changeHeaderToDate(year: Int, month : Int, day: Int)
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
    
    func setDate(year: Int, month: Int, day: Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "MM/dd/yy"
        
        let dateString = String(describing: month) + "/" + String(describing: day) + "/" + String(describing: year)
        
        let date = dateFormatter.date(from: dateString)
        
        datePicker.date = date!
    }
    
    @IBAction func submitDate(){
        let components = datePicker.calendar.dateComponents(Set<Calendar.Component>([.year, .month, .day]), from: datePicker.date as Date)
        
        let year = components.year!
        let month = components.month!
        let day = components.day!
        
        delegate.changeHeaderToDate(year: year, month: month, day: day)
        dismissDialog()
    }

}
