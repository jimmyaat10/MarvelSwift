//
//  UIView+Extensions.swift
//  Marvel
//
//  Created by Albert Arroyo on 3/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import UIKit

extension UIView {
    public func addSubviews(_ views: [UIView]) {
        views.forEach { eachView in
            self.addSubview(eachView)
        }
    }
}
