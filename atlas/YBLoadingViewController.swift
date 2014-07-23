//
//  YBLoadingViewController.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/11/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBLoadingViewController: UIViewController, YBNetrunnerDelegate {

    @IBOutlet weak var circularLoader : DACircularProgressView!
    
    lazy var cardDb = YBNetrunnerDB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardDb.myDelegate = self
        cardDb.loadCards()
    }
    
    func fetchedCards() {
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("loaded", sender: nil)
        }
    }
    
    func progressed(progress:Float){
        dispatch_async(dispatch_get_main_queue()) {
            self.circularLoader.progress = CGFloat(progress)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "loaded" {
            ((segue.destinationViewController as UINavigationController).topViewController as YBCardListViewController).netrunnerDB = cardDb
        }
    }
    
}
