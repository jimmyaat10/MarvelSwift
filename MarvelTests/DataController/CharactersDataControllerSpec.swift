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
                
                let errorExpected: CharactersError = .noInternet(message: "Seems like you don't have internet connection and don't have data persisted!")
                var errorReceived: CharactersError!
                
                let sut = CharactersDataController(
                    service: serviceMock,
                    persistence: persistenceTest,
                    reachabilityManager: reachabilityMock
                )
                beforeEach({
                    waitUntil(timeout: 2, action: { done in
                        sut.loadData { charactersResult in
                            switch charactersResult {
                                case .success( _):
                                    done()
                                case .failure(let error):
                                    switch error {
                                    case CharactersError.noInternet(let message):
                                        errorReceived = CharactersError.noInternet(message: message)
                                    default:
                                        break
                                    }
                                    done()
                            }
                        }
                    })
                })
                it("should fail with error code noInternet") {
                    expect(errorReceived) == errorExpected
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
                    waitUntil(timeout: 2, action: { done in
                        sut.loadData { charactersResult in
                            switch charactersResult {
                            case .success(let characters):
                                numCharacters = characters.numberOfItems
                                done()
                            case .failure( _):
                                done()
                            }
                        }
                    })
                })
                it("number of characters should be 2") {
                    expect(numCharacters) == 2
                }
            })
        }
    }
}
