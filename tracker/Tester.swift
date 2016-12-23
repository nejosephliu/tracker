//
//  Tester.swift
//  tracker
//
//  Created by Joseph Liu on 12/22/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//


import UIKit
import Alamofire

class Tester: ParentViewController {
    
    @IBOutlet weak var headerViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Tester")
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
}
