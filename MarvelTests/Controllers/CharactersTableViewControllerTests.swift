//
//  CharactersTableViewControllerTests.swift
//  Marvel
//
//  Created by Albert Arroyo on 5/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import XCTest
import Alamofire

@testable import Marvel

class CharactersTableViewControllerTests: XCTestCase {
    
    var charactersTableViewController = CharactersTableViewController()
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }
    
    func testGetCharacters() {
        var numberOfItems = 0
        
        let expectation = expectationWithDescription("Get Characters")
        ApiManager.sharedInstance.getCharacters(
            {(result) in
                if let listChar = result.value?.characters {
                    self.charactersTableViewController.charactersData = CharacterDataType(characters:listChar)
                    self.charactersTableViewController.dataSource.dataObject = self.charactersTableViewController.charactersData
                    
                    numberOfItems = self.charactersTableViewController.charactersData.numberOfItems
                    XCTAssertEqual(numberOfItems, 20, "When the WS success, the number of items should be 20")
                    expectation.fulfill()
                }
            })
        {(error) in
            numberOfItems = 0
            XCTAssertEqual(numberOfItems, 0, "When the WS fails, the number of items should be 0")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
