//
//  CharactersTableViewModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit

enum CharactersErrorCode: Int {
    case SearchTextEmpty = 100
    case SearchNoResultsFound = 200
}

class CharactersViewModel {
    
    private let dataController: CharactersDataControllerType
    private let coordinator: SceneCoordinatorType
    
    var arrayCharacters = CharacterDataType()
    var arraySearchCharacters = CharacterDataType()
    
    lazy var viewTitle: String = {
        return NSLocalizedString("Characters", comment: "Characters")
    }()
    
    lazy var viewBackgroundColor = UIColor.white
    
    //TODO #4: Extend functionallity to load more than only 20 characters
    var searching: Bool = false
    var pageSize: UInt = 20
    var offset: UInt = 0
    var canGetMoreCharacters: Bool = true
    
    init(dataController: CharactersDataControllerType, coordinator: SceneCoordinatorType) {
        self.dataController = dataController
        self.coordinator = coordinator
    }
    
    func loadData(success: @escaping () -> Void,
                  fail: @escaping (_ error: NSError) -> Void) {
        dataController.loadData(
            success: { characters in
                self.arrayCharacters = characters
                success()
            }, fail: { error in
                fail(error)
            }
        )
    }
    
    func filterContentForSearchText(searchText: String,
                                    completion: (CharacterDataType) -> Void,
                                    fail:(_ error: NSError,
                                    _ defaultResults: (CharacterDataType)) -> Void) {
        if searchText.characters.count > 0 {
            self.arraySearchCharacters = self.arrayCharacters
            self.arraySearchCharacters.filterCharacters(with: searchText)
            if self.arraySearchCharacters.numberOfItems == 0 {
                let failureReason = "No results found"
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: "com.albertarroyo.Marvel.error", code: CharactersErrorCode.SearchNoResultsFound.rawValue, userInfo: userInfo)
                fail(error, self.arrayCharacters)
            } else {
                completion(self.arraySearchCharacters)
            }
        } else {
            let failureReason = "Search text empty"
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: "com.albertarroyo.Marvel.error", code: CharactersErrorCode.SearchTextEmpty.rawValue, userInfo: userInfo)
            fail(error, self.arrayCharacters)
        }
    }
}
