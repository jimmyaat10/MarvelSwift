//
//  ItemModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class ItemModel: Object {
    
    let resourceURIKey  = "resourceURI"
    let nameKey         = "name"
    let typeKey         = "type"
    
    dynamic var itemId = NSUUID().uuidString
    
    dynamic var resourceURI: String?
    dynamic var name: String?
    dynamic var type: String?
    
    convenience required init?(json: JSON) {
        self.init()
        resourceURI = json[resourceURIKey].string
        name = json[nameKey].string
        type = json[typeKey].string
    }
    
    override class func primaryKey() -> String? {
        return "itemId"
    }

}
