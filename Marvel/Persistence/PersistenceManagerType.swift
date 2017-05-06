//
//  PersistenceManagerType.swift
//  Marvel
//
//  Created by Albert Arroyo on 3/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation
import RealmSwift

protocol PersistenceManagerType {
    func persistCharacters(characters:[CharacterModel]?, success: () -> Void, fail: (_ error: NSError) -> Void)
    func getPersistedCharacters() -> Results<CharacterModel>
    func deleteAll()
}
