//
//  AATReachabilityManagerMock.swift
//  Marvel
//
//  Created by Albert Arroyo on 30/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation
import Alamofire
@testable import Marvel

public struct AATReachabilityManagerMock: Reachable {
    
    public var manager: NetworkReachabilityManager?
    var testReachability: Bool = true
    
    init(testInternet: Bool) {
        self.testReachability = testInternet
    }
    
    public func isReachable() -> Bool {
        return self.testReachability
    }
}
