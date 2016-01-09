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
    return self.lowercaseString.containsString(other.lowercaseString)
  }
}
