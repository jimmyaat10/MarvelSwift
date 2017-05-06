//
//  CharacterDataSourceTests.swift
//  Marvel
//
//  Created by Albert Arroyo on 6/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Marvel

class CharacterDataSourceTests: XCTestCase {
    
    let persistenceTest = PersistenceManager(configuration: RealmConfig.test("CharacterDataSourceTests").configuration)
    
    let numberOfRowsExpected: Int = 2
    let secondCharacterNameExpected: String = "A-Bomb (HAS)"
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        persistenceTest.deleteAll()
        super.tearDown()
    }
    
    func testGetCharacters() {
        var charactersData : CharacterDataType!
        let dataSource = CharacterDataSource()
        let dataController = CharactersDataController(
            service: ApiServiceMock(testTarget: CharacterDataSourceTests.self),
            persistence: persistenceTest
        )
        
        dataController.loadData(
            success: { (characters) in
                charactersData = characters
                dataSource.dataObject = charactersData
                let numberOfItems = charactersData.numberOfItems
            
                XCTAssertEqual(numberOfItems, self.numberOfRowsExpected, "When the WS success, the number of items should be numberOfRowsExpected")
                XCTAssertEqual(charactersData.characterAtPosition(1).name, self.secondCharacterNameExpected, "When the WS success, the name of the first character should be secondCharacterNameExpected")
            }, fail: { error in
                XCTFail("dataControllerTest.loadData failed")
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
