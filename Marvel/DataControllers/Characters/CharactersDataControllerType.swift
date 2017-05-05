//
//  CharactersDataControllerType.swift
//  Marvel
//
//  Created by Albert Arroyo on 3/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation

/// Protocol for CharactersDataController methods (we can mock this in tests)
protocol CharactersDataControllerType {
    typealias CharactersResult = (CharacterDataType) -> Void
    typealias CharactersError = (_ error: NSError) -> Void
    
    /// Method to load the persisted characters
    func loadDataPersisted(success: @escaping CharactersResult, fail: @escaping CharactersError)
    /// Method to load the characters from the API
    func loadDataFromServer(success: @escaping CharactersResult, fail: @escaping CharactersError)
    /// Method to load the characters from the API or persisted depends on connection
    func loadData(success: @escaping CharactersResult, fail: @escaping CharactersError)
}
