//
//  Header.swift
//  tracker
//
//  Created by Joseph Liu on 10/21/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

protocol HeaderDelegate : class {
    func showMenu()
}

protocol HeaderBackDelegate : class {
    func backButtonPressed()
}

class Header: UIView {
    
    @IBOutlet weak var headerView : UIView!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    weak var delegate: HeaderDelegate?
    weak var backDelegate: HeaderBackDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setPageLabel(page: String){
        pageLabel.text = page
    }
    
    func showBackButton(){
        backButton.isHidden = false
    }
    
    func hideMenuButton(){
        //menuButton.isHidden = true
    }
    
    func loadViewFromNib() {
        let headerNib = UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: self, options: nil)
        let headerNibView = headerNib.first as! UIView
        headerNibView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(headerNibView)
        headerNibView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
    }
    
    @IBAction func menuButtonPressed(){
        delegate?.showMenu()
    }
    
    @IBAction func backButtonPressed(){
        backDelegate?.backButtonPressed()
    }
}
