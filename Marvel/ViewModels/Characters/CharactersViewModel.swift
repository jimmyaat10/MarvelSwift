//
//  CharactersTableViewModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit

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
    
    func loadData(success: @escaping () -> Void, fail: @escaping (_ error: Error) -> Void) {
        dataController.loadData { result in
            switch result {
            case .success(let characters):
                self.arrayCharacters = characters
                success()
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func filterContentForSearchText(searchText: String,
                                    completion: (CharacterDataType) -> Void,
                                    fail: (_ error: Error, _ defaultResults: (CharacterDataType)) -> Void) {
        if searchText.characters.count > 0 {
            self.arraySearchCharacters = self.arrayCharacters
            self.arraySearchCharacters.filterCharacters(with: searchText)
            if self.arraySearchCharacters.numberOfItems == 0 {
                fail(CharactersError.searchNoResultsFound(message: "No results found"), self.arrayCharacters)
            } else {
                completion(self.arraySearchCharacters)
            }
        } else {
            fail(CharactersError.searchTextEmpty(message: "Search text empty"), self.arrayCharacters)
        }
    }
}
