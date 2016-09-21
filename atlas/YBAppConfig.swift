//
//  YBAppConfig.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/20/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBAppConfig: NSObject {
    
    class func cardURL() -> String {
      return "https://netrunnerdb.com/api/2.0/public/cards"
    }
    
    class func setsURL() -> String {
      return "https://netrunnerdb.com/api/2.0/public/packs"
    }
   
}
