//
//  ViewConfiguration.swift
//  Marvel
//
//  Created by Albert Arroyo on 3/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation

/// Protocol to create a pattern for organize the view configuration
protocol ViewConfiguration: class {
    /// This method calls internally buildViewHierarchy, makeConstraints and setupViews with this order
    func setupViewConfiguration()
    /// Add elements to the view
    func buildViewHierarchy()
    /// Make the constraints for the view
    func makeConstraints()
    /// Configure the view appearance
    func setupViews()
}

extension ViewConfiguration {
    func setupViewConfiguration() {
        buildViewHierarchy()
        makeConstraints()
        setupViews()
    }
    
    func setupViews() {
        // Empty default implementation
    }
}

