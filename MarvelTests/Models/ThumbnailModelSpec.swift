//
//  ThumbnailModelSpec.swift
//  Marvel
//
//  Created by Albert Arroyo on 6/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON

@testable import Marvel

class ThumbnailModelSpec: QuickSpec {
    
    override func spec() {
        let path = "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784"
        let ext = "jpg"
        let data:[String: AnyObject] =  ["path" : path as AnyObject , "extension" : ext as AnyObject]
        var thumb: ThumbnailModel!
        
        beforeEach {
            thumb = ThumbnailModel(json: SwiftyJSON.JSON(data))
        }
        it("Thumbnail Model converts from JSON") {
           	expect(thumb.path) == path
            expect(thumb.ext) == ext
        }
    }
}

