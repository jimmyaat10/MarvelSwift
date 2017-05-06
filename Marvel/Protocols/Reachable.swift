//
//  Reachable.swift
//  Marvel
//
//  Created by Albert Arroyo on 6/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation
import Alamofire

protocol Reachable {
    
    var manager: NetworkReachabilityManager? { get set }
    
    /// Method to detect if there's connection
    func isReachable() -> Bool
}

