//
//  AlamofireRequest+JSONSerializable.swift
//  grokSwiftREST
//
//  Created by Christina Moulton on 2016-04-14.
//  Adapted by Albert Arroyo on 2016-08-29
//  Copyright © 2016 Teak Mobile Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension Alamofire.Request {
    
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
    
    public func responseObject<T: ResponseJSONObjectSerializable>(completionHandler:
        Response<T, NSError> -> Void) -> Self {
        let serializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            guard let responseData = data else {
                let failureReason = "Object could not be serialized because input data was nil."
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: "com.albertarroyo.Marvel.error", code: APIErrorCode.DataSerializationFailed.rawValue, userInfo: userInfo)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response,
                responseData, error)
            
            switch result {
            case .Failure(let error):
                return .Failure(error)
            case .Success(let value):
                let json = SwiftyJSON.JSON(value)
                // check for "message" errors in the JSON
                if let errorMessage = json["message"].string {
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    let error = NSError(domain: "com.albertarroyo.Marvel.error", code: APIErrorCode.DataSerializationFailed.rawValue, userInfo: userInfo)
                    return .Failure(error)
                }
                
                guard let object = T(json: json) else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: "com.albertarroyo.Marvel.error", code: APIErrorCode.JSONSerializationFailed.rawValue, userInfo: userInfo)
                    return .Failure(error)
                }
                return .Success(object)
            }
        }
        
        return response(responseSerializer: serializer, completionHandler: completionHandler)
    }
    
    public func responseArray<T: ResponseJSONObjectSerializable>(
        completionHandler: Response<[T], NSError> -> Void) -> Self {
        let serializer = ResponseSerializer<[T], NSError> { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            guard let responseData = data else {
                let failureReason = "Array could not be serialized because input data was nil."
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: "com.albertarroyo.Marvel.error", code: APIErrorCode.DataSerializationFailed.rawValue, userInfo: userInfo)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response,
                responseData, error)
            
            switch result {
            case .Failure(let error):
                return .Failure(error)
            case .Success(let value):
                let json = SwiftyJSON.JSON(value)
                // check for "message" errors in the JSON
                if let errorMessage = json["message"].string {
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    let error = NSError(domain: "com.albertarroyo.Marvel.error", code: APIErrorCode.DataSerializationFailed.rawValue, userInfo: userInfo)
                    return .Failure(error)
                }
                
                var objects: [T] = []
                for (_, item) in json {
                    if let object = T(json: item) {
                        objects.append(object)
                    }
                }
                return .Success(objects)
            }
        }
        
        return response(responseSerializer: serializer, completionHandler: completionHandler)
    }
}