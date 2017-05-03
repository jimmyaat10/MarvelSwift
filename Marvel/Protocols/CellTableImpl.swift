//
//  CellTableImpl.swift
//  Marvel
//
//  Created by Albert Arroyo on 3/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import UIKit

/// Protocol to organize the cell implementation
protocol CellTableImpl: class {
    
    /// Method to configure the cell with a generic object (normally a model)
    func configureCell<T>(_ data: T)
    
    static func reuseIdentifier() -> String
    static func nibName() -> UINib?
}


// MARK: - Default implementation to avoid implement in class -
extension CellTableImpl {
    
    static func nibName() -> UINib? {
        return nil
    }
    static func reuseIdentifier() -> String {
        return ""
    }
}
