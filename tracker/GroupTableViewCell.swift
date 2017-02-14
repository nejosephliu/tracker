//
//  GroupTableViewCell.swift
//  tracker
//
//  Created by Joseph Liu on 2/14/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import Foundation

import UIKit

class GroupTableViewCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
