//
//  AppAppearance.swift
//  Marvel
//
//  Created by Albert Arroyo on 2/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation
import UIKit

/// Struct to configure the general App Appearance (Bar buttons, Navigation Bar, ...)
struct AppAppearance {
    /// Method to install/apply all the general configurations
    static func install() {
        customizeSearchBar()
        customizeNavigationBar()
    }
    /// Method to configure the search bar (tintColor, ...)
    static func customizeSearchBar() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf:
            [UISearchBar.self]).tintColor = AppColors.white
    }
    /// Method to configure the navigation bar (tintColor, barTintColor, title, ...)
    static func customizeNavigationBar() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = AppColors.white
        navigationBarAppearace.barTintColor = AppColors.red
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:AppColors.white]
    }
    
}
