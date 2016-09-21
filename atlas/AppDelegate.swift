//
//  AppDelegate.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/6/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    application.statusBarStyle = .LightContent
    let URLCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 25 * 1024 * 1024, diskPath: nil)
    NSURLCache.setSharedURLCache(URLCache)

    return true
  }
  
}

