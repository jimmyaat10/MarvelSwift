//
//  CharacterDataSource.swift
//  Marvel
//
//  Created by Albert Arroyo on 5/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit

class CharacterDataSource: DataSource {
    
    init() {
        super.init(dataObject: CharacterDataType())
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let
            cell = tableView.dequeueReusableCellWithIdentifier("CharacterCell", forIndexPath: indexPath) as? CharacterCell,
            character = dataObject as? CharacterDataType else {
                fatalError("Could not create CharacterCell")
        }
        cell.configureCell(character[indexPath.row])
        return cell
    }
    
}

