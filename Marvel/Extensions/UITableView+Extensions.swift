//
//  UITableView+Extensions.swift
//  Marvel
//
//  Created by Albert Arroyo on 2/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func registerCustomCell<T: UITableViewCell>(type: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.className)
    }
    
    public func registerCustomCellNib<T: UITableViewCell>(type: T.Type) {
        self.register(UINib(nibName: T.className, bundle: nil), forCellReuseIdentifier: T.className)
    }
    
    public func dequeueReusableCell<T:UITableViewCell>(type: T.Type) -> T? {
        let fullName = T.className
        return self.dequeueReusableCell(withIdentifier: fullName) as? T
    }
    
    public func dequeueReusableCell<T:UITableViewCell>(type: T.Type, forIndexPath indexPath:IndexPath) -> T? {
        let fullName = T.className
        return self.dequeueReusableCell(withIdentifier: fullName, for:indexPath as IndexPath) as? T
    }
}

