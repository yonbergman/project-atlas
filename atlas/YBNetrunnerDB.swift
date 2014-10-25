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
    optional func progressed(progress:Float)
    optional func errorFetchingCards(error: NSError)
}

class YBNetrunnerDB: NSObject {
    
    var baseURL:NSURL?
    var cards:Array<YBNetrunnerCard> = []
    var sets:Array<YBNetrunnerSet> = []
    var myDelegate:YBNetrunnerDelegate?
    
    func loadCards(){
        if baseURL == nil {
            loadSettings()
            return
        }
        let url = baseURL!
        
        let request = NSURLRequest(URL: url)
        var progress:NSProgress?
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.allZeros)
        let operation = manager.HTTPRequestOperationWithRequest(request,
            success: {
                (operation:AFHTTPRequestOperation!, obj:AnyObject!) in
                self.receivedJSON(obj as? NSArray)
                self.loadSets()
            }, failure: {
                (operation:AFHTTPRequestOperation!, error:NSError!) in
                self.errorReceived(error)
            })
        
        operation.setDownloadProgressBlock(){
            let progress:Float = Float($1)/Float($2)
            self.myDelegate?.progressed?(progress)
        }
        operation.start()
    }
    
    func loadSets(){
        YBAppConfig.getConfig { (config:PFConfig!, e:NSError!) -> () in
            let setURL = config["sets_url"] as String
            let manager = AFHTTPRequestOperationManager()
            manager.GET(setURL, parameters: nil, success: { (op:AFHTTPRequestOperation!, obj:AnyObject!) -> Void in
                let rawSets = obj as NSArray
                self.sets.removeAll(keepCapacity: true)
                for dict:AnyObject in rawSets {
                    let set = YBNetrunnerSet(dictionary: dict as NSDictionary)
                    self.sets.append(set)
                }
                self.sets.sort { $0.idx < $1.idx }
                    
                
                }, failure: nil)
        }


    }

    func loadSettings(){
        YBAppConfig.getConfig({
            (var config: PFConfig!, error: NSError!) in
            let stringURL = config["card_url"] as String
            self.baseURL = NSURL(string: stringURL)
            self.loadCards()
        })
    }
    
    func receivedJSON(jsonCards:NSArray?){
        cards.removeAll(keepCapacity: true)
        for dict:AnyObject in jsonCards!{
            let card = YBNetrunnerCard(dictionary: dict as NSDictionary)
            if card.isReal{
                cards.append(card)
            }
        }
        
        self.myDelegate?.fetchedCards()
    }
    
    func errorReceived(error:NSError){
        self.myDelegate?.errorFetchingCards?(error)
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
