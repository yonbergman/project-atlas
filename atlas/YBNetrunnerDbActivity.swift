//
//  YBNetrunnerDbActivity.swift
//  atlas
//
//  Created by Yonatan Bergman on 11/25/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

//import Cocoa

class YBNetrunnerDbActivity: UIActivity {
    
    var netrunnerDB:YBNetrunnerDB
    var card:YBNetrunnerCard?
    
    init(netrunnerDB: YBNetrunnerDB) {
        self.netrunnerDB = netrunnerDB
    }
    
    override func activityTitle() -> String? {
        return "Open on NetrunnerDB"
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "netrunner-db-activity")
    }

    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        var cardTitle = activityItems.last as String
        cardTitle = cardTitle.componentsSeparatedByString("\n").first!
        let cards = self.netrunnerDB.cards.filter { (card) -> Bool in
            return card.title == cardTitle
        }
        if let card = cards.first {
            self.card = card
        }
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func performActivity() {
        if let card = self.card {
            UIApplication.sharedApplication().openURL(NSURL(string: card.url)!)
        }
    }

}
