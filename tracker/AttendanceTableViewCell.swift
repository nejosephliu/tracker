//
//  AttendanceTableViewCell.swift
//  tracker
//
//  Created by Joseph Liu on 10/28/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class AttendanceTableViewCell: UITableViewCell{
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //checkMark.image = UIImage(named: "second")
        checkMark.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showCheckMark(){
        checkMark.isHidden = false
    }
    
    func hideCheckMark(){
        checkMark.isHidden = true
    }
}
