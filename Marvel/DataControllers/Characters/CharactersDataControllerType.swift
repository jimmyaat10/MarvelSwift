//
//  CharactersDataControllerType.swift
//  Marvel
//
//  Created by Albert Arroyo on 3/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation

typealias CharactersResult = (Result<CharacterDataType>) -> Void

/// Protocol for CharactersDataController methods (we can mock this in tests)
protocol CharactersDataControllerType {
    
    /// Method to load the persisted characters
    func loadDataPersisted(completion: @escaping CharactersResult)
    /// Method to load the characters from the API
    func loadDataFromServer(completion: @escaping CharactersResult)
    /// Method to load the characters from the API or persisted depends on connection
    func loadData(completion: @escaping CharactersResult)
}
