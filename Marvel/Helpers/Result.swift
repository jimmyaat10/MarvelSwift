//
//  Result.swift
//  Marvel
//
//  Created by Albert Arroyo on 30/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
extension Result {
    public func map<U>(_ transform: (T) -> U) -> Result<U> {
        switch self {
        case let .success(value):
            return .success(transform(value))
        case let .failure(error):
            return Result<U>.failure(error)
        }
    }
    
    public func flatMap<U>(_ transform: (T) -> Result<U>) -> Result<U> {
        switch self {
        case let .success(value):
            let newValue = transform(value)
            return newValue
        case let .failure(error):
            return Result<U>.failure(error)
        }
    }
    
    public var value: T? {
        switch self {
        case let .success(value):
            return value
        case .failure:
            return nil
        }
    }
}
