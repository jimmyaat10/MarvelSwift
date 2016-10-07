//
//  ThumbnailModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class ThumbnailModel: Object {
    
    let pathKey         = "path"
    let extensionKey    = "extension"
    
    dynamic var path: String?
    dynamic var ext: String?
    
    override class func primaryKey() -> String? {
        return "path"
    }
    
    required convenience init?(json: JSON) {
        self.init()
        self.path = json[pathKey].string
        self.ext = json[extensionKey].string
    }
    
}
