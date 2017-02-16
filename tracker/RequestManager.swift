//
//  RequestManager.swift
//  tracker
//
//  Created by Joseph Liu on 2/16/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import Foundation

class RequestManager{
    class func urlEncode(url : String) -> String{
        return url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
}
