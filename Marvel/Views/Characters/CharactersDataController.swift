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
    
    func loadDataPersisted(success:(CharacterDataType) -> Void, fail:(_ error:NSError)->Void) {
        let characters = PersistenceManager.sharedInstance.getPersistedCharacters()
        let hasCharacters = characters.count > 0
        
        if hasCharacters{
            success(CharacterDataType(characters:characters))
        } else {
            let failureReason = "Seems like you don't have internet connection and don't have data persisted!"
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: "com.albertarroyo.Marvel.error", code: 5000, userInfo: userInfo)
            fail(error)
        }
    }
    
    func loadDataFromServer(success:@escaping (CharacterDataType) -> Void, fail:@escaping (_ error:NSError)->Void) {
        ApiManager.sharedInstance.getCharacters(
            success: {
                let characters = PersistenceManager.sharedInstance.getPersistedCharacters()
                success(CharacterDataType(characters:characters))
            })
        {(error) in
            fail(error)
        }
    }
    
    func loadData(success:@escaping (CharacterDataType) -> Void, fail:@escaping (_ error:NSError)->Void) {
        
        if manager!.isReachable {
            loadDataFromServer(success: { (characters) in
                success(characters)
                }, fail: { (error) in
                    fail(error)
            })
        } else {
            loadDataPersisted(success: { (characters) in
                success(characters)
                }, fail: { (error) in
                    fail(error)
            })
        }
        
        //if the connection status change
        manager?.listener = { status in
            switch status {
            case .notReachable:
                break
            case .reachable(_), .unknown:
                self.loadDataFromServer(success: { (characters) in
                    success(characters)
                    }, fail: { (error) in
                        fail(error)
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
