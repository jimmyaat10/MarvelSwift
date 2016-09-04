//
//  ItemModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation
import SwiftyJSON

final class ItemModel: NSObject, ResponseJSONObjectSerializable {
    
    let resourceURIKey  = "resourceURI"
    let nameKey         = "name"
    let typeKey         = "type"
    
    var resourceURI: String?
    var name: String?
    var type: String?
    
    required init?(json: JSON) {
        self.resourceURI = json[resourceURIKey].string
        self.name = json[nameKey].string
        self.type = json[typeKey].string
    }

}
