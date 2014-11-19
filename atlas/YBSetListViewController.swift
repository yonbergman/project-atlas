//
//  YBMenuTableViewController.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/20/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

@objc protocol YBSetListDelegate {
    func setListDone()
}

class YBSetListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var netrunnerDB:YBNetrunnerDB!
    var delegate:YBSetListDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return netrunnerDB.sets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("setCell", forIndexPath: indexPath) as YBSetListViewCell
        let set = self.setForIndexPath(indexPath)
        cell.set = set;
        return cell
    }
    
    func setForIndexPath(indexPath: NSIndexPath) -> YBNetrunnerSet{
        return netrunnerDB.sets[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let set = setForIndexPath(indexPath)
        set.selected = !set.selected
        (tableView.cellForRowAtIndexPath(indexPath)? as YBSetListViewCell).set = set
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
