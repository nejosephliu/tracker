//
//  AddMemberTableViewCell.swift
//  tracker
//
//  Created by Joseph Liu on 2/13/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import UIKit

class AddMemberTableViewCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //dateLabel.text = "12/11"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*func setCount(count: Int){
        countLabel.text = String(describing: count)
    }*/
}
