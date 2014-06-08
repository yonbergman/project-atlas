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
    var imageSrc:String { return data["imagesrc"] as String }
    var largeImageSrc:String { return data["largeimagesrc"] as String }
    var imageURL:NSURL {
        let imagePath = largeImageSrc.isEmpty ? imageSrc : largeImageSrc
        let imageUrl = "http://netrunnerdb.com\(imageSrc)"
        return NSURL(string: imageUrl)
    }
    
    var setCode:String { return data["set_code"] as String }
    var isReal:Bool { return setCode != "alt" && setCode != "special"}
    var factionCode:String { return data["faction_code"] as String }
    var sideCode:String { return data["side_code"] as String }
    
    var faction:String {
        if factionCode == "neutral" {
            return sideCode
        } else {
            return factionCode
        }
    }
    
    var cachedimage:UIImage?
    
    func image(callback: (UIImage) -> ()){
        if let img = cachedimage{
            callback(img)
            return
        }
        let imagePath = largeImageSrc.isEmpty ? imageSrc : largeImageSrc
        let imageUrl = "http://netrunnerdb.com\(imageSrc)"
        let url = NSURL(string: imageUrl)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let imageData = NSData(contentsOfURL: url)
            let image = UIImage(data: imageData)
            dispatch_async(dispatch_get_main_queue()) {
                callback(image)
            }
        }
        
    }
    
}