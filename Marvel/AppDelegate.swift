//
//  AppDelegate.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        dump("Realm URL: \(Realm.Configuration.defaultConfiguration.fileURL)")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let controller = CharactersTableViewController();
        let navigationController:UINavigationController = UINavigationController(rootViewController: controller);
        
        self.window!.rootViewController = navigationController;
        
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        
        return true
    }
}

