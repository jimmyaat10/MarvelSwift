//
//  APIServiceMock.swift
//  Marvel
//
//  Created by Albert Arroyo on 30/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation
import SwiftyJSON
@testable import Marvel

public struct ApiServiceMock: ApiServiceType {
    
    let testTarget: AnyClass
    
    init(testTarget: AnyClass) {
        self.testTarget = testTarget
    }
    
    public func getCharacters(completion: @escaping (Result<[CharacterModel]>) -> Void ) {
        let testBundle = Bundle(for: testTarget)
        let mock = MockLoader.init(file: "charactersResponse", in: testBundle)
        let characters = ListCharacterModel.init(json: JSON(data: (mock?.data)!))
        return completion(.success(characters.characters!))
    }
}
