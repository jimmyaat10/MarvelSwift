//
//  CharactersDataController.swift
//  Marvel
//
//  Created by Albert Arroyo on 25/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Alamofire
import RealmSwift

class CharactersDataController {
    
    private let manager = NetworkReachabilityManager(host: Router.baseURLString)
    
    func loadDataPersisted(success:(CharacterDataType) -> Void, fail:(error:NSError)->Void) {
        let characters = PersistenceManager.sharedInstance.getPersistedCharacters()
        let hasCharacters = characters.count > 0
        
        if hasCharacters{
            success(CharacterDataType(characters:characters))
        } else {
            let failureReason = "Seems like you don't have internet connection and don't have data persisted!"
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: "com.albertarroyo.Marvel.error", code: 5000, userInfo: userInfo)
            fail(error:error)
        }
    }
    
    func loadDataFromServer(success:(CharacterDataType) -> Void, fail:(error:NSError)->Void) {
        ApiManager.sharedInstance.getCharacters(
            {
                let characters = PersistenceManager.sharedInstance.getPersistedCharacters()
                success(CharacterDataType(characters:characters))
            })
        {(error) in
            fail(error:error)
        }
    }
    
    func loadData(success:(CharacterDataType) -> Void, fail:(error:NSError)->Void) {
        
        if manager!.isReachable {
            loadDataFromServer({ (characters) in
                success(characters)
                }, fail: { (error) in
                    fail(error: error)
            })
        } else {
            loadDataPersisted({ (characters) in
                success(characters)
                }, fail: { (error) in
                    fail(error: error)
            })
        }
        
        //if the connection status change
        manager?.listener = { status in
            switch status {
            case .NotReachable:
                break
            case .Reachable(_), .Unknown:
                self.loadDataFromServer({ (characters) in
                    success(characters)
                    }, fail: { (error) in
                        fail(error: error)
                })
                break
            }
        }
        
        manager?.startListening()
    }
    
    deinit{
        manager?.stopListening()
    }
}
