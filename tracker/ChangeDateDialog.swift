//
//  ChangeDateDialog.swift
//  tracker
//
//  Created by Joseph Liu on 10/23/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit
import JBDatePicker

protocol ChangeDateDialogDelegate: class{
    func changeHeaderToDate(year: Int, month : Int, day: Int)
}

class ChangeDateDialog: ParentDialog {
    
    @IBOutlet weak var customDatePicker: JBDatePickerView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var dateToSelect: Date!
    
    var cYear: Int!
    var cMonth: Int!
    var cDay: Int!
    
    weak var delegate: ChangeDateDialogDelegate!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        customDatePicker.delegate = self
        
        let month = customDatePicker.presentedMonthView?.monthDescription
        monthLabel.text = month?.uppercased()
    }
    
    func setDate(year: Int, month: Int, day: Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "MM/dd/yy"
        
        cYear = year
        cMonth = month
        cDay = day
        
        let dateString = String(describing: month) + "/" + String(describing: day) + "/" + String(describing: year)
        let date = dateFormatter.date(from: dateString)
        dateToSelect = date!
    }
    
    @IBAction func submitDate(){
        delegate.changeHeaderToDate(year: cYear, month: cMonth, day: cDay)
        dismissDialog()
    }

    @IBAction func previousMonthPressed(){
        customDatePicker.loadPreviousView()
    }
    
    @IBAction func nextMonthPressed(){
        customDatePicker.loadNextView()
    }
}

extension ChangeDateDialog: JBDatePickerViewDelegate{
    func didSelectDay(_ dayView: JBDatePickerDayView) {
        let date = dayView.date!
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        cYear = year
        cMonth = month
        cDay = day
    }
    
    func didPresentOtherMonth(_ monthView: JBDatePickerMonthView) {
        monthLabel.text = customDatePicker.presentedMonthView.monthDescription
    }
    
    var dateToShow: Date {
        if let date = dateToSelect {
            return date
        }
        else{
            return Date()
        }
    }
    
    var firstWeekDay: JBWeekDay { return .sunday }
    var shouldShowMonthOutDates: Bool { return true }
    var weekDaysViewHeightRatio: CGFloat { return 0.15 }
    var selectionShape: JBSelectionShape { return .square }
    var colorForCurrentDay: UIColor { return Constants.lightBlueColor }
    var colorForSelectionCircleForToday: UIColor { return Constants.lightBlueColor }
    var fontForWeekDaysViewText: JBFont { return JBFont(name: "Courier New", size: .large) }
    var colorForSelectionCircleForOtherDate: UIColor { return Constants.lightBlueColor }
    var colorForWeekDaysViewBackground: UIColor { return Constants.lightBlueColor }
    //var colorForSelelectedDayLabel: UIColor { return UIColor of choice }
    //var fontForDayLabel: JBFont { return JBFont(name: "Avenir", size: .medium) }
    
}
