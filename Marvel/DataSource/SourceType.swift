//
//  SourceType.swift
//  Marvel
//
//  Created by Albert Arroyo on 5/9/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit

protocol SourceType: UITableViewDataSource {
    var dataObject: DataType { get set }

    func insertTopRowIn(tableView: UITableView)
    func deleteRowAtIndexPath(indexPath: NSIndexPath, from tableView: UITableView)
}

extension SourceType {
    func insertTopRowIn(tableView: UITableView) {
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
    }
    
    func deleteRowAtIndexPath(indexPath: NSIndexPath, from tableView: UITableView) {
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
}

