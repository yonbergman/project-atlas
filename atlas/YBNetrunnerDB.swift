//
//  YBNetrunnerDB.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/6/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBNetrunnerCard {
    var data:NSDictionary
    init(dictionary: NSDictionary){
        data = dictionary
    }
    
    var title:String { return data["title"] as String }
    var imageSrc:String { return data["imagesrc"] as String }
    var largeImageSrc:String { return data["largeimagesrc"] as String }
    var setCode:String { return data["set_code"] as String }
    var isReal:Bool { return setCode != "alt" && setCode != "special"}
    
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
        

//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Update the UI
//                self.imageView.image = [UIImage imageWithData:imageData];
//                });
//            });

//        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue()) {
//            (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
//            let image = UIImage(data: data)
//            self.cachedimage = image
//            callback(image)
//        }

    }
    
}

@objc protocol YBNetrunnerDelegate {

    func fetchedCards()
    @optional func errorFetchingCards(error: NSError)
}

class YBNetrunnerDB: NSObject {
    
    var baseURL:NSURL = NSURL(string: "http://netrunnerdb.com/api/cards/")
    var cards:Array<YBNetrunnerCard> = []
    var myDelegate:YBNetrunnerDelegate?
    
    func fetchCards() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: baseURL), queue: NSOperationQueue()) {
            (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if (error){
                println("error fetching cards")
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.receivedJSON(data)
                }
            }
        }
    }
    func receivedJSON(data:NSData){
        var error:NSError?
        let jsonCards = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSArray

        if (error){
            myDelegate?.errorFetchingCards?(error!)
        } else {
            cards.removeAll(keepCapacity: true)
            for dict:AnyObject in jsonCards!{
                let card = YBNetrunnerCard(dictionary: dict as NSDictionary)
                if card.isReal{
                    cards.append(card)
                }
            }
            
            self.myDelegate?.fetchedCards()
        }
    }
    
    func count() -> Int {
        return cards.count
    }
    
    subscript(index: Int) -> YBNetrunnerCard {
        get {
            return cards[index]
        }
    }

    
}
