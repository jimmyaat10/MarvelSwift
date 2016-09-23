//
//  CharactersTableViewModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation
import Alamofire

enum CharactersErrorCode: Int {
    case SearchTextEmpty                 = 100
    case SearchNoResultsFound            = 200
}

class CharactersTableViewModel: NSObject {
    
    var arrayCharacters = CharacterDataType()
    var arraySearchCharacters = CharacterDataType()
    
    var viewTitle: String {
        return NSLocalizedString("Characters", comment: "Characters")
    }
    
    lazy var viewBackgroundColor = UIColor.whiteColor()
    
    //TODO #4: Extend functionallity to load more than only 20 characters
    var searching: Bool = false
    var pageSize: UInt = 20
    var offset: UInt = 0
    var canGetMoreCharacters: Bool = true
    
    func loadData(success:
        (Result<ListCharacterModel, NSError>) -> Void, fail:(error:NSError)->Void) {
        ApiManager.sharedInstance.getCharacters(
            {(result) in
                if let listChar = result.value?.characters {
                    self.arrayCharacters = CharacterDataType(characters:listChar)
                    success(result)
                }
            })
        {(error) in
            fail(error:error)
        }
    }
    
    func simulateLoadDataThatFails(completion: (Bool) -> Void) {
        //Simulate a delay of 2 seconds with dispatch, so will have to migrate to swift 3 #5 after :)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            completion(true)
        }
    }
    
    func filterContentForSearchText(searchText: String, completion: (CharacterDataType) -> Void, fail:(error:NSError, defaultResults: (CharacterDataType))->Void) {
        if searchText.characters.count > 0 {
            self.arraySearchCharacters = self.arrayCharacters
            self.arraySearchCharacters.filterCharacters(with: searchText)
            if self.arraySearchCharacters.numberOfItems == 0 {
                let failureReason = "No results found"
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: "com.albertarroyo.Marvel.error", code: CharactersErrorCode.SearchNoResultsFound.rawValue, userInfo: userInfo)
                fail(error: error, defaultResults: self.arrayCharacters)
            } else {
                completion(self.arraySearchCharacters)
            }
        } else {
            let failureReason = "Search text empty"
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: "com.albertarroyo.Marvel.error", code: CharactersErrorCode.SearchTextEmpty.rawValue, userInfo: userInfo)
            fail(error: error, defaultResults: self.arrayCharacters)
        }
    }
}