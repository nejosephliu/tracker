//
//  Tester.swift
//  tracker
//
//  Created by Joseph Liu on 12/22/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//


import UIKit
import Alamofire
import DropDown

class Tester: ParentViewController {
    
    @IBOutlet weak var headerViewContainer: UIView!
    @IBOutlet weak var dropView: UIView!
    
    var drop = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        
        drop.anchorView = dropView
        drop.dataSource = ["Car 1", "Car 2"]
        //self.dropdown.direction = .bottom
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //		appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray

        
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Tester")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drop.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeRequest(key : Int){
        if (key == 0){
            Alamofire.request(Constants.baseURL + "members").responseJSON{ response in
                let json = response.result.value!
                
                let blah = json as! NSArray
                
                NSLog("blah: " + String(describing: blah))
            }
        }else if(key == 1){
            Alamofire.request(Constants.baseURL + "members-key/" + "0").responseJSON{ response in
                if let json = response.result.value {
                    let responseArr = json as! NSArray
                    
                    for individual in responseArr{
                        let individualArr = individual as! NSDictionary
                        let name = individualArr["name"] as! String
                        NSLog("yoyo: " + name)
                    }
                }
            }
        }else if(key == 2){
            Alamofire.request(Constants.baseURL + "attendance").responseJSON{ response in
                let json = response.result.value!
                
                let blah = json as! NSArray
                
                NSLog("blah: " + String(describing: blah))
            }
        }else if(key == 3){
            Alamofire.request(Constants.baseURL + "dates").responseJSON{ response in
                let json = response.result.value!
                
                let blah = json as! NSArray
                
                NSLog("blah: " + String(describing: blah))
            }
        }
    }
    
    
    @IBAction func requestButtonPressed(){
        makeRequest(key: 1)
    }
    
    @IBAction func requestAllButtonPressed(){
        makeRequest(key: 0)
    }
    
    @IBAction func requestAttendanceButtonPressed(){
        makeRequest(key: 2)
    }
    
    @IBAction func requestDatesButtonPressed(){
        makeRequest(key: 3)
    }
}
