//
//  YBNetrunnerCard.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/8/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias YBNetrunnerCards = [YBNetrunnerCard]

class YBNetrunnerCard {
  init(json: JSON, imageTemplate: String) {
    title = json["title"].stringValue
    type = json["type_code"].stringValue
    subtype = json["keywords"].string
    text = json["text"].stringValue
    code = json["code"].stringValue
    url = json["url"].stringValue
    setCode = json["pack_code"].stringValue
    influence = json["factioncost"].intValue
    unique = json["uniqueness"].boolValue
    sideCode = json["side_code"].stringValue
    factionCode = json["faction_code"].stringValue
    side = json["side"].stringValue.lowercaseString
    factionName = json["faction"].stringValue.lowercaseString
    self.imageTemplate = imageTemplate
  }

  let title: String
  let type: String
  let subtype: String?
  let text: String
  let code: String
  let url: String
  let setCode: String
  let influence: Int
  let unique: Bool
  let factionCode: String
  let side: String
  let factionName: String
  lazy var sideFaction: String = { return self.side + " " + self.factionName }()
  let sideCode: String
  let imageTemplate: String

  lazy var subtitle: String = {
    if let subtype = self.subtype where !subtype.isEmpty {
        return "\(self.type): \(subtype)"
    } else {
        return self.type
    }
  }()
  
  lazy var imageURL: NSURL! = {
    let imageUrl = self.imageTemplate.stringByReplacingOccurrencesOfString("{code}", withString: self.code)
    return NSURL(string: imageUrl)
  }()

  lazy var isReal: Bool = { !["alt", "special", "draft"].contains(self.setCode) }()

  lazy var faction: String = {
      if self.factionCode == "neutral-corp" || self.factionCode == "neutral-runner" {
          return self.sideCode
      } else {
          return self.factionCode
      }
  }()
      
  func matchTitle(queryString:String?) -> Bool {
      if let query = queryString{
          return self.title.containsIgnoreCase(query)
      } else {
          return false
      }
  }

  func matchType(queryString:String?) -> Bool {
      if let query = queryString{
          return self.subtitle.containsIgnoreCase(query)
      } else {
          return false
      }
  }
  
  func matchFaction(queryString:String?) -> Bool {
      if let query = queryString{
          return self.factionCode.containsIgnoreCase(query)
      } else {
          return false
      }
  }

  func matchText(query: String?) -> Bool {
    guard let query = query else { return false }
    return self.text.containsIgnoreCase(query)
  }
  
}