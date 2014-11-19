//
//  YBMenuTableViewController.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/20/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBSetListViewController: UITableViewController {
    
    var netrunnerDB:YBNetrunnerDB!

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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return netrunnerDB.sets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("setCell", forIndexPath: indexPath) as YBSetListViewCell
        let set = self.setForIndexPath(indexPath)
        cell.setName.text = set.name
        cell.cycleName.text = set.cycle
        cell.selected = set.selected
        return cell
    }
    
    func setForIndexPath(indexPath: NSIndexPath) -> YBNetrunnerSet{
        return netrunnerDB.sets[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
}
