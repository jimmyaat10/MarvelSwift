//
//  PersistenceManager.swift
//  Marvel
//
//  Created by Albert Arroyo on 25/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import RealmSwift

class PersistenceManager {
    static let sharedInstance = PersistenceManager()
    
    private var realm: Realm!
    
    func persistCharacters(characters:[CharacterModel]?,success:
        () -> Void, fail:(_ error:NSError)->Void) {
        do {
            realm = try! Realm()
            try realm.write {
                characters.map{character in
                    realm.add(character,update: true)
                }
            }
            success()
        } catch let error as NSError {
            dump("PersistenceManager persistCharacters error: \(error)")
            fail(error)
        }
    }
    
    func getPersistedCharacters() -> Results<CharacterModel> {
        realm = try! Realm()
        return realm.objects(CharacterModel.self)
    }
    
}

