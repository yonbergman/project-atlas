//
//  MasterViewController.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/6/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBCardListViewController: UITableViewController, UISearchDisplayDelegate, YBNetrunnerDelegate {

    var netrunnerDB = YBNetrunnerDB()
    var photoBrowser:IDMPhotoBrowser?
    
    var searchResults:YBNetrunnerCard[] = []{
        didSet{
            self.searchPhotoBrowser = createPhotoBrowserFromCards(searchResults)
        }
    }
    var searchPhotoBrowser:IDMPhotoBrowser?

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        netrunnerDB.myDelegate = self
        netrunnerDB.fetchCards()
    }
    
    // #pragma mark - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchResults(tableView) {
            return searchResults.count
        } else {
            return netrunnerDB.count()
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as YBCardTableViewCell
        cell.card = cardAt(tableView, indexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var browser:IDMPhotoBrowser? = photoBrowser
        if inSearchResults(tableView) {
            browser = searchPhotoBrowser
        }
        self.displayCardInPhotoBrowser(indexPath, forBrowser: browser)
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 50.0
    }
    
    func cardAt(tableView: UITableView,  indexPath: NSIndexPath) -> YBNetrunnerCard{
        if inSearchResults(tableView) {
            return searchResults[indexPath.row]
        } else {
            return netrunnerDB[indexPath.row]
        }
    }
    
    func inSearchResults(tableView: UITableView) -> Bool{
        return tableView == searchDisplayController.searchResultsTableView
    }

    // #pragma mark - Netrunner DB Delegate
    
    func fetchedCards() {
        self.tableView.reloadData()
        setupPhotoBrowser()
    }
    
    // #pragma mark - Photo Browser
    
    func displayCardInPhotoBrowser(indexPath: NSIndexPath, forBrowser: IDMPhotoBrowser?){
        if let browser = forBrowser{
            browser.setInitialPageIndex(indexPath.row)
            self.presentViewController(browser, animated: true, completion: nil)
        }
    }
    
    func createPhotoBrowserFromCards(cards:YBNetrunnerCard[]) -> IDMPhotoBrowser{
        var photos:IDMPhoto[] = cards.map { card in
            let photo = IDMPhoto(URL: card.imageURL)
            photo.caption = card.title
            return photo
        }
        let browser = IDMPhotoBrowser(photos: photos)
        browser.displayArrowButton = false
        browser.displayActionButton = false
        return browser
    }
    
    func setupPhotoBrowser(){
        self.photoBrowser = self.createPhotoBrowserFromCards(netrunnerDB.cards)
    }
    
    // #pragma mark - Searching
    
    @IBAction func startSearch(sender : UIBarButtonItem) {
        showSearchBar()
        self.searchDisplayController.searchBar.becomeFirstResponder()
    }
    
    func hideSearchBar() {
        self.searchDisplayController.searchBar.hidden = true
        self.tableView.contentOffset = CGPointMake(0.0, self.searchDisplayController.searchBar.frame.height);
    }
    
    func showSearchBar(){
        self.searchDisplayController.searchBar.hidden = false
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
        
    }

    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool{
        let trimmedString = searchString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.searchResults = netrunnerDB.cards.filter { card in
            card.matches(trimmedString)
        }
        return true
    }

}

