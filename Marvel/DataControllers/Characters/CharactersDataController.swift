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
    
    func loadDataPersisted(completion: @escaping CharactersResult) {
        let characters = self.persistence.getPersistedCharacters()
        let hasCharacters = characters.count > 0
        
        if hasCharacters{
            completion(.success(CharacterDataType(characters:characters)))
        } else {
            // Spec: this if statement when there's no characters persisted
            // only can occur the first time the user open the APP and 
            // there's no internet connection
            completion(.failure(CharactersError.noInternet(message: "Seems like you don't have internet connection and don't have data persisted!")))
        }
    }
    
    func loadDataFromServer(completion: @escaping CharactersResult) {
        self.service.getCharacters { charactersResult in
            switch charactersResult {
            case .success(let characters):
                self.persistence.persistCharacters(characters: characters,
                    success: {
                        let charactersPersisted = self.persistence.getPersistedCharacters()
                    	completion(.success(CharacterDataType(characters: charactersPersisted)))
                    }, fail: { (error) in
                        completion(.failure(error))
                    }
                )
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadData(completion: @escaping CharactersResult) {
        if self.reachabilityManager.isReachable() {
            loadDataFromServer { result in
                switch result {
                case .success(let characters):
                    completion(.success(characters))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            loadDataPersisted { result in
                switch result {
                case .success(let characters):
                    completion(.success(characters))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        //if the connection status change
        self.reachabilityManager.manager?.listener = { status in
            switch status {
            case .notReachable:
                break
            case .reachable(_), .unknown:
                self.loadDataFromServer { result in
                    switch result {
                    case .success(let characters):
                        completion(.success(characters))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        self.reachabilityManager.manager?.startListening()
    }
    
    deinit{
        self.reachabilityManager.manager?.stopListening()
    }
}
