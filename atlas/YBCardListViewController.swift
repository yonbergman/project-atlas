//
//  MasterViewController.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/6/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBCardListViewController: UITableViewController, UISearchDisplayDelegate, YBNetrunnerDelegate, IDMPhotoBrowserDelegate {

    var netrunnerDB:YBNetrunnerDB = YBNetrunnerDB(){
        didSet{
            netrunnerDB.myDelegate = self
            setupPhotoBrowser()
        }
    }
    var photoBrowser:IDMPhotoBrowser?
    
    var searchResults:[YBNetrunnerCard] = []{
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
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Table View

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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
        return tableView == searchDisplayController?.searchResultsTableView
    }
    
    func currentTableView() -> UITableView {
        if searchDisplayController?.active == true{
            if let sdc = searchDisplayController {
                return sdc.searchResultsTableView
            }
        }
        return self.tableView
    }

    // MARK: Netrunner DB Delegate
    
    func fetchedCards() {
        self.tableView.reloadData()
        setupPhotoBrowser()
    }
    
    // MARK: Photo Browser
    
    func displayCardInPhotoBrowser(indexPath: NSIndexPath, forBrowser: IDMPhotoBrowser?){
        if let browser = forBrowser{
            PFAnalytics.trackEventInBackground("clicked-card", block: nil)
            browser.setInitialPageIndex(UInt(indexPath.row))
            self.presentViewController(browser, animated: true, completion: nil)
        }
    }
    
    func createPhotoBrowserFromCards(cards:[YBNetrunnerCard]) -> IDMPhotoBrowser{
        var photos:[IDMPhoto] = cards.map { card in
            let photo = IDMPhoto(URL: card.imageURL)
            photo.caption = card.title
            return photo
        }
        let browser = IDMPhotoBrowser(photos: photos)
        browser.delegate = self
        browser.displayArrowButton = false
        browser.displayActionButton = true

        return browser
    }
    
    func setupPhotoBrowser(){
        self.photoBrowser = self.createPhotoBrowserFromCards(netrunnerDB.filteredCards)
    }
    
    func photoBrowser(photoBrowser:IDMPhotoBrowser, didDismissAtPageIndex index:Int){
        highlightCellAtRow(index)
    }
    
    func highlightCellAtRow(index:Int){
        let tableView = self.currentTableView()
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        
        
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        
        let shouldScroll = contains(tableView.indexPathsForVisibleRows() as [NSIndexPath], indexPath);
        if shouldScroll {
            tableView.scrollToNearestSelectedRowAtScrollPosition(.Middle, animated: true)
        }
        
        let delay = Double(NSEC_PER_SEC) * 0.2
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay)), dispatch_get_main_queue()){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    // MARK: Searching
    
    @IBAction func startSearch(sender : UIBarButtonItem) {
        showSearchBar()
        self.searchDisplayController?.searchBar.becomeFirstResponder()
    }
    
    func hideSearchBar() {
        if let sdc = self.searchDisplayController {
            sdc.searchBar.hidden = true
            self.tableView.contentOffset = CGPointMake(0.0, sdc.searchBar.frame.height);
        }
    }
    
    func showSearchBar(){
        self.searchDisplayController?.searchBar.hidden = false
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool{
        var trimmedString = searchString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).lowercaseString
        
        let typeSearch = startsWith(trimmedString, "s:")
        if typeSearch {
            trimmedString.removeRange(Range(start:trimmedString.startIndex, end: advance(trimmedString.startIndex, 2)))
            
        }
        let dimensions = [
            "query": searchString
        ]
        PFAnalytics.trackEventInBackground("search", dimensions: dimensions, block: nil)
        self.searchResults = netrunnerDB.filteredCards.filter { card in
            if typeSearch{
                return card.matchType(trimmedString)
            } else {
                return card.matchTitle(trimmedString)
            }
        }
        return true
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sets" {
            PFAnalytics.trackEventInBackground("showSets", block: nil)
            let setVC = (segue.destinationViewController as YBSetListViewController)
            setVC.netrunnerDB = self.netrunnerDB
        }
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        PFAnalytics.trackEventInBackground("hideSets", block: nil)
        setupPhotoBrowser()
        self.tableView.reloadData()
        
    }

}

