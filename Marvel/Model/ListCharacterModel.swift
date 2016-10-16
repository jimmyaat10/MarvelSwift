//
//  ListCharacterModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 24/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import SwiftyJSON

final class ListCharacterModel: NSObject {
    
    let dataKey     = "data"
    let resultsKey  = "results"
    
    var characters: [CharacterModel]?
    
    required init(json: JSON) {
        super.init()
        
        self.characters = [CharacterModel]()
        if let charactersJSON = json[dataKey][resultsKey].array {
            _ = charactersJSON.map{ [unowned self] characterJSON in
                let character = CharacterModel(json: characterJSON)
                self.characters?.append(character!)
            }
        }
    }

}
