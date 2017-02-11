//
//  ParentViewController.swift
//  tracker
//
//  Created by Joseph Liu on 10/22/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

class ParentViewController: UIViewController {
    
    var header: Header!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addHeaderView(headerViewContainer: UIView, pageLabel: String){
        header = Header(frame: headerViewContainer.frame)
        
        headerViewContainer.addSubview(header)
        
        header.delegate = self
        
        header.setPageLabel(page: pageLabel)
    }
    
    func changeHeaderText(text: String){
        header.setPageLabel(page: text)
    }

}


extension ParentViewController: HeaderDelegate{
    func showMenu() {
        let menuDialog = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "menuDialog") as! MenuDialog
        menuDialog.delegate = self
        present(menuDialog, animated: true, completion: nil)
    }
}

extension ParentViewController: MenuDialogDelegate{
    func logout(){
        /*UserDefaults.standard.setValue("", forKey: "current_user")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "logoutSegue", sender: nil)*/
        
        LoginDataFlow.logout {
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }
    }
}
