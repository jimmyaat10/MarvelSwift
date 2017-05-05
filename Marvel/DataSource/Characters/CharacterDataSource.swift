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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let
            cell = tableView.dequeueReusableCell(type: CharacterCell.self, forIndexPath: indexPath),
            let character = dataObject as? CharacterDataType else {
                fatalError("Could not create CharacterCell")
        }
        cell.configureCell(character[(indexPath as NSIndexPath).row])
        return cell
    }
    
}

