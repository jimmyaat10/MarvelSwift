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
    static let sharedInstance = ApiManager()
    
    func clearCache() -> Void {
        let cache = NSURLCache.sharedURLCache()
        cache.removeAllCachedResponses()
    }
    
    func printGetCharacters() -> Void {
        Alamofire.request(Router.GetCharacters())
            .responseString { response in
                if let receivedString = response.result.value {
                    print("printGetCharacters: ",receivedString)
                }
        }
    }
    
    func getCharacters(success:
        (Result<ListCharacterModel, NSError>) -> Void, fail:(error:NSError)->Void) {
        Alamofire.request(Router.GetCharacters())
            .responseObject { (response:Response<ListCharacterModel, NSError>) in
                switch response.result {
                    case .Success( _):
                        success(response.result)
                    case .Failure(let error):
                        fail(error: error)
                }
        }
    }
    
    
}