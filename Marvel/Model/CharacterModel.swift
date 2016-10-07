//
//  CharacterModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation
import SwiftyJSON

final class CharacterModel: NSObject {
    
    let idKey            = "id"
    let nameKey          = "name"
    let descKey          = "description"
    let modifiedKey      = "modified"
    let thumbnailKey     = "thumbnail"
    let resourceURIKey   = "resourceURI"
    let comicsKey        = "comics"
    let seriesKey        = "series"
    let storiesKey       = "stories"
    let eventsKey        = "events"
    let urlsKey          = "urls"
    
    var id: String!
    var name: String!
    var desc: String!
    var modifiedAt: Date?
    var thumbnail: ThumbnailModel?
    var resourceURI: String
    var comics: ListModel?
    var series: ListModel?
    var stories: ListModel?
    var events: ListModel?
    var urls: [UrlModel]?
    
    static let sharedDateFormatter = CharacterModel.dateFormatter()
    static let sharedDateFormatterToShow = CharacterModel.dateFormatterToShow()
    
    required init(json: JSON){
    
        self.id = json[idKey].stringValue
        self.name = json[nameKey].stringValue
        self.desc = json[descKey].stringValue
        
        let dateFormatter = CharacterModel.sharedDateFormatter
        if let modifiedDateString = json[modifiedKey].string {
            self.modifiedAt = dateFormatter.date(from: modifiedDateString)
        }
        
        if json[thumbnailKey].dictionary != nil {
            if let thumb = ThumbnailModel(json: json[thumbnailKey]) {
                self.thumbnail = thumb
            }
        }
        
        self.resourceURI = json[resourceURIKey].stringValue
        
        if let comicJSON = json[comicsKey].dictionary {
            self.comics = ListModel(json: JSON(comicJSON))
        }
        
        if let seriesJSON = json[seriesKey].dictionary {
            self.series = ListModel(json: JSON(seriesJSON))
        }
        
        if let storiesJSON = json[storiesKey].dictionary {
            self.stories = ListModel(json: JSON(storiesJSON))
        }
        
        if let eventsJSON = json[eventsKey].dictionary {
            self.events = ListModel(json: JSON(eventsJSON))
        }
        
        self.urls = [UrlModel]()
        if let urlsJSON = json[urlsKey].dictionary {
            for (_, urlJSON) in urlsJSON {
                if let url = UrlModel(json: urlJSON) {
                    self.urls?.append(url)
                }
            }
        }
    }
    
    func formatModifiedDateToString() -> String {
        let dateFormatter = CharacterModel.sharedDateFormatterToShow
        return dateFormatter.string(from: self.modifiedAt!)
    }
    
    class func dateFormatter() -> DateFormatter {
        let aDateFormatter = DateFormatter()
        aDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        aDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        aDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return aDateFormatter
    }
    
    class func dateFormatterToShow() -> DateFormatter {
        let aDateFormatter = DateFormatter()
        aDateFormatter.dateFormat = "MMM d, yyyy"
        aDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        aDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return aDateFormatter
    }
    
}
