//
//  String+Contains.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/9/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import Foundation

extension String {
 
    func containsIgnoreCase(other: String) -> Bool{
        var start = startIndex
        let otherLowerCased = other.bridgeToObjectiveC().lowercaseString
        let myselfLowerCased = self.bridgeToObjectiveC().lowercaseString
        
        do{
            var subString = myselfLowerCased[Range(start: start++, end: endIndex)]
            if subString.hasPrefix(otherLowerCased){
                return true
            }
            
        }while start != endIndex
        
        return false
    }
}
