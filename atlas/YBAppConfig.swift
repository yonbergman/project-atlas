//
//  YBAppConfig.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/20/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBAppConfig: NSObject {
    
    class func getConfig(callback: (PFConfig!, NSError!) -> ()){
        PFConfig.getConfigInBackgroundWithBlock {
            (var config: PFConfig!, error: NSError!) in
            if error == nil {
                callback(config, error)
            } else {
                callback(PFConfig.currentConfig(), error)
            }
        }
    }
   
}
