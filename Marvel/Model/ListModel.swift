//
//  ComicModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import SwiftyJSON

final class ListModel: ResponseJSONObjectSerializable {
    
    let availableKey        = "available"
    let collectionURIKey    = "collectionURI"
    let itemsKey            = "items"
    let returnedKey         = "returned"
    
    var available: Int?
    var collectionURI: String?
    var items:[ItemModel]?
    var returned: Int?
    
    required init?(json: JSON) {
        self.available = json[availableKey].int
        self.collectionURI = json[collectionURIKey].string
        
        self.items = [ItemModel]()
        if let itemsJSON = json[itemsKey].dictionary {
            for (_, itemJSON) in itemsJSON {
                if let newItem = ItemModel(json: itemJSON) {
                    self.items?.append(newItem)
                }
            }
        }
        
        self.returned = json[returnedKey].int
    }
    
}
