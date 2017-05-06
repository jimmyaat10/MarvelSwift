//
//  CharactersDataController.swift
//  Marvel
//
//  Created by Albert Arroyo on 25/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation

/// Responsible to give the data from everywhere (Service or Persisted)
class CharactersDataController: CharactersDataControllerType {
    
    private let service: ApiServiceType
    private let persistence: PersistenceManagerType
    private let reachabilityManager: Reachable
    
    init(service: ApiServiceType, persistence: PersistenceManagerType, reachabilityManager: Reachable = AATReachabilityManager()) {
        self.service = service
        self.persistence = persistence
        self.reachabilityManager = reachabilityManager
    }
    
    func loadDataPersisted(success: @escaping CharactersResult, fail: @escaping CharactersError) {
        let characters = self.persistence.getPersistedCharacters()
        let hasCharacters = characters.count > 0
        
        if hasCharacters{
            success(CharacterDataType(characters:characters))
        } else {
            // Spec: this if statement when there's no characters persisted
            // only can occur the first time the user open the APP and 
            // there's no internet connection
            let failureReason = "Seems like you don't have internet connection and don't have data persisted!"
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: "com.albertarroyo.Marvel.error", code: 5000, userInfo: userInfo)
            fail(error)
        }
    }
    
    func loadDataFromServer(success: @escaping CharactersResult, fail: @escaping CharactersError) {
        self.service.getCharacters(
            success: { characters in
                if let characters = characters {
                    self.persistence.persistCharacters(characters: characters, success: {
                        let charactersPersisted = self.persistence.getPersistedCharacters()
                        success(CharacterDataType(characters: charactersPersisted))
                    }, fail: { (error) in
                        fail(error)
                    })
                }
            }, fail: { error in
                fail(error)
            }
        )
    }
    
    func loadData(success: @escaping CharactersResult, fail: @escaping CharactersError) {
        
        if self.reachabilityManager.isReachable() {
            loadDataFromServer(
                success: { characters in
                    success(characters)
                }, fail: { error in
                    fail(error)
                }
            )
        } else {
            loadDataPersisted(
                success: { characters in
                    success(characters)
                }, fail: { error in
                    fail(error)
                }
            )
        }
        
        //if the connection status change
        self.reachabilityManager.manager?.listener = { status in
            switch status {
            case .notReachable:
                break
            case .reachable(_), .unknown:
                self.loadDataFromServer(
                    success: { characters in
                        success(characters)
                    }, fail: { error in
                        fail(error)
                    }
                )
                break
            }
        }
        
        self.reachabilityManager.manager?.startListening()
    }
    
    deinit{
        self.reachabilityManager.manager?.stopListening()
    }
}
