//
//  YBNetrunnerDB.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/6/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

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
