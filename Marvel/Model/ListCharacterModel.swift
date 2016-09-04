//
//  ListCharacterModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 24/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation
import SwiftyJSON

final class ListCharacterModel: NSObject, ResponseJSONObjectSerializable {
    
    let dataKey     = "data"
    let resultsKey  = "results"
    
    var characters: [CharacterModel]?
    
    required init(json: JSON) {
        
        self.characters = [CharacterModel]()
        if let charactersJSON = json[dataKey][resultsKey].array {
            for characterJSON in charactersJSON {
                let character = CharacterModel(json: characterJSON)
                self.characters?.append(character)
            }
        }
    }

}
