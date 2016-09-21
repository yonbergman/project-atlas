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
    cycleCode = json["cycle_code"].stringValue
    cycleNumber = YBNetrunnerSet.cycleCode(self.cycleCode)
    number = json["position"].uIntValue

  }
  let name: String
  let cycleCode: String
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
    case 12: return "Flashpoint"
    default: return ""
    }
  }
  class func cycleCode(string: String) -> UInt {
    switch string {
      case "core": return 1
      case "genesis": return 2
      case "creation-and-control": return 3
      case "spin": return 4
      case "honor-and-profit": return 5
      case "lunar": return 6
      case "order-and-chaos": return 7
      case "sansan": return 8
      case "data-and-destiny": return 9
      case "mumbad": return 10
      case "flashpoint": return 12
      default: return 0
    }
  }

  lazy var isReal: Bool = {
    return self.cycleNumber > 0
  }()

  var selected: Bool = true

}
