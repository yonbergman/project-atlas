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
  init(json: JSON) {
    title = json["title"].stringValue
    type = json["type"].stringValue
    subtype = json["subtype"].string
    text = json["text"].stringValue
    imageSrc = json["imagesrc"].stringValue
    url = json["url"].stringValue
    setCode = json["set_code"].stringValue
    influence = json["factioncost"].intValue
    unique = json["uniqueness"].boolValue
    sideCode = json["side_code"].stringValue
    factionCode = json["faction_code"].stringValue
    side = json["side"].stringValue.lowercaseString
    factionName = json["faction"].stringValue.lowercaseString
  }

  let title: String
  let type: String
  let subtype: String?
  let text: String
  let imageSrc: String
  let url: String
  let setCode: String
  let influence: Int
  let unique: Bool
  let factionCode: String
  let side: String
  let factionName: String
  lazy var sideFaction: String = { return self.side + " " + self.factionName }()
  let sideCode: String

  lazy var subtitle: String = {
    if let subtype = self.subtype where !subtype.isEmpty {
        return "\(self.type): \(subtype)"
    } else {
        return self.type
    }
  }()
  
  lazy var imageURL: NSURL! = {
    let imageUrl = "http://netrunnerdb.com\(self.imageSrc)"
    return NSURL(string: imageUrl)
  }()

  lazy var isReal: Bool = { !["alt", "special", "draft"].contains(self.setCode) }()

  lazy var faction: String = {
      if self.factionCode == "neutral" {
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
          return self.sideFaction.containsIgnoreCase(query)
      } else {
          return false
      }
  }
  
}