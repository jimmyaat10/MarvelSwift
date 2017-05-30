//
//  CharacterErrors.swift
//  Marvel
//
//  Created by Albert Arroyo on 30/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation

public enum CharactersError: Error {
    case noInternet(message: String)
    case searchTextEmpty(message: String)
    case searchNoResultsFound(message: String)
}

/// Extend our Error type to implement `Equatable`.
/// This must be done per individual concrete type
/// and can't be done in general for `ErrorType`.
extension CharactersError : Equatable {}

/// Implement the `==` operator as required by protocol `Equatable`.
/// In this case, the equality will be the same type and the same message error
public func ==(lhs: CharactersError, rhs: CharactersError) -> Bool {
    switch (lhs, rhs) {
    case (.noInternet(let l), .noInternet(let r)):
        return l == r
    case (.searchTextEmpty(let l), .searchTextEmpty(let r)):
        return l == r
    case (.searchNoResultsFound(let l), .searchNoResultsFound(let r)):
        return l == r
    default:
        return false
    }
}
