//
//  CharacterDataSourceTests.swift
//  Marvel
//
//  Created by Albert Arroyo on 6/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import XCTest
import SwiftyJSON
import RealmSwift
@testable import Marvel

class CharacterDataSourceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }
    
    func testGetCharacters() {
        var charactersData : CharacterDataType!
        let dataSource = CharacterDataSource()
        let dataController = CharactersDataController(
            service: ApiServiceMock(testTarget: CharacterDataSourceTests.self),
            persistence: PersistenceManager()
        )
        var firstCharacter : CharacterModel!
        var numberOfItems : Int!
        var numberOfRows : Int!
        let tableView = UITableView()
        
        dataController.loadDataFromServer(
            success: { (characters) in
                charactersData = characters
                firstCharacter = charactersData.characterAtPosition(0)
                dataSource.dataObject = charactersData
                numberOfRows = dataSource.tableView(tableView, numberOfRowsInSection: 0)
                numberOfItems = charactersData.numberOfItems
            
                XCTAssertEqual(numberOfItems, 20, "When the WS success, the number of items should be 20")
                XCTAssertEqual(numberOfRows, numberOfItems, "When the WS success, the number of rows should be the number of items")
                XCTAssertEqual(firstCharacter.name, "3-D Man", "When the WS success, the name of the first character should be 3-D Man")
            
            }, fail: { error in
                numberOfItems = 0
                XCTAssertEqual(numberOfItems, 0, "When the WS fails, the number of items should be 0")
            }
        )
        
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
