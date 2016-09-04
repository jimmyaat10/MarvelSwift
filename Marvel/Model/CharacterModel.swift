//
//  CharacterModel.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import Foundation
import SwiftyJSON

final class CharacterModel: NSObject, ResponseJSONObjectSerializable {
    
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
    
    var id: String
    var name: String
    var desc: String
    var modifiedAt: NSDate?
    var thumbnail: ThumbnailModel?
    var resourceURI: String
    var comics: [ListModel]?
    var series: [ListModel]?
    var stories: [ListModel]?
    var events: [ListModel]?
    var urls: [UrlModel]?
    
    static let sharedDateFormatter = CharacterModel.dateFormatter()
    static let sharedDateFormatterToShow = CharacterModel.dateFormatterToShow()
    
    required init(json: JSON){
    
        self.id = json[idKey].stringValue
        self.name = json[nameKey].stringValue
        self.desc = json[descKey].stringValue
        
        let dateFormatter = CharacterModel.sharedDateFormatter
        if let modifiedDateString = json[modifiedKey].string {
            self.modifiedAt = dateFormatter.dateFromString(modifiedDateString)
        }
        
        if json[thumbnailKey].dictionary != nil {
            if let thumb = ThumbnailModel(json: json[thumbnailKey]) {
                self.thumbnail = thumb
            }
        }
        
        self.resourceURI = json[resourceURIKey].stringValue
        
        self.comics = [ListModel]()
        if let comicsJSON = json[comicsKey].dictionary {
            for (_, comicJSON) in comicsJSON {
                if let comic = ListModel(json: comicJSON) {
                    self.comics?.append(comic)
                }
            }
        }
        self.series = [ListModel]()
        if let seriesJSON = json[seriesKey].dictionary {
            for (_, serieJSON) in seriesJSON {
                if let serie = ListModel(json: serieJSON) {
                    self.series?.append(serie)
                }
            }
        }
        self.stories = [ListModel]()
        if let storiesJSON = json[storiesKey].dictionary {
            for (_, storyJSON) in storiesJSON {
                if let story = ListModel(json: storyJSON) {
                    self.stories?.append(story)
                }
            }
        }
        self.events = [ListModel]()
        if let eventsJSON = json[eventsKey].dictionary {
            for (_, eventJSON) in eventsJSON {
                if let event = ListModel(json: eventJSON) {
                    self.events?.append(event)
                }
            }
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
        return dateFormatter.stringFromDate(self.modifiedAt!)
    }
    
    class func dateFormatter() -> NSDateFormatter {
        let aDateFormatter = NSDateFormatter()
        aDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        aDateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        aDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return aDateFormatter
    }
    
    class func dateFormatterToShow() -> NSDateFormatter {
        let aDateFormatter = NSDateFormatter()
        aDateFormatter.dateFormat = "MMM d, yyyy"
        aDateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        aDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return aDateFormatter
    }
    
}