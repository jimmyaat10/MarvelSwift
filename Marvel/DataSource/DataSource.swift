//
//  DataSource.swift
//  Marvel
//
//  Created by Albert Arroyo on 5/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit

class DataSource: NSObject, SourceType {
    var dataObject: DataType
    
    init<A: DataType>(dataObject: A) {
        self.dataObject = dataObject
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObject.numberOfItems
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        fatalError("This method must be overridden")
    }
    
}

