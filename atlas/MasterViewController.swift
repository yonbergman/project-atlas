//
//  MasterViewController.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/6/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, YBNetrunnerDelegate {

    var detailViewController: DetailViewController? = nil
    var netrunnerDB = YBNetrunnerDB()


    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        netrunnerDB.myDelegate = self
        netrunnerDB.fetchCards()
    }

    // #pragma mark - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let card = netrunnerDB[indexPath.row]
            (segue.destinationViewController as DetailViewController).card = card
        }
    }

    // #pragma mark - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return netrunnerDB.count()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let card = netrunnerDB[indexPath.row]
        cell.textLabel.text = card.title
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
//            let object = objects[indexPath.row] as NSDate
//            self.detailViewController!.detailItem = object
        }
        
    }
    
    // #pragma mark - Netrunner DB Delegate
    
    func fetchedCards() {
        self.tableView.reloadData()
    }


}

