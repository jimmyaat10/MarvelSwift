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
        
        describe("character data source") {
            
            var charactersData = CharacterDataType()
            let dataSource = CharacterDataSource()
            let dataController = CharactersDataController(
                service: ApiServiceMock(testTarget: CharacterDataSourceSpec.self),
                persistence: PersistenceManager()
            )
            let tableView = UITableView()
            var numberOfRows : Int!
            var firstCharacter : CharacterModel!
            
            beforeEach({
                dataController.loadDataFromServer(
                    success: { characters in
                        charactersData = characters
                        firstCharacter = charactersData.characterAtPosition(0)
                        dataSource.dataObject = charactersData
                        numberOfRows = dataSource.tableView(tableView, numberOfRowsInSection: 0)
                    }, fail: { error in
                        numberOfRows = 0
                    }
                )
            })
            
            context("number of rows", {
                it("compare the number of rows, should be 20") {
                    expect(numberOfRows) == 20
                }
            })
            
            context("cell for row", {
                it("first character name should be 3-D Man") {
                    expect(firstCharacter.name) == "3-D Man"
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
