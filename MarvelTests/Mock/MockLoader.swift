//
//  MockLoader.swift
//  Marvel
//
//  Created by Albert Arroyo on 2/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation
@testable import Marvel

struct MockLoader {
    
    let data: Data
    let json: String
    
    init?(file: String, withExtension fileExt: String = "json", in bundle:Bundle = Bundle.main) {
        guard let path = bundle.path(forResource: file, ofType: fileExt) else {
            return nil
        }
        let pathURL = URL(fileURLWithPath: path)
        do {
            data = try Data(contentsOf: pathURL, options: .dataReadingMapped)
            if let decoded = NSString(data: data, encoding: 0) as? String {
                json = decoded
            } else {
                return nil
            }
        } catch{
            return nil
        }
    }
}
