//
//  Character.swift
//  Marvel
//
//  Created by Albert Arroyo on 5/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit

struct CharacterDataType: DataType {
    
    private var characters: [CharacterModel] = []
    
    init(){
        
    }
    
    init(characters: [CharacterModel]) {
        self.characters = characters
    }
    
    var numberOfItems: Int {
        return characters.count
    }
    
    subscript(index: Int) -> CharacterModel {
        return characters[index]
    }
    
    func characterAtPosition(index: Int) -> CharacterModel {
        return characters[index]
    }
    
}

