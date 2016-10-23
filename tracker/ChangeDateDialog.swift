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

class ChangeDateDialog: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: ChangeDateDialogDelegate!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        definesPresentationContext = true
        providesPresentationContextTransitionStyle = true
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let tapGestureRecgonizer = UITapGestureRecognizer(target: self, action: #selector(dismissDialog))
        backgroundView.addGestureRecognizer(tapGestureRecgonizer)
    }

    func dismissDialog(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitDate(){
        let components = datePicker.calendar.dateComponents(Set<Calendar.Component>([.year, .month, .day]), from: datePicker.date as Date)
        
        let month = components.month!
        let day = components.day!
        
        delegate.changeHeaderToDate(date: "\(month)/\(day)")
        dismissDialog()
    }

}
