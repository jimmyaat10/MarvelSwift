//
//  RealmMigration.swift
//  Marvel
//
//  Created by Albert Arroyo on 6/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import RealmSwift

struct RealmMigration {
    
    /// Realm Objects implicateds in the migration (used in RealmConfig)
    static var currentObjectTypes: [Object.Type] = {
        return [CharacterModel.self, ItemModel.self, ThumbnailModel.self, UrlModel.self]
    }()
    
    static func migrate(migration: Migration, fileSchemaVersion: UInt64) {
        // Example of migrate function 
        //        if fileSchemaVersion < 2 {
        //            print("AAT migrate from 1 to 2")
        //
        //            migration.enumerateObjects(ofType: "CharacterModel", {oldObject, newObject in
        //
        //                if let newObject = newObject {
        //                    let dateFormatter = DateFormatter()
        //                    dateFormatter.dateFormat = ""yyyy-MM-dd'T'HH:mm:ssZ""
        //                    if let oldObject = oldObject,
        //                        let modifiedAt = oldObject["modifiedAt"] as? Date {
        //                        newObject["modifiedAt"] = dateFormatter.string(from: modifiedAt)
        //                    }
        //                }
        //                
        //            })
        //            
        //        }
    }
}

