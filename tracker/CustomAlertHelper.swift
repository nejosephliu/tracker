//
//  AlertHelper.swift
//  tracker
//
//  Created by Joseph Liu on 4/21/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import UIKit

class CustomAlertHelper{
    static func presentCustomAlert(title: String, message: String, viewController: UIViewController){
        let menuDialog = UIStoryboard(name: "CustomAlerts", bundle: nil).instantiateViewController(withIdentifier: "customAlert") as! ParentCustomAlert
        menuDialog.setTitle(title: title)
        menuDialog.setMessage(message: message)
        viewController.present(menuDialog, animated: true, completion: nil)
    }
    
    static func presentCustomAlert(title: String, message: String, numberOfLines: Int, viewController: UIViewController){
        let menuDialog = UIStoryboard(name: "CustomAlerts", bundle: nil).instantiateViewController(withIdentifier: "customAlert") as! ParentCustomAlert
        menuDialog.setTitle(title: title)
        menuDialog.setMessage(message: message, numberOfLines: numberOfLines)
        viewController.present(menuDialog, animated: true, completion: nil)
    }
}
