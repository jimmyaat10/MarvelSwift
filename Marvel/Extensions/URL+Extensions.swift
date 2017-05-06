//
//  URL+Extensions.swift
//  Marvel
//
//  Created by Albert Arroyo on 6/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation

extension URL {
    static func inDocumentsFolder(fileName: String) -> URL {
        return NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
            .appendingPathComponent(fileName)!
    }
}

