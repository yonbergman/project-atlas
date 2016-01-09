//
//  YBCardSearch.swift
//  atlas
//
//  Created by Yonatan Bergman on 12/1/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

enum YBCardSearchMode{
    case CardTitle
    case CardType
    case CardFaction
}

class YBCardSearch {
    var searchTokens:[(String, YBCardSearchMode)]
    var searchQuery:String
    let netrunnerDB:YBNetrunnerDB
    
    init(netrunnerDB:YBNetrunnerDB) {
        self.netrunnerDB = netrunnerDB
        self.searchQuery = ""
        self.searchTokens = []
    }
    
    func search(query:String) -> [YBNetrunnerCard]{
        parseQuery(query)
        var cards = netrunnerDB.filterCards()
        for (searchQuery,searchMode) in searchTokens {
            cards = cards.filter { card in
                switch searchMode {
                    case .CardFaction:
                        return card.matchFaction(searchQuery)
                    case .CardTitle:
                        return card.matchTitle(searchQuery)
                    case .CardType:
                        return card.matchType(searchQuery)
                }
            }
        }
        return cards;
    }
    
    func parseQuery(query:String){
        let trimmedQuery = query.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).lowercaseString
        self.searchQuery = trimmedQuery
        
        self.searchTokens = searchQuery.componentsSeparatedByString(" ").map({ (string) -> (String, YBCardSearchMode) in
            var mode:YBCardSearchMode = .CardTitle
            var queryPart = string
            
            if queryPart.characters.startsWith("s:".characters) {
                mode = .CardType
            } else if queryPart.characters.startsWith("f:".characters) {
                mode = .CardFaction
            }
            if mode != .CardTitle {
                queryPart.removeRange(Range(start:queryPart.startIndex, end: queryPart.startIndex.advancedBy(2)))
            }
            return (queryPart, mode)
        })
    }
    
    

}
