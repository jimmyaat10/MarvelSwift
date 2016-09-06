//
//  CharacterModelTest.swift
//  Marvel
//
//  Created by Albert Arroyo on 28/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import Marvel

class CharacterModelTests: XCTestCase {
    
    let charactersJsonFileName = "characterResponse"
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }
    
    func testParseCharacterModelFromJSONResponse() {
        let expectation = expectationWithDescription("Parse Characters from response JSON File")
        var json : JSON!
        var character : CharacterModel!
        var id : String!
        let name : String! = "3-D Man"
        var desc : String!
        var modifiedAt : NSDate?
        var resourceURI : String!
        var thumbnail : ThumbnailModel?
        var thumbnailExtension : String?
        let expectedThumbnailExtension : String? = "jpg"
        var comic = ListModel?()
        var returnedComics : Int?
        let expectedReturnedComics : Int? = 11
        var urls = [UrlModel?]()
        var firstUrlType : String?
        let expectedfirstUrlType : String? = "detail"
        
        self.getDataFromFileWithSuccess { (data) -> Void in
            json = JSON(data: data)
            character = CharacterModel(json: json)
            
            id = json[character.idKey].stringValue
//            name = json[character.nameKey].stringValue
            desc = json[character.descKey].stringValue
            
            let dateFormatter = CharacterModel.sharedDateFormatter
            
            if let modifiedDateString = json[character.modifiedKey].string {
                modifiedAt = dateFormatter.dateFromString(modifiedDateString)
            }
            
            resourceURI = json[character.resourceURIKey].stringValue
            
            if json[character.thumbnailKey].dictionary != nil {
                if let thumb = ThumbnailModel(json: json[character.thumbnailKey]) {
                    thumbnail = thumb
                }
            }
            thumbnailExtension = thumbnail?.ext
            
            if let comicJSON = json[character.comicsKey].dictionary {
                comic = ListModel(json: JSON(comicJSON))
            }
            returnedComics = comic!.returned
            
            if let urlsJSONArr = json[character.urlsKey].array {
                for urlJSON in urlsJSONArr {
                    if let url = UrlModel(json: urlJSON) {
                        urls.append(url)
                    }
                }
            }
            if let urlsJSONDic = json[character.urlsKey].dictionary {
                for (_, urlJSON) in urlsJSONDic {
                    if let url = UrlModel(json: urlJSON) {
                        urls.append(url)
                    }
                }
            }
            firstUrlType = urls[0]!.type
            
            XCTAssertEqual(character.id, id, "Id should be the same")
            XCTAssertEqual(character.name, name, "Name should be the same")
            XCTAssertEqual(character.desc, desc, "Desc should be the same")
            XCTAssertEqual(character.modifiedAt, modifiedAt, "Modified date should be the same")
            XCTAssertEqual(character.resourceURI, resourceURI, "ResourceUri should be the same")
            XCTAssertEqual(thumbnailExtension, expectedThumbnailExtension, "Thumb Ext should be the same")
            XCTAssertEqual(returnedComics, expectedReturnedComics, "Comics returned should be the same")
            XCTAssertEqual(firstUrlType, expectedfirstUrlType, "First Url Type should be the same")
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    internal func getDataFromFileWithSuccess(success: ((data: NSData) -> Void)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let filePath = NSBundle.init(forClass: self.classForCoder).pathForResource(self.charactersJsonFileName, ofType:"json")
            let data = try! NSData(contentsOfFile:filePath!,
                options: NSDataReadingOptions.DataReadingUncached)
            success(data: data)
        })
    }
}