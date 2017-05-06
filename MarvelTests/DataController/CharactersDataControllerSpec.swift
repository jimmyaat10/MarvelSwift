//
//  CharactersDataControllerSpec.swift
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
import Alamofire

@testable import Marvel

class CharactersDataControllerSpec: QuickSpec {
    
    override func spec() {
        
        describe("character data controller") {
            
            let persistenceTest = PersistenceManager(configuration: RealmConfig.test("CharactersDataControllerSpec").configuration)
            let serviceMock = ApiServiceMock(testTarget: CharactersDataControllerSpec.self)
            
            afterEach {
                persistenceTest.deleteAll()
            }
            
            context("load persisted first time with no internet connection", {
                let reachabilityMock = AATReachabilityManagerMock(testInternet: false)
                
                var errorCode: Int = 0
                
                let sut = CharactersDataController(
                    service: serviceMock,
                    persistence: persistenceTest,
                    reachabilityManager: reachabilityMock
                )
                beforeEach({
                    waitUntil(timeout: 2, action: { (done) in
                        sut.loadData(success: { (characters) in
                            done()
                        }, fail: { (error) in
                            errorCode = error.code
                            done()
                        })
                    })
                })
                it("should fail with error code 5000") {
                    expect(errorCode) == 5000
                }
            })
            
            context("load persisted first time with internet connection", {
                let reachabilityMock = AATReachabilityManagerMock(testInternet: true)
                
                let sut = CharactersDataController(
                    service: serviceMock,
                    persistence: persistenceTest,
                    reachabilityManager: reachabilityMock
                )
                
                var numCharacters: Int = 0
                
                beforeEach({
                    waitUntil(timeout: 2, action: { (done) in
                        sut.loadData(success: { (characters) in
                            numCharacters = characters.numberOfItems
                            done()
                        }, fail: { (error) in
                            done()
                        })
                    })
                })
                it("number of characters should be 2") {
                    expect(numCharacters) == 2
                }
            })
        }
    }
}

fileprivate struct AATReachabilityManagerMock: Reachable {
    
    var manager: NetworkReachabilityManager?
    var testReachability: Bool = true
    
    init(testInternet: Bool) {
        self.testReachability = testInternet
    }
    
    func isReachable() -> Bool {
        return self.testReachability
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
