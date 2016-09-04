//
//  ApiRouter.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation
import Alamofire

func md5(str: String) -> String {
    var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
    CC_MD5(str, CC_LONG(str.utf8.count), &digest)
    return digest.reduce("") {
        $0 + String(format: "%02x", $1)
    }
}

let timeStamp = NSDate().iso8601
let keys = timeStamp + MarvelKey.`private` + MarvelKey.`public`
let hash = md5(keys)

enum Router: URLRequestConvertible {
    
    static let baseURLString:String = "https://gateway.marvel.com/v1/public/"
    
    case GetCharacters() // GET https://gateway.marvel.com/v1/public/characters
    
    var URLRequest: NSMutableURLRequest {
        var method: Alamofire.Method {
            switch self {
                case .GetCharacters:
                    return .GET
            }
        }
        
        let url:NSURL = {
            var addMarvelParams = "";
            addMarvelParams = addMarvelParams.stringByAppendingString("?ts=" + timeStamp)
            addMarvelParams = addMarvelParams.stringByAppendingString("&apikey=" + MarvelKey.`public`)
            addMarvelParams = addMarvelParams.stringByAppendingString("&hash=" + hash)
            
            // build up and return the URL for each endpoint
            let relativePath:String?
            switch self {
                case .GetCharacters():
                    relativePath = "characters\(addMarvelParams)"
            }
            
            let URL = NSURL(string: Router.baseURLString+relativePath!)!
            return URL
        }()
        
        let params: ([String: AnyObject]?) = {
            switch self {
                case .GetCharacters:
                    return nil
            }
        }()
        
        let URLRequest = NSMutableURLRequest(URL: url)
        
        let encoding = Alamofire.ParameterEncoding.JSON
        let (encodedRequest, _) = encoding.encode(URLRequest, parameters: params)
        
        encodedRequest.HTTPMethod = method.rawValue
        
        return encodedRequest
    }
}

