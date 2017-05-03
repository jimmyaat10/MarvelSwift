//
//  ApiServiceType.swift
//  Marvel
//
//  Created by Albert Arroyo on 3/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation

protocol ApiServiceType {
    func getCharacters(success: @escaping ([CharacterModel]?) -> Void, fail: @escaping (_ error:NSError) -> Void)
}
