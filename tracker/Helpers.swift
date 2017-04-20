//
//  Helpers.swift
//  tracker
//
//  Created by Joseph Liu on 4/20/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import UIKit

class Helpers{
    static func getFormattedDateFromDateString(dateString: String) -> String{
        let year = String(describing: Int(dateString.substring(to: dateString.index(dateString.startIndex, offsetBy: 4)))!)
        
        let month = Int(dateString.substring(with: dateString.index(dateString.startIndex, offsetBy: 5)..<dateString.index(dateString.startIndex, offsetBy: 7)))
        let day = Int(dateString.substring(with: dateString.index(dateString.startIndex, offsetBy: 8)..<dateString.index(dateString.startIndex, offsetBy: 10)))
        
        return Constants.monthArr[month! - 1] + " " + String(describing: day!) + Constants.suffixArr[day! - 1] + ", " + year
    }
}
