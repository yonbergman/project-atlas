//
//  YBReavealViewController.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/20/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBReavealViewController: PKRevealController {
    
    var navigationVC:UINavigationController {
        return self.frontViewController as UINavigationController
    }
    
    var netrunnerDB:YBNetrunnerDB?

    override func viewDidLoad() {
        super.viewDidLoad()

        let n = self.storyboard?.instantiateViewControllerWithIdentifier("nav") as UINavigationController?
        if let frontvc = n {
            let cardList = frontvc.topViewController as YBCardListViewController
            if netrunnerDB != nil{
                cardList.netrunnerDB = netrunnerDB!
            }
            self.frontViewController = frontvc
        }
        
        let m = self.storyboard?.instantiateViewControllerWithIdentifier("menu") as YBMenuTableViewController
        m.netrunnerDB = netrunnerDB!
        self.leftViewController = m
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
