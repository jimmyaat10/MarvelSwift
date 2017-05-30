//
//  ApiService.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ApiService: ApiServiceType {
    
    class Retrier: RequestRetrier {
        func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
            let shouldRetry = (error as NSError).code == NSURLErrorTimedOut
            completion(shouldRetry, 3)
        }
    }
    
    let sessionManager: Alamofire.SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
//        sessionManager.retrier = Retrier()
        return sessionManager
    }()

    fileprivate enum APIError: Error {
        
        static let errorDomain = "com.albertarroyo.Marvel.APIError"
        
        case InputStreamReadFailed
        case OutputStreamWriteFailed
        case ContentTypeValidationFailed
        case StatusCodeValidationFailed
        case DataSerializationFailed
        case StringSerializationFailed
        case JSONSerializationFailed(message: String)
        case PropertyListSerializationFailed
        case ListCharacterParseError(message: String)
        
    }
    
    func clearCache() -> Void {
        let cache = URLCache.shared
        cache.removeAllCachedResponses()
    }
    
    func printGetCharacters() -> Void {
        sessionManager.request(Router.getCharacters())
            .responseString { response in
                if let receivedString = response.result.value {
                    Utils.DLog(message: "receivedString: \(receivedString)", functionName: "printGetCharacters", fileName: "ApiManager")
                }
        }
    }
    
    func getCharacters(completion: @escaping (Result<[CharacterModel]>) -> Void ) {
        sessionManager.request(Router.getCharacters())
            .responseJSON { (response) in
                guard let json = response.result.value else {
                    Utils.DLog(message: "Not an array response!", functionName: "getCharacters", fileName: "ApiManager")
                    completion(.failure(APIError.JSONSerializationFailed(message: "JSON could not be serialized into response array")))
                    return
                }
                //TODO AAT: give it a functional approax
                let charactersList = ListCharacterModel.init(json: JSON(json))
                if let characters = charactersList.characters  {
                    completion(.success(characters))
                } else {
                    Utils.DLog(message: "Can't parse ListCharacterModel", functionName: "getCharacters", fileName: "ApiManager")
                    completion(.failure(APIError.ListCharacterParseError(message: "ListCharacters could not be parsed")))
                }
        }
    }
}
