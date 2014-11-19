//
//  YBNetrunnerSet.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/20/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBNetrunnerSet: NSObject {
    var data:NSDictionary
    init(dictionary: NSDictionary){
        data = dictionary
        self.selected = true;
    }
    
    var name:String { return data["name"] as String }
    var code:String { return data["code"] as String }
    var cycleNumber:UInt { return (data["cyclenumber"] as UInt) }
    var idx:UInt { return (self.cycleNumber) * 10 + (data["number"] as UInt)  }
    var cycle:String? {
        switch self.cycleNumber{
            case 2: return "Genesis Cycle"
            case 4: return "Spin Cycle"
            case 6: return "Lunar Cycle"
            case 8: return "SanSan Cycle"
            default: return ""
        }
    }
    
    var selected:Bool


}
