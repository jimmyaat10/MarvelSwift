//
//  ApiRouter.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation
import Alamofire

func md5(_ str: String) -> String {
    var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
    CC_MD5(str, CC_LONG(str.utf8.count), &digest)
    return digest.reduce("") {
        $0 + String(format: "%02x", $1)
    }
}

let timeStamp = Date().iso8601
let keys = timeStamp + MarvelKey.`private` + MarvelKey.`public`
let hash = md5(keys)

enum Router: URLConvertible {
    
    static let baseURLString:String = "https://gateway.marvel.com/v1/public/"
    
    case getCharacters() // GET https://gateway.marvel.com/v1/public/characters
    
    func asURL() throws -> URL {
        let url:URL = {
            var addMarvelParams = "";
            addMarvelParams = addMarvelParams + ("?ts=" + timeStamp)
            addMarvelParams = addMarvelParams + ("&apikey=" + MarvelKey.`public`)
            addMarvelParams = addMarvelParams + ("&hash=" + hash)
            
            // build up and return the URL for each endpoint
            let relativePath:String?
            switch self {
            case .getCharacters():
                relativePath = "characters\(addMarvelParams)"
            }
            
            let URL = Foundation.URL(string: Router.baseURLString+relativePath!)!
            return URL
        }()
        
        return url;
    }
    
}

