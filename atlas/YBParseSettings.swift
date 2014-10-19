//
//  YBParseSettings.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/20/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBParseSettings: NSObject {
    
    class func getValueForKey(key: String, success: (String) -> ()){
        let query = PFQuery(className: "settings")
        query.whereKey("key", equalTo: key)
        query.findObjectsInBackgroundWithBlock { (r: [AnyObject]!, e: NSError!) -> Void in
            if e != nil {
//                fail(e)
            } else {
                if r.count > 0 {
                    let cardURL = r.first as PFObject
                    let value = cardURL["value"] as String
                    success(value)
                }
            }
        }
    }
   
}
