//
//  CharacterModelTest.swift
//  Marvel
//
//  Created by Albert Arroyo on 28/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON

@testable import Marvel

class CharacterModelTests: QuickSpec {
    
    override func spec() {
        let id = "character id"
        let name = "character desc"
        
        let data:[String: AnyObject] =  ["id":id , "name" : name]
        
        var character: CharacterModel!
        
        beforeEach {
            character = CharacterModel(json: SwiftyJSON.JSON(data))
        }
        
        it("Character Model converts from JSON") {
            expect(character.id) == id
            expect(character.name) == name
        }
    }
}