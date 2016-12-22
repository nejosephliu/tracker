//
//  SecondViewController.swift
//  tracker
//
//  Created by Joseph Liu on 10/21/16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit
import Alamofire

class Records: ParentViewController {

    @IBOutlet weak var headerViewContainer: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        addHeaderView(headerViewContainer: headerViewContainer, pageLabel: "Records")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func makeRequest(key : Int){
        if (key == 0){
            Alamofire.request("http://localhost:8081/members").responseJSON{ response in
                let json = response.result.value!
                
                let blah = json as! NSArray
                
                NSLog("blah: " + String(describing: blah))
            }
        }else{
            Alamofire.request("http://localhost:8081/members-key/" + "0").responseJSON{ response in
                if let json = response.result.value {
                    let responseArr = json as! NSArray
                    
                    for individual in responseArr{
                        let individualArr = individual as! NSDictionary
                        let name = individualArr["name"] as! String
                        NSLog("yoyo: " + name)
                    }
                }
            }
        }
    }
        
    
    @IBAction func requestButtonPressed(){
        makeRequest(key: 1)
    }
    
    @IBAction func requestAllButtonPressed(){
        makeRequest(key: 0)
    }

    @IBAction func postButtonPressed(){
        let parameters: Parameters = [
            "List": [
                [
                    "Name" : "John",
                    "ID": 222,
                    "email" : "John@gmail.com"
                ],
                [
                    "Name" : "Jane",
                    "ID": 33,
                    "email" : "Jane@gmail.com"
                ]
            ]
        ]
        Alamofire.request("http://localhost:8081/submit-attendance", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            NSLog("hey")
        }
    }
}
