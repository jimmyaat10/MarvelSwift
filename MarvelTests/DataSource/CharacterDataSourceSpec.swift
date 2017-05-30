//
//  CharacterDataSourceSpec.swift
//  Marvel
//
//  Created by Albert Arroyo on 5/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Nimble
import Quick
import RealmSwift
import SwiftyJSON

@testable import Marvel

class CharacterDataSourceSpec: QuickSpec {
    
    override func spec() {
        
        let secondCharacterNameExpected = "A-Bomb (HAS)"
        
        describe("character data source") {
            
            let persistenceTest = PersistenceManager(configuration: RealmConfig.test("CharacterDataSourceSpec").configuration)
            let dataControllerTest = CharactersDataController(
                service: ApiServiceMock(testTarget: CharacterDataSourceSpec.self),
                persistence: persistenceTest
            )

            var charactersData: CharacterDataType!
            let dataSource = CharacterDataSource()
            
            afterEach {
                persistenceTest.deleteAll()
            }
            
            beforeEach {
                dataControllerTest.loadData { result in
                    switch result {
                    case .success(let characters):
                        charactersData = characters
                        dataSource.dataObject = charactersData
                    case .failure(let error):
                        XCTFail("dataControllerTest.loadData failed error: \(error)")
                    }
                }
            }
            
            context("CellForRow", {
                it("second character name should be secondCharacterNameExpected") {
                    expect(charactersData.characterAtPosition(1).name) == secondCharacterNameExpected
                }
            })
        }
        
    }
}
