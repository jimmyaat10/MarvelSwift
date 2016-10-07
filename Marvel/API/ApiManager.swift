//
//  ApiManager.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiManager {
    
    public enum APIErrorCode: Int {
        case InputStreamReadFailed           = -6000
        case OutputStreamWriteFailed         = -6001
        case ContentTypeValidationFailed     = -6002
        case StatusCodeValidationFailed      = -6003
        case DataSerializationFailed         = -6004
        case StringSerializationFailed       = -6005
        case JSONSerializationFailed         = -6006
        case PropertyListSerializationFailed = -6007
        
        /* Add custom error codes as you see fit */
        
    }


    static let sharedInstance = ApiManager()
    
    func clearCache() -> Void {
        let cache = URLCache.shared
        cache.removeAllCachedResponses()
    }
    
    func printGetCharacters() -> Void {
        Alamofire.request(Router.getCharacters())
            .responseString { response in
                if let receivedString = response.result.value {
                    print("printGetCharacters: ",receivedString)
                }
        }
    }
    
    func getCharacters(success: @escaping () -> Void, fail:@escaping (_ error:NSError)->Void) {
        Alamofire.request(Router.getCharacters())
            .responseJSON { (response) in
                guard let json = response.result.value else {
                    print("not an array response!")
                    let failureReason = "JSON could not be serialized into response array"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: "com.albertarroyo.Marvel.error", code: APIErrorCode.JSONSerializationFailed.rawValue, userInfo: userInfo)
                    
                    fail(error)
                    return
                }
                let characters = ListCharacterModel.init(json: JSON(json))
                PersistenceManager.sharedInstance.persistCharacters(characters: characters.characters, success: {
                    success()
                    }, fail: { (error) in
                        fail(error)
                })
        }
    }
    
    
}
