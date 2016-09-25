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
        () -> Void, fail:(error:NSError)->Void) {
        do {
            realm = try! Realm()
            try realm.write {
                for character in characters! {
                    realm.add(character,update: true)
                }
            }
            success()
        } catch let error as NSError {
            print("PersistenceManager persistCharacters error: \(error)")
            fail(error: error)
        }
    }
    
    func getPersistedCharacters() -> Results<CharacterModel> {
        realm = try! Realm()
        return realm.objects(CharacterModel.self)
    }
    
}

