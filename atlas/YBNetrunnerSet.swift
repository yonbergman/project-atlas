//
//  YBNetrunnerSet.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/20/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit
import SwiftyJSON


class YBNetrunnerSet: NSObject {

  init(json: JSON) {
    name = json["name"].stringValue
    code = json["code"].stringValue
    cycleNumber = json["cyclenumber"].uIntValue
    number = json["number"].uIntValue

  }
  let name: String
  let code: String
  let cycleNumber: UInt
  let number: UInt
  lazy var idx: UInt = { self.cycleNumber * 10 + self.number }()
  lazy var cycle: String = { YBNetrunnerSet.cycleName(self.cycleNumber) }()

  class func cycleName(number: UInt) -> String{
    switch number {
    case 2: return "Genesis"
    case 4: return "Spin"
    case 6: return "Lunar"
    case 8: return "SanSan"
    case 10: return "Mumbad"
    default: return ""
    }
  }

  lazy var isReal: Bool = {
    return self.cycleNumber > 0
  }()

  var selected: Bool = true

}
