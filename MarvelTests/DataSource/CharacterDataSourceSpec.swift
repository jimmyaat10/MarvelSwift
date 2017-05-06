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
                dataControllerTest.loadData(
                    success: { (characters) in
                        charactersData = characters
                        dataSource.dataObject = charactersData
                }, fail: { (error) in
                    XCTFail("dataControllerTest.loadData failed")
                })
            }
            
            context("CellForRow", {
                it("second character name should be secondCharacterNameExpected") {
                    expect(charactersData.characterAtPosition(1).name) == secondCharacterNameExpected
                }
            })
        }
        
    }
}

fileprivate struct ApiServiceMock: ApiServiceType {
    
    let testTarget: AnyClass
    
    init(testTarget: AnyClass) {
        self.testTarget = testTarget
    }
    
    func getCharacters(success: @escaping ([CharacterModel]?) -> Void, fail: @escaping (_ error:NSError) -> Void) {
        let testBundle = Bundle(for: testTarget)
        let mock = MockLoader.init(file: "charactersResponse", in: testBundle)
        let characters = ListCharacterModel.init(json: JSON(data: (mock?.data)!))
        return success(characters.characters)
    }
}
