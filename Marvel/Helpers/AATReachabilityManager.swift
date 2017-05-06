//
//  AATReachabilityManager.swift
//  Marvel
//
//  Created by Albert Arroyo on 6/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation
import Alamofire

struct AATReachabilityManager: Reachable {
    
    var manager: NetworkReachabilityManager?
    
    init() {
        self.manager = NetworkReachabilityManager(host: Router.baseURLString)
    }
    
    func isReachable() -> Bool {
        return self.manager?.isReachable ?? false
    }
    
}
