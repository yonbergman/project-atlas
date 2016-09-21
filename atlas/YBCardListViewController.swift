//
//  MasterViewController.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/6/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit
import IDMPhotoBrowser

class YBCardListViewController: UITableViewController, UISearchDisplayDelegate, YBNetrunnerDelegate, IDMPhotoBrowserDelegate {

  var netrunnerDB = YBNetrunnerDB(){
    didSet{
      netrunnerDB.myDelegate = self
      setupPhotoBrowser()
    }
  }
  var photoBrowser: IDMPhotoBrowser?

  var searchResults = [YBNetrunnerCard](){
    didSet{
      self.searchPhotoBrowser = createPhotoBrowserFromCards(searchResults)
    }
  }
  var searchPhotoBrowser: IDMPhotoBrowser?

  override func awakeFromNib() {
    super.awakeFromNib()
    self.clearsSelectionOnViewWillAppear = false
  }

  // MARK: Table View

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if inSearchResults(tableView) {
      return searchResults.count
    } else {
      return netrunnerDB.count()
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! YBCardTableViewCell
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
      browser.setInitialPageIndex(UInt(indexPath.row))
      self.presentViewController(browser, animated: true, completion: nil)
    }
  }

  func createPhotoBrowserFromCards(cards:[YBNetrunnerCard]) -> IDMPhotoBrowser{
    let photos:[IDMPhoto] = cards.map { card in
      var photo:IDMPhoto
      photo = IDMPhoto(URL: card.imageURL)
//      if card.imageSrc != "" {
//        photo = IDMPhoto(URL: card.imageURL)
//      } else {
//        photo = IDMPhoto(image: UIImage(named: "no-image"))
//      }
      photo.caption = card.title + "\n" + card.subtitle

      return photo
    }
    let browser = IDMPhotoBrowser(photos: photos)
    browser.displayDoneButton = true
    browser.delegate = self
    browser.displayArrowButton = false
    browser.displayActionButton = true
    browser.displayCounterLabel = false
    browser.presentedActivityViewControllerApplicationActivities = [YBNetrunnerDbActivity(netrunnerDB: self.netrunnerDB)]

    return browser
  }

  func setupPhotoBrowser(){
    self.photoBrowser = self.createPhotoBrowserFromCards(netrunnerDB.filteredCards)
  }


  func photoBrowser(photoBrowser:IDMPhotoBrowser!, didDismissAtPageIndex index:UInt){
    if photoBrowser == self.photoBrowser {
      setupPhotoBrowser()
    } else {
      self.searchPhotoBrowser = createPhotoBrowserFromCards(searchResults)
    }
    highlightCellAtRow(Int(index))
  }

  func highlightCellAtRow(index:Int){
    let tableView = self.currentTableView()
    let indexPath = NSIndexPath(forRow: index, inSection: 0)

    tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)

    let shouldScroll = !tableView.indexPathsForVisibleRows!.contains(indexPath)
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

  func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool{
    if let searchString = searchString {
      let dimensions = [
        "query": searchString
      ]
      self.searchResults = YBCardSearch(netrunnerDB: netrunnerDB).search(searchString)
    }
    return true
  }

  // MARK: Segues

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "sets" {
      let setVC = (segue.destinationViewController as! YBSetListViewController)
      setVC.netrunnerDB = self.netrunnerDB
    }
  }

  @IBAction func unwindToList(segue: UIStoryboardSegue) {
    netrunnerDB.refreshFilters()
    setupPhotoBrowser()
    self.tableView.reloadData()
  }

}

