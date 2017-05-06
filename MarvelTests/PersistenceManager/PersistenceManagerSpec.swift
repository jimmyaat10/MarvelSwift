//
//  PersistenceManagerSpec.swift
//  Marvel
//
//  Created by Albert Arroyo on 6/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation
import Nimble
import Quick
import RealmSwift
import SwiftyJSON

@testable import Marvel

class PersistenceManagerSpec: QuickSpec {
    
    override func spec() {
        
        describe("persistence manager test config") {
            
            let sut = PersistenceManager(configuration: RealmConfig.test("PersistenceManagerSpec").configuration)
            
            afterEach {
                sut.deleteAll()
            }
            
            context("persist characters", {
                let testBundle = Bundle(for: CharacterDataSourceSpec.self)
                let mock = MockLoader.init(file: "charactersResponse", in: testBundle)
                let mockData = (mock?.data)!
                let json = JSON(data: mockData)
                let charactersList = ListCharacterModel.init(json: json)
                
                sut.persistCharacters(characters: charactersList.characters, success: {
                    it("compare the number of characters persisted, should be 2") {
                        expect(sut.getPersistedCharacters().count).to(equal(2))
                    }
                }, fail: { (error) in
                    XCTFail("persist characters doesn't return correctly. Error: \(error)")
                })
                
            })
        }
    }
}
