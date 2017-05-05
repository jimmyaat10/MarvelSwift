//
//  Character.swift
//  Marvel
//
//  Created by Albert Arroyo on 5/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit
import RealmSwift

struct CharacterDataType: DataType {
    
    var characters: Results<CharacterModel>?
    
    init(){
        
    }
    
    init(characters: Results<CharacterModel>) {
        self.characters = characters
    }
    
    var numberOfItems: Int {
        if let characters = characters {
            return characters.count
        } else {
            return 0;
        }
    }
    
    subscript(index: Int) -> CharacterModel {
        return characters![index]
    }
    
    func characterAtPosition(_ index: Int) -> CharacterModel {
        return characters![index]
    }
    
    /** PRE: text.characters.count > 0 **/
    mutating func filterCharacters(with text:String)
    {
        let predicate = NSPredicate(format: "name contains[c] '\(text)'")
        self.characters = self.characters!.filter(predicate)
    }
    
}

