//
//  PersistenceManager.swift
//  Marvel
//
//  Created by Albert Arroyo on 25/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import RealmSwift

/// Responsible to manage the persisted data (Realm for this APP)
final class PersistenceManager: PersistenceManagerType {
    
    private let configuration: Realm.Configuration
    
    /// convenience init method to add tests with a different configuration
    /// like inMemoryIdentifier, or fileURL, or with a file with preloaded info, etc
    /// - Parameters:
    ///   - configuration: Realm.Configuration, in this case RealmConfig enum
    init(configuration: Realm.Configuration = RealmConfig.main.configuration) {
        self.configuration = configuration
    }
    
    /// convenience method to return a Realm instance with configuration
    private func realm() -> Realm {
        return try! Realm(configuration: self.configuration)
    }
    
    func persistCharacters(characters: [CharacterModel]?,
                           success: () -> Void,
                           fail: (_ error: NSError) -> Void) {
        do {
            let realm = self.realm()
            try realm.write {
                characters.map { character in
                    realm.add(character, update: true)
                }
            }
            success()
        } catch let error as NSError {
            Utils.DLog(message: "PersistenceManager persistCharacters error: \(error)")
            fail(error)
        }
    }
    
    func getPersistedCharacters() -> Results<CharacterModel> {
        let realm = self.realm()
        return realm.objects(CharacterModel.self)
    }
    
    func deleteAll() {
        do {
            let realm = self.realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error as NSError {
            Utils.DLog(message: "PersistenceManager deleteAll error: \(error)")
        }
    }
}

