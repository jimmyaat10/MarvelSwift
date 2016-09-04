//
//  UrlModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation
import SwiftyJSON

final class UrlModel: NSObject, ResponseJSONObjectSerializable {
    
    let urlKey      = "url"
    let typeKey     = "type"
    
    var url: String?
    var type: String?
    
    required init?(json: JSON) {
        self.url = json[urlKey].string
        self.type = json[typeKey].string
    }
    
}
