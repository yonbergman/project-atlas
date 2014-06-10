//
//  YBNetrunnerCard.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/8/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBNetrunnerCard {
    var data:NSDictionary
    init(dictionary: NSDictionary){
        data = dictionary
    }
    
    // #pragma mark description
    var title:String { return data["title"] as String }
    var type:String { return data["type"] as String }
    var subtype:String? { return data["subtype"] as? String }
    var subtitle:String {
        if self.subtype{
            return "\(type): \(subtype)"
        } else {
            return self.type
        }
    }
    
    // #pragma mark images
    var imageSrc:String { return data["imagesrc"] as String }
    var largeImageSrc:String { return data["largeimagesrc"] as String }
    var imageURL:NSURL {
        let imagePath = largeImageSrc.isEmpty ? imageSrc : largeImageSrc
        let imageUrl = "http://netrunnerdb.com\(imageSrc)"
        return NSURL(string: imageUrl)
    }

    // #pragma mark relevent
    var setCode:String { return data["set_code"] as String }
    var isReal:Bool { return setCode != "alt" && setCode != "special"}
    
    // #pragma mark influence
    var influence:Int {
        let factionCost = data["factioncost"] as? Int
        return factionCost ? factionCost! : 0
    }
    
    var unique:Bool { return data["uniqueness"] as Bool }

    // #pragma mark faction
    var factionCode:String { return data["faction_code"] as String }
    var sideCode:String { return data["side_code"] as String }
    var faction:String {
        if factionCode == "neutral" {
            return sideCode
        } else {
            return factionCode
        }
    }
    
    func matches(queryString:String?) -> Bool {
        if let query = queryString{
            return self.title.containsIgnoreCase(query)
        } else {
            return false
        }
    }
    
}