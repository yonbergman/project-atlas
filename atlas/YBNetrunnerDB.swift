//
//  YBNetrunnerDB.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/6/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


@objc protocol YBNetrunnerDelegate {
  func fetchedCards()
  optional func progressed(progress:Float)
  optional func errorFetchingCards(error: NSError?)
}

class YBNetrunnerDB: NSObject{

  var baseURL: NSURL?
  var cards: [YBNetrunnerCard] = []
  var filteredCardsInternal: [YBNetrunnerCard] = []
  var filteredCards: [YBNetrunnerCard] {
    get {
      if self.filteredCardsInternal.isEmpty {
        self.filteredCardsInternal = self.filterCards()
      }
      return self.filteredCardsInternal
    }
  }
  func resetCardFilter(){
    self.filteredCardsInternal = []
  }
  var sets: [YBNetrunnerSet] = []
  var setMapping: [String: YBNetrunnerSet] = [:]
  var myDelegate :YBNetrunnerDelegate?

  func loadCards(){
    guard let baseURL = baseURL else {
      loadSettings()
      return
    }
    Alamofire.request(.GET, baseURL).progress({ bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
      let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
      self.myDelegate?.progressed?(progress)

    }).responseJSON {
      response in
      if response.result.isSuccess {
        if let data = response.data {
          let json = JSON(data: data)
          self.receivedJSON(json)
        } else {
          self.errorReceived(nil)
        }
      } else if response.result.isFailure {
        self.errorReceived(response.result.error)
      }
    }
    self.loadSets()
  }

  func loadSets(){
    let setURL = YBAppConfig.setsURL()
    
    Alamofire.request(.GET, setURL).responseJSON { response in
      if response.result.isSuccess {
        if let data = response.data {
          let json = JSON(data: data)
          self.receivedSetJSON(json)
        }
      }
    }
  }

  func loadSettings(){
    let cardURL = YBAppConfig.cardURL()
    self.baseURL = NSURL(string: cardURL)
    self.loadCards()
  }

  func receivedJSON(jsonCards: JSON){
    cards.removeAll(keepCapacity: true)
    let template = jsonCards["imageUrlTemplate"].stringValue
    for item in jsonCards["data"].arrayValue {
      let card = YBNetrunnerCard(json: item, imageTemplate: template)
      if card.isReal {
        cards.append(card)
      }
    }
    self.myDelegate?.fetchedCards()
  }

  private func receivedSetJSON(json: JSON) {
    sets.removeAll(keepCapacity: true)

    for item in json["data"].arrayValue {
      let set = YBNetrunnerSet(json: item)
      if set.isReal {
        sets.append(set)
        setMapping[set.code] = set
        //                set.delegate = self
      }
    }
    sets.sortInPlace { $0.idx < $1.idx }
  }

  func errorReceived(error: NSError?){
    self.myDelegate?.errorFetchingCards?(error)
  }

  func count() -> Int {
    return filteredCards.count
  }

  subscript(index: Int) -> YBNetrunnerCard {
    get {
      return filteredCards[index]
    }
  }

  func filterCards() -> Array<YBNetrunnerCard>{
    return self.cards.filter { (card) -> Bool in
      let set = self.setMapping[card.setCode]
      if set != nil {
        return set!.selected
      } else {
        return true
      }
    }
  }

  func refreshFilters() {
    self.resetCardFilter()
    self.count()
  }

  // MARK: Cycles

  func numberOfCycles() -> Int{
    return Int(self.sets.last!.cycleNumber) + 1
  }

  func cycle(cycleId:Int) -> [YBNetrunnerSet] {
    let cycleUint = UInt(cycleId)
    return self.sets.filter { (set) -> Bool in
      return set.cycleNumber == cycleUint
    }
  }

}
