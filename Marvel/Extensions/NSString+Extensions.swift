//
//  NSString+Extensions.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation

extension String {
    var dateFromISO8601: NSDate? {
        return NSDate.Formatter.iso8601.dateFromString(self)
    }
}