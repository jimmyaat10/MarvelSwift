//
//  ThumbnailModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation
import SwiftyJSON

final class ThumbnailModel: NSObject, ResponseJSONObjectSerializable {
    
    let pathKey         = "path"
    let extensionKey    = "extension"
    
    var path: String?
    var ext: String?
    
    required init?(json: JSON) {
        self.path = json[pathKey].string
        self.ext = json[extensionKey].string
    }
    
}
