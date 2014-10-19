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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        application.statusBarStyle = .LightContent
        Parse.setApplicationId("EgQHHegfE3B4Bxa77C0RLY1IraE7mZkcqnYPCM62", clientKey: "tB23lnzYum8ds8VkQdeuyeA2lI515Rgx5WBsRY8P")
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        return true
    }

}

