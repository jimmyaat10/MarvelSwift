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

    func insertTopRowIn(_ tableView: UITableView)
    func deleteRowAtIndexPath(_ indexPath: IndexPath, from tableView: UITableView)
}

extension SourceType {
    func insertTopRowIn(_ tableView: UITableView) {
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
    
    func deleteRowAtIndexPath(_ indexPath: IndexPath, from tableView: UITableView) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

