//
//  NSString+Extensions.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation

extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
    public var lastPathComponent: String? {
        return NSURL(fileURLWithPath: self).lastPathComponent
    }
}

// MARK: Localization Methods
extension String {
    /// Method to localize self.
    /// Adding a bundle parameter with default value provide the possibility to test the method
    /// mocking the correct bundle
    /// - Parameters:
    ///     - bundle: Bundle, by default Bundle.main
    /// - Returns: Localized string
    public func localized(bundle localizationBundle : Bundle = Bundle.main) -> String {
        return NSLocalizedString(self, bundle: localizationBundle, comment: "")
    }
}
