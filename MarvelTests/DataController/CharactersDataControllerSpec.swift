//
//  CharactersDataControllerSpec.swift
//  Marvel
//
//  Created by Albert Arroyo on 26/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Nimble
import Quick
import Alamofire
import RealmSwift

@testable import Marvel

class CharactersDataControllerSpec: QuickSpec {
    
    private let manager = NetworkReachabilityManager(host: Router.baseURLString)
    
    override func spec() {
        
        let dataController = CharactersDataController()
        var numberOfResults : Int!
        var errorCodeNumber : Int!
        var hasCharacters : Bool!
        
        describe("character data controller loadDataFromServer") {
            
            beforeEach({
                waitUntil(timeout: 5, action: { (done) in
                    if self.manager!.isReachable {
                        dataController.loadDataFromServer(success: { (characters) in
                            numberOfResults = characters.numberOfItems
                            done()
                            }, fail: { (error) in
                                numberOfResults = 0
                                done()
                        })
                    } else {
                        let charactersPersisted = PersistenceManager.sharedInstance.getPersistedCharacters()
                        hasCharacters = charactersPersisted.count > 0
                        
                        if hasCharacters! {
                            numberOfResults = charactersPersisted.count
                        } else {
                            numberOfResults = 0
                        }
                        done()
                    }
                })
            })
            
            context("number of results", {
                it("compare the number of results with internet connection, should be 20") {
                    if self.manager!.isReachable {
                        expect(numberOfResults) == 20
                    }
                }
            })
            context("number of results", {
                it("compare the number of results with no internet connection, should be 20 if there's data persisted") {
                    if !self.manager!.isReachable {
                        if hasCharacters! {
                            expect(numberOfResults) == 20
                        }
                    }
                }
            })
            context("number of results", {
                it("compare the number of results with no internet connection, should be 0 if there's no data persisted") {
                    if !self.manager!.isReachable {
                        if !hasCharacters! {
                            expect(numberOfResults) == 0
                        }
                    }
                }
            })
        }
        
        describe("character data controller loadDataPersisted with no data persisted") {
            beforeEach({
                waitUntil(timeout: 5, action: { (done) in
                    //delete database
                    let realm = try! Realm()
                    try! realm.write {
                        realm.deleteAll()
                    }
                    dataController.loadDataPersisted(success: { (characters) in
                        numberOfResults = characters.numberOfItems
                        done()
                        }, fail: { (error) in
                            numberOfResults = 0
                            errorCodeNumber = error.code
                            done()
                    })
                    
                })
            })
            
            context("number of results", {
                it("compare the number of results, should be 0") {
                    expect(numberOfResults) == 0
                }
            })
            context("error code number", {
                it("compare the error code, should be 5000") {
                    expect(errorCodeNumber) == 5000
                }
            })
        }
    }
}


