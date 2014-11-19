//
//  YBNetrunnerSet.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/20/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit


@objc protocol YBNetrunnerSetDelegate {
    func setSelectionUpdated(set: YBNetrunnerSet)
}

class YBNetrunnerSet: NSObject {
    var delegate:YBNetrunnerSetDelegate?

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
            case 2: return "Genesis"
            case 4: return "Spin"
            case 6: return "Lunar"
            case 8: return "SanSan"
            default: return ""
        }
    }
    var isReal:Bool{
        return self.cycleNumber > 0
    }
    
    var selected:Bool {
        didSet {
            self.delegate?.setSelectionUpdated(self)
        }
    }


}
