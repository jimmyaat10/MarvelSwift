//
//  RealmConfig.swift
//  Marvel
//
//  Created by Albert Arroyo on 6/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmConfig {
    
    private static let mainConfig = Realm.Configuration(
        fileURL: URL.inDocumentsFolder(fileName:"main.realm"),
        schemaVersion: 1,
        migrationBlock: RealmMigration.migrate,
        objectTypes: RealmMigration.currentObjectTypes
    )
        
    case main
    case test(String)
    
    var configuration: Realm.Configuration {
        switch self {
        case .main:
            return RealmConfig.mainConfig
        case .test(let memoryId):
            return Realm.Configuration(inMemoryIdentifier: memoryId)
        }
    }
    
}

